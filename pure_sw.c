///////////////////////////////////////
/// 640x480, 16-bit color VGA
/// Pure software AES-128 (ECB)
/// compile with:
///   gcc aes.c -o aes
///////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <math.h>
#include <termios.h>
#include <string.h>
#include <time.h>

/* ===== VGA / FPGA mappings (kept) ===== */
#define SDRAM_BASE            0xC0000000
#define SDRAM_END             0xC3FFFFFF
#define SDRAM_SPAN            0x04001000

#define FPGA_CHAR_BASE        0xC9000000
#define FPGA_CHAR_END         0xC9001FFF
#define FPGA_CHAR_SPAN        0x00002000

#define HW_REGS_BASE          0xff200000
#define HW_REGS_SPAN          0x00005000

/* graphics primitives */
void VGA_text (int, int, char *);
void VGA_text_clear();
void VGA_box (int, int, int, int, short);
void VGA_line(int, int, int, int, short);

/* 16-bit colors (RGB565) */
#define red        (0 + (0 << 5) + (31 << 11))
#define dark_red   (0 + (0 << 5) + (15 << 11))
#define green      (0 + (63 << 5) + (0 << 11))
#define dark_green (0 + (31 << 5) + (0 << 11))
#define blue       (31 + (0 << 5) + (0 << 11))
#define dark_blue  (15 + (0 << 5) + (0 << 11))
#define yellow     (0 + (63 << 5) + (31 << 11))
#define cyan       (31 + (63 << 5) + (0 << 11))
#define magenta    (31 + (0 << 5) + (31 << 11))
#define black      (0x0000)
#define gray       (15 + (31 << 5) + (51 << 11))
#define white      (0xffff)

#define VGA_PIXEL(x,y,color) do { \
    int *pixel_ptr; \
    pixel_ptr = (int *)((char *)vga_pixel_ptr + (((y) * 640 + (x)) << 1)); \
    *(short *)pixel_ptr = (color); \
} while (0)

#define VGA_READ_PIXEL(x,y) \
    (*(short *)((char *)vga_pixel_ptr + (((y) * 640 + (x)) << 1)))

void *h2p_lw_virtual_base;

volatile unsigned int *vga_pixel_ptr = NULL;
void *vga_pixel_virtual_base;

volatile unsigned int *vga_char_ptr = NULL;
void *vga_char_virtual_base;

int fd;

/* =====================================================================
   AES-128 software implementation (ECB mode, FIPS-197)
   ===================================================================== */

#define AES_BLOCK_SIZE 16
#define AES_KEY_SIZE   16
#define AES_NR         10
#define AES_NK         4
#define AES_NB         4

static const uint8_t sbox[256] = {
    0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76,
    0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0,
    0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15,
    0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75,
    0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84,
    0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf,
    0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8,
    0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2,
    0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73,
    0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb,
    0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79,
    0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08,
    0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a,
    0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e,
    0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf,
    0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16
};

static const uint8_t inv_sbox[256] = {
    0x52,0x09,0x6a,0xd5,0x30,0x36,0xa5,0x38,0xbf,0x40,0xa3,0x9e,0x81,0xf3,0xd7,0xfb,
    0x7c,0xe3,0x39,0x82,0x9b,0x2f,0xff,0x87,0x34,0x8e,0x43,0x44,0xc4,0xde,0xe9,0xcb,
    0x54,0x7b,0x94,0x32,0xa6,0xc2,0x23,0x3d,0xee,0x4c,0x95,0x0b,0x42,0xfa,0xc3,0x4e,
    0x08,0x2e,0xa1,0x66,0x28,0xd9,0x24,0xb2,0x76,0x5b,0xa2,0x49,0x6d,0x8b,0xd1,0x25,
    0x72,0xf8,0xf6,0x64,0x86,0x68,0x98,0x16,0xd4,0xa4,0x5c,0xcc,0x5d,0x65,0xb6,0x92,
    0x6c,0x70,0x48,0x50,0xfd,0xed,0xb9,0xda,0x5e,0x15,0x46,0x57,0xa7,0x8d,0x9d,0x84,
    0x90,0xd8,0xab,0x00,0x8c,0xbc,0xd3,0x0a,0xf7,0xe4,0x58,0x05,0xb8,0xb3,0x45,0x06,
    0xd0,0x2c,0x1e,0x8f,0xca,0x3f,0x0f,0x02,0xc1,0xaf,0xbd,0x03,0x01,0x13,0x8a,0x6b,
    0x3a,0x91,0x11,0x41,0x4f,0x67,0xdc,0xea,0x97,0xf2,0xcf,0xce,0xf0,0xb4,0xe6,0x73,
    0x96,0xac,0x74,0x22,0xe7,0xad,0x35,0x85,0xe2,0xf9,0x37,0xe8,0x1c,0x75,0xdf,0x6e,
    0x47,0xf1,0x1a,0x71,0x1d,0x29,0xc5,0x89,0x6f,0xb7,0x62,0x0e,0xaa,0x18,0xbe,0x1b,
    0xfc,0x56,0x3e,0x4b,0xc6,0xd2,0x79,0x20,0x9a,0xdb,0xc0,0xfe,0x78,0xcd,0x5a,0xf4,
    0x1f,0xdd,0xa8,0x33,0x88,0x07,0xc7,0x31,0xb1,0x12,0x10,0x59,0x27,0x80,0xec,0x5f,
    0x60,0x51,0x7f,0xa9,0x19,0xb5,0x4a,0x0d,0x2d,0xe5,0x7a,0x9f,0x93,0xc9,0x9c,0xef,
    0xa0,0xe0,0x3b,0x4d,0xae,0x2a,0xf5,0xb0,0xc8,0xeb,0xbb,0x3c,0x83,0x53,0x99,0x61,
    0x17,0x2b,0x04,0x7e,0xba,0x77,0xd6,0x26,0xe1,0x69,0x14,0x63,0x55,0x21,0x0c,0x7d
};

static const uint8_t Rcon[11] = {
    0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36
};

/* GF(2^8) xtime: multiply by x = 0x02 modulo the AES polynomial */
static inline uint8_t xtime(uint8_t x)
{
    return (uint8_t)((x << 1) ^ (((x >> 7) & 1) * 0x1b));
}

/* GF(2^8) multiplication for inverse MixColumns coefficients */
static uint8_t gmul(uint8_t a, uint8_t b)
{
    uint8_t p = 0;
    uint8_t hi;
    int i;
    for (i = 0; i < 8; i++) {
        if (b & 1) p ^= a;
        hi = a & 0x80;
        a <<= 1;
        if (hi) a ^= 0x1b;
        b >>= 1;
    }
    return p;
}

/* Key expansion: produces (Nr+1)*16 = 176 bytes of round keys */
static void aes_key_expansion(const uint8_t key[AES_KEY_SIZE],
                              uint8_t round_keys[176])
{
    int i;
    uint8_t temp[4];
    int bytes_generated;
    int rcon_iter;
    uint8_t t;

    for (i = 0; i < 16; i++) round_keys[i] = key[i];

    bytes_generated = 16;
    rcon_iter = 1;

    while (bytes_generated < 176) {
        for (i = 0; i < 4; i++) temp[i] = round_keys[bytes_generated - 4 + i];

        if (bytes_generated % 16 == 0) {
            /* RotWord */
            t = temp[0];
            temp[0] = temp[1];
            temp[1] = temp[2];
            temp[2] = temp[3];
            temp[3] = t;
            /* SubWord */
            for (i = 0; i < 4; i++) temp[i] = sbox[temp[i]];
            /* Rcon */
            temp[0] ^= Rcon[rcon_iter++];
        }

        for (i = 0; i < 4; i++) {
            round_keys[bytes_generated] =
                round_keys[bytes_generated - 16] ^ temp[i];
            bytes_generated++;
        }
    }
}

static inline void add_round_key(uint8_t state[16], const uint8_t *rk)
{
    int i;
    for (i = 0; i < 16; i++) state[i] ^= rk[i];
}

static inline void sub_bytes(uint8_t state[16])
{
    int i;
    for (i = 0; i < 16; i++) state[i] = sbox[state[i]];
}

static inline void inv_sub_bytes(uint8_t state[16])
{
    int i;
    for (i = 0; i < 16; i++) state[i] = inv_sbox[state[i]];
}

/* State is column-major: state[c*4 + r] */
static inline void shift_rows(uint8_t s[16])
{
    uint8_t t;
    /* row 1: shift left by 1 */
    t = s[1]; s[1] = s[5]; s[5] = s[9]; s[9] = s[13]; s[13] = t;
    /* row 2: shift left by 2 */
    t = s[2]; s[2] = s[10]; s[10] = t;
    t = s[6]; s[6] = s[14]; s[14] = t;
    /* row 3: shift left by 3 */
    t = s[3]; s[3] = s[15]; s[15] = s[11]; s[11] = s[7]; s[7] = t;
}

static inline void inv_shift_rows(uint8_t s[16])
{
    uint8_t t;
    /* row 1: shift right by 1 */
    t = s[13]; s[13] = s[9]; s[9] = s[5]; s[5] = s[1]; s[1] = t;
    /* row 2: shift right by 2 */
    t = s[2]; s[2] = s[10]; s[10] = t;
    t = s[6]; s[6] = s[14]; s[14] = t;
    /* row 3: shift right by 3 */
    t = s[3]; s[3] = s[7]; s[7] = s[11]; s[11] = s[15]; s[15] = t;
}

static inline void mix_columns(uint8_t s[16])
{
    int c;
    uint8_t a0, a1, a2, a3, t;
    for (c = 0; c < 4; c++) {
        a0 = s[c*4 + 0];
        a1 = s[c*4 + 1];
        a2 = s[c*4 + 2];
        a3 = s[c*4 + 3];
        t = a0 ^ a1 ^ a2 ^ a3;
        s[c*4 + 0] ^= t ^ xtime(a0 ^ a1);
        s[c*4 + 1] ^= t ^ xtime(a1 ^ a2);
        s[c*4 + 2] ^= t ^ xtime(a2 ^ a3);
        s[c*4 + 3] ^= t ^ xtime(a3 ^ a0);
    }
}

static inline void inv_mix_columns(uint8_t s[16])
{
    int c;
    uint8_t a0, a1, a2, a3;
    for (c = 0; c < 4; c++) {
        a0 = s[c*4 + 0];
        a1 = s[c*4 + 1];
        a2 = s[c*4 + 2];
        a3 = s[c*4 + 3];
        s[c*4 + 0] = gmul(a0,0x0e) ^ gmul(a1,0x0b) ^ gmul(a2,0x0d) ^ gmul(a3,0x09);
        s[c*4 + 1] = gmul(a0,0x09) ^ gmul(a1,0x0e) ^ gmul(a2,0x0b) ^ gmul(a3,0x0d);
        s[c*4 + 2] = gmul(a0,0x0d) ^ gmul(a1,0x09) ^ gmul(a2,0x0e) ^ gmul(a3,0x0b);
        s[c*4 + 3] = gmul(a0,0x0b) ^ gmul(a1,0x0d) ^ gmul(a2,0x09) ^ gmul(a3,0x0e);
    }
}

static void aes128_encrypt_block(const uint8_t in[16],
                                 uint8_t out[16],
                                 const uint8_t round_keys[176])
{
    uint8_t state[16];
    int round;
    memcpy(state, in, 16);

    add_round_key(state, round_keys);

    for (round = 1; round < AES_NR; round++) {
        sub_bytes(state);
        shift_rows(state);
        mix_columns(state);
        add_round_key(state, round_keys + round * 16);
    }

    sub_bytes(state);
    shift_rows(state);
    add_round_key(state, round_keys + AES_NR * 16);

    memcpy(out, state, 16);
}

static void aes128_decrypt_block(const uint8_t in[16],
                                 uint8_t out[16],
                                 const uint8_t round_keys[176])
{
    uint8_t state[16];
    int round;
    memcpy(state, in, 16);

    add_round_key(state, round_keys + AES_NR * 16);

    for (round = AES_NR - 1; round >= 1; round--) {
        inv_shift_rows(state);
        inv_sub_bytes(state);
        add_round_key(state, round_keys + round * 16);
        inv_mix_columns(state);
    }

    inv_shift_rows(state);
    inv_sub_bytes(state);
    add_round_key(state, round_keys);

    memcpy(out, state, 16);
}

/* =====================================================================
   VGA <-> AES helpers: each AES block = 8 pixels (16 bytes)
   ===================================================================== */

// static inline void load_block_from_vga(int block_idx, uint8_t block[16])
// {
//     int base = block_idx * 8;
//     int k;
//     int pix, px, py;
//     uint16_t pixel;
//     for (k = 0; k < 8; k++) {
//         pix = base + k;
//         px = pix % 640;
//         py = pix / 640;
//         pixel = (uint16_t)VGA_READ_PIXEL(px, py);
//         /* little-endian byte ordering inside the block */
//         block[k*2 + 0] = (uint8_t)(pixel & 0xFF);
//         block[k*2 + 1] = (uint8_t)((pixel >> 8) & 0xFF);
//     }
// }

// static inline void store_block_to_vga(int block_idx, const uint8_t block[16])
// {
//     int base = block_idx * 8;
//     int k;
//     int pix, px, py;
//     uint16_t pixel;
//     for (k = 0; k < 8; k++) {
//         pix = base + k;
//         px = pix % 640;
//         py = pix / 640;
//         pixel = (uint16_t)block[k*2 + 0]
//               | ((uint16_t)block[k*2 + 1] << 8);
//         VGA_PIXEL(px, py, pixel);
//     }
// }

static inline void load_block_from_vga(int block_idx, uint8_t block[16])
{
    int base = block_idx * 8;
    int k;
    int pix, px, py;
    uint16_t pixel;
    for (k = 0; k < 8; k++) {
        pix = base + k;
        px = pix % 640;
        py = pix / 640;
        pixel = (uint16_t)VGA_READ_PIXEL(px, py);

        /* Match FPGA path: high byte first, then low byte */
        block[k*2 + 0] = (uint8_t)((pixel >> 8) & 0xFF);
        block[k*2 + 1] = (uint8_t)(pixel & 0xFF);
    }
}

static inline void store_block_to_vga(int block_idx, const uint8_t block[16])
{
    int base = block_idx * 8;
    int k;
    int pix, px, py;
    uint16_t pixel;
    for (k = 0; k < 8; k++) {
        pix = base + k;
        px = pix % 640;
        py = pix / 640;

        /* Match FPGA path: high byte first, then low byte */
        pixel = ((uint16_t)block[k*2 + 0] << 8)
              |  (uint16_t)block[k*2 + 1];

        VGA_PIXEL(px, py, pixel);
    }
}

/* =====================================================================
   Image I/O
   ===================================================================== */

void load_bin_to_vga(const char *filename)
{
    int x, y;
    unsigned short pixel;
    FILE *f = fopen(filename, "rb");
    if (!f) {
        printf("ERROR: could not open %s\n", filename);
        return;
    }
    for (y = 0; y < 480; y++) {
        for (x = 0; x < 640; x++) {
            if (fread(&pixel, sizeof(unsigned short), 1, f) != 1) {
                printf("ERROR: unexpected end of file at (%d,%d)\n", x, y);
                fclose(f);
                return;
            }
            VGA_PIXEL(x, y, pixel);
        }
    }
    fclose(f);
    printf("Loaded '%s'\n", filename);
}

void save_vga_to_bin(const char *filename)
{
    int x, y;
    FILE *f = fopen(filename, "wb");
    if (!f) {
        printf("ERROR: could not open %s for writing\n", filename);
        return;
    }
    for (y = 0; y < 480; y++) {
        for (x = 0; x < 640; x++) {
            unsigned short pixel = (unsigned short)VGA_READ_PIXEL(x, y);
            if (fwrite(&pixel, sizeof(unsigned short), 1, f) != 1) {
                printf("ERROR: write failed at (%d,%d)\n", x, y);
                fclose(f);
                return;
            }
        }
    }
    fclose(f);
    printf("Saved current VGA frame to '%s'\n", filename);
}

void pick_image()
{
    char *bin_files[256];
    int count = 0;
    int i, choice;
    char line[256];
    FILE *fp;

    fp = popen("ls *.bin 2>/dev/null", "r");
    if (!fp) {
        printf("ERROR: could not list .bin files\n");
        return;
    }

    while (fgets(line, sizeof(line), fp) && count < 256) {
        line[strcspn(line, "\n")] = 0;
        bin_files[count] = strdup(line);
        count++;
    }
    pclose(fp);

    if (count == 0) {
        printf("No .bin files found in current directory.\n");
        return;
    }

    printf("Available .bin files:\n");
    for (i = 0; i < count; i++) {
        printf("  %d: %s\n", i, bin_files[i]);
    }

    printf("Enter number to select: ");
    if (scanf("%d", &choice) != 1 || choice < 0 || choice >= count) {
        printf("Invalid selection\n");
    } else {
        VGA_box(0, 0, 639, 479, 0x0000);
        load_bin_to_vga(bin_files[choice]);
    }

    for (i = 0; i < count; i++) free(bin_files[i]);
}

/* =====================================================================
   Key handling
   ===================================================================== */

/* Convert one hex character to its 4-bit value, or -1 on error */
static int hex_nibble(char c)
{
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}/* Parse hex chars into 16 bytes. If user types fewer than 32 hex chars, the
   input is repeated cyclically until 32 chars are filled (e.g. "ab" becomes
   "abababab...ab"). Returns 1 on success, 0 if input is empty or contains
   any non-hex character. */
static int parse_hex_key(const char *s, uint8_t key[16])
{
    int i;
    int len;
    int hi, lo;
    char padded[33];

    /* skip leading whitespace */
    while (*s == ' ' || *s == '\t') s++;

    /* count hex chars (stop at terminator or whitespace) */
    len = 0;
    while (s[len] && s[len] != '\n' && s[len] != '\r'
           && s[len] != ' ' && s[len] != '\t') {
        len++;
    }

    if (len == 0) return 0;     /* nothing typed */
    if (len > 32) len = 32;     /* truncate over-long input */

    /* validate every typed char is hex before we touch the key */
    for (i = 0; i < len; i++) {
        if (hex_nibble(s[i]) < 0) return 0;
    }

    /* fill 32 chars by cycling through the user's input */
    for (i = 0; i < 32; i++) padded[i] = s[i % len];
    padded[32] = '\0';

    for (i = 0; i < 16; i++) {
        hi = hex_nibble(padded[i*2]);
        lo = hex_nibble(padded[i*2 + 1]);
        key[i] = (uint8_t)((hi << 4) | lo);
    }

    if (len < 32) {
        printf("(input was %d hex chars, repeated to fill 32: %s)\n",
               len, padded);
    }
    return 1;
}

static void print_key(const uint8_t key[16])
{
    int i;
    for (i = 0; i < 16; i++) printf("%02x", key[i]);
    printf("\n");
}

/* Prompt user for a 32-char hex key. Empty input keeps current key. */
static void prompt_key(uint8_t key[16])
{
    char buf[128];
    int c;
    uint8_t newkey[16];

    printf("Enter 128-bit key as 32 hex characters\n");
    printf("(or press Enter to keep current key): ");
    fflush(stdout);

    /* consume any leftover newline from prior scanf */
    while ((c = getchar()) != '\n' && c != EOF) {
        /* if it was meaningful, push it back; only consume stray whitespace */
        if (c != ' ') {
            ungetc(c, stdin);
            break;
        }
    }

    if (!fgets(buf, sizeof(buf), stdin)) {
        printf("Input error, keeping current key\n");
        return;
    }

    /* if empty line, keep current */
    if (buf[0] == '\n' || buf[0] == '\0') {
        printf("Keeping current key: ");
        print_key(key);
        return;
    }

    if (!parse_hex_key(buf, newkey)) {
        printf("Invalid key, keeping current: ");
        print_key(key);
        return;
    }
    memcpy(key, newkey, 16);
    printf("Key set to: ");
    print_key(key);
}

/* =====================================================================
   Main
   ===================================================================== */

int main(void)
{
    /* default key (all zeros), user can override */
    uint8_t key[16] = {
        0x00,0x01,0x02,0x03, 0x04,0x05,0x06,0x07,
        0x08,0x09,0x0a,0x0b, 0x0c,0x0d,0x0e,0x0f
    };
    uint8_t round_keys[176];
    int cmd;
    char fname[256];
    int total_pixels;
    int total_blocks;
    int b;
    struct timeval t1, t2;
    double elapsed;
    uint8_t in[16], out[16];

    if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
        printf("ERROR: could not open \"/dev/mem\"...\n");
        return 1;
    }

    h2p_lw_virtual_base = mmap(NULL, HW_REGS_SPAN,
                               (PROT_READ | PROT_WRITE),
                               MAP_SHARED, fd, HW_REGS_BASE);
    if (h2p_lw_virtual_base == MAP_FAILED) {
        printf("ERROR: mmap1() failed...\n");
        close(fd);
        return 1;
    }

    vga_char_virtual_base = mmap(NULL, FPGA_CHAR_SPAN,
                                 (PROT_READ | PROT_WRITE),
                                 MAP_SHARED, fd, FPGA_CHAR_BASE);
    if (vga_char_virtual_base == MAP_FAILED) {
        printf("ERROR: mmap2() failed...\n");
        close(fd);
        return 1;
    }
    vga_char_ptr = (unsigned int *)(vga_char_virtual_base);

    vga_pixel_virtual_base = mmap(NULL, SDRAM_SPAN,
                                  (PROT_READ | PROT_WRITE),
                                  MAP_SHARED, fd, SDRAM_BASE);
    if (vga_pixel_virtual_base == MAP_FAILED) {
        printf("ERROR: mmap3() failed...\n");
        close(fd);
        return 1;
    }
    vga_pixel_ptr = (unsigned int *)(vga_pixel_virtual_base);

    VGA_box(0, 0, 639, 479, 0x0000);
    VGA_text_clear();

    aes_key_expansion(key, round_keys);

    printf("=================================================\n");
    printf(" AES-128 (ECB) software encryptor / decryptor\n");
    printf(" Operating on 640x480 RGB565 .bin frames\n");
    printf(" Default key: ");
    print_key(key);
    printf("=================================================\n");

    pick_image();

    while (1) {
        printf("\nMenu:\n");
        printf("  0 = encrypt current frame\n");
        printf("  1 = decrypt current frame\n");
        printf("  2 = load new image\n");
        printf("  3 = set AES key (32 hex chars)\n");
        printf("  4 = save current frame to file\n");
        printf("  9 = quit\n");
        printf("Choice: ");
        if (scanf("%d", &cmd) != 1) {
            printf("Input error\n");
            return 1;
        }

        if (cmd == 9) break;

        if (cmd == 2) {
            pick_image();
            continue;
        }

        if (cmd == 3) {
            prompt_key(key);
            aes_key_expansion(key, round_keys);
            continue;
        }

        if (cmd == 4) {
            printf("Enter filename to save (e.g. out.bin): ");
            if (scanf("%255s", fname) != 1) {
                printf("Input error\n");
                continue;
            }
            save_vga_to_bin(fname);
            continue;
        }

        if (cmd != 0 && cmd != 1) {
            printf("Invalid command\n");
            continue;
        }

        total_pixels = 640 * 480;
        total_blocks = total_pixels / 8;  /* 38400 blocks */

        gettimeofday(&t1, NULL);

        if (cmd == 0) {
            printf("Encrypting %d blocks...\n", total_blocks);
            for (b = 0; b < total_blocks; b++) {
                load_block_from_vga(b, in);
                aes128_encrypt_block(in, out, round_keys);
                store_block_to_vga(b, out);
            }
            printf("Encryption complete.\n");
        } else {
            printf("Decrypting %d blocks...\n", total_blocks);
            for (b = 0; b < total_blocks; b++) {
                load_block_from_vga(b, in);
                aes128_decrypt_block(in, out, round_keys);
                store_block_to_vga(b, out);
            }
            printf("Decryption complete.\n");
        }

        gettimeofday(&t2, NULL);
        elapsed = (t2.tv_sec - t1.tv_sec) * 1000.0
                + (t2.tv_usec - t1.tv_usec) / 1000.0;
        printf("Elapsed: %.2f ms\n", elapsed);
    }

    munmap(vga_pixel_virtual_base, SDRAM_SPAN);
    munmap(vga_char_virtual_base, FPGA_CHAR_SPAN);
    munmap(h2p_lw_virtual_base, HW_REGS_SPAN);
    close(fd);
    return 0;
}

/* =====================================================================
   VGA primitives (unchanged)
   ===================================================================== */

void VGA_text(int x, int y, char *text_ptr)
{
    volatile char *character_buffer = (char *)vga_char_ptr;
    int offset = (y << 7) + x;

    while (*text_ptr) {
        *(character_buffer + offset) = *text_ptr;
        ++text_ptr;
        ++offset;
    }
}

void VGA_text_clear()
{
    volatile char *character_buffer = (char *)vga_char_ptr;
    int offset, x, y;

    for (x = 0; x < 79; x++) {
        for (y = 0; y < 59; y++) {
            offset = (y << 7) + x;
            *(character_buffer + offset) = ' ';
        }
    }
}

#define SWAP(X,Y) do { int temp = (X); (X) = (Y); (Y) = temp; } while (0)

void VGA_box(int x1, int y1, int x2, int y2, short pixel_color)
{
    int row, col;

    if (x1 > 639) x1 = 639;
    if (y1 > 479) y1 = 479;
    if (x2 > 639) x2 = 639;
    if (y2 > 479) y2 = 479;
    if (x1 < 0) x1 = 0;
    if (y1 < 0) y1 = 0;
    if (x2 < 0) x2 = 0;
    if (y2 < 0) y2 = 0;
    if (x1 > x2) SWAP(x1, x2);
    if (y1 > y2) SWAP(y1, y2);

    for (row = y1; row <= y2; row++) {
        for (col = x1; col <= x2; ++col) {
            VGA_PIXEL(col, row, pixel_color);
        }
    }
}

void VGA_line(int x1, int y1, int x2, int y2, short c)
{
    int e;
    signed int dx, dy, j, temp;
    signed int s1, s2, xchange;
    signed int x, y;

    if (x1 > 639) x1 = 639;
    if (y1 > 479) y1 = 479;
    if (x2 > 639) x2 = 639;
    if (y2 > 479) y2 = 479;
    if (x1 < 0) x1 = 0;
    if (y1 < 0) y1 = 0;
    if (x2 < 0) x2 = 0;
    if (y2 < 0) y2 = 0;

    x = x1;
    y = y1;

    if (x2 < x1) {
        dx = x1 - x2;
        s1 = -1;
    } else if (x2 == x1) {
        dx = 0;
        s1 = 0;
    } else {
        dx = x2 - x1;
        s1 = 1;
    }

    if (y2 < y1) {
        dy = y1 - y2;
        s2 = -1;
    } else if (y2 == y1) {
        dy = 0;
        s2 = 0;
    } else {
        dy = y2 - y1;
        s2 = 1;
    }

    xchange = 0;

    if (dy > dx) {
        temp = dx;
        dx = dy;
        dy = temp;
        xchange = 1;
    }

    e = ((int)dy << 1) - dx;

    for (j = 0; j <= dx; j++) {
        VGA_PIXEL(x, y, c);

        if (e >= 0) {
            if (xchange == 1) x = x + s1;
            else y = y + s2;
            e = e - ((int)dx << 1);
        }

        if (xchange == 1) y = y + s2;
        else x = x + s1;

        e = e + ((int)dy << 1);
    }
}
