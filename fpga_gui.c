///////////////////////////////////////
/// 640x480 version! 16-bit color
/// Hardware-accelerated AES-128 (FPGA does the crypto)
/// compile with
///   gcc aes.c -o aes
///
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

#include <pthread.h>

// video display
#define SDRAM_BASE            0xC0000000
#define SDRAM_END             0xC3FFFFFF
#define SDRAM_SPAN            0x04001000
// characters
#define FPGA_CHAR_BASE        0xC9000000
#define FPGA_CHAR_END         0xC9001FFF
#define FPGA_CHAR_SPAN        0x00002000
/* Cyclone V FPGA devices */
#define HW_REGS_BASE          0xff200000
#define HW_REGS_SPAN          0x00005000

// graphics primitives
void VGA_text (int, int, char *);
void VGA_text_clear();
void VGA_box (int, int, int, int, short);
void VGA_line(int, int, int, int, short);

// 16-bit primary colors
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

int colors[] = {
    red, dark_red, green, dark_green, blue, dark_blue,
    yellow, cyan, magenta, gray, black, white
};

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

struct timeval t1, t2;
double elapsed;

/* AES readback PIOs */
volatile uint32_t *read_127_96_ptr = NULL;
volatile uint32_t *read_95_64_ptr  = NULL;
volatile uint32_t *read_63_32_ptr  = NULL;
volatile uint32_t *read_31_0_ptr   = NULL;

/* AES input PIOs */
volatile uint32_t *write_127_96_ptr = NULL;
volatile uint32_t *write_95_64_ptr  = NULL;
volatile uint32_t *write_63_32_ptr  = NULL;
volatile uint32_t *write_31_0_ptr   = NULL;

/* Existing mode PIO */
volatile uint32_t *mode_ptr = NULL;

/* Handshake/control PIOs */
volatile uint32_t *enc_start_ptr        = NULL;
volatile uint32_t *enc_out_ack_ptr      = NULL;
volatile uint32_t *enc_reset_ptr        = NULL;
volatile uint32_t *enc_input_ready_ptr  = NULL;
volatile uint32_t *enc_output_valid_ptr = NULL;

/* User key input PIOs (Verilog handles key expansion) */
volatile uint32_t *user_key_127_96_ptr = NULL;
volatile uint32_t *user_key_95_64_ptr  = NULL;
volatile uint32_t *user_key_63_32_ptr  = NULL;
volatile uint32_t *user_key_31_0_ptr   = NULL;

volatile uint32_t *key_load_ptr     = NULL;
volatile uint32_t *key_can_load_ptr = NULL;

#define READ_127_96_PIO         0x04000000
#define READ_95_64_PIO          0x04000010
#define READ_63_32_PIO          0x04000020
#define READ_31_0_PIO           0x04000030

#define WRITE_127_96_PIO        0x04000040
#define WRITE_95_64_PIO         0x04000050
#define WRITE_63_32_PIO         0x04000060
#define WRITE_31_0_PIO          0x04000070

#define MODE_PIO                0x04000090

#define ENC_START_PIO           0x040000A0
#define ENC_OUT_ACK_PIO         0x040000B0
#define ENC_RESET_PIO           0x040000C0
#define ENC_INPUT_READY_PIO     0x040000D0
#define ENC_OUTPUT_VALID_PIO    0x040000E0

#define USER_KEY_127_96_PIO     0x04000130
#define USER_KEY_95_64_PIO      0x04000120
#define USER_KEY_63_32_PIO      0x04000110
#define USER_KEY_31_0_PIO       0x04000100

#define KEY_LOAD_PIO        0x04000140
#define KEY_CAN_LOAD_PIO    0x04000150

static inline void pulse_pio(volatile uint32_t *ptr)
{
    *ptr = 1;
    __sync_synchronize();
    *ptr = 0;
}

static inline void load_8_pixels_from_vga(int block_idx, uint16_t p[8])
{
    int base = block_idx * 8;
    int k, pix, px, py;
    for (k = 0; k < 8; k++) {
        pix = base + k;
        px = pix % 640;
        py = pix / 640;
        p[k] = VGA_READ_PIXEL(px, py);
    }
}

static inline void write_8_pixels_to_fpga(const uint16_t p[8])
{
    *write_127_96_ptr = ((uint32_t)p[0] << 16) | p[1];
    *write_95_64_ptr  = ((uint32_t)p[2] << 16) | p[3];
    *write_63_32_ptr  = ((uint32_t)p[4] << 16) | p[5];
    *write_31_0_ptr   = ((uint32_t)p[6] << 16) | p[7];
}

static inline void plot_8_pixels_to_vga(int block_idx,
                                        uint32_t e3,
                                        uint32_t e2,
                                        uint32_t e1,
                                        uint32_t e0)
{
    int base = block_idx * 8;

    VGA_PIXEL((base + 0) % 640, (base + 0) / 640, (e3 >> 16) & 0xFFFF);
    VGA_PIXEL((base + 1) % 640, (base + 1) / 640,  e3        & 0xFFFF);
    VGA_PIXEL((base + 2) % 640, (base + 2) / 640, (e2 >> 16) & 0xFFFF);
    VGA_PIXEL((base + 3) % 640, (base + 3) / 640,  e2        & 0xFFFF);
    VGA_PIXEL((base + 4) % 640, (base + 4) / 640, (e1 >> 16) & 0xFFFF);
    VGA_PIXEL((base + 5) % 640, (base + 5) / 640,  e1        & 0xFFFF);
    VGA_PIXEL((base + 6) % 640, (base + 6) / 640, (e0 >> 16) & 0xFFFF);
    VGA_PIXEL((base + 7) % 640, (base + 7) / 640,  e0        & 0xFFFF);
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
    unsigned short pixel;
    FILE *f = fopen(filename, "wb");
    if (!f) {
        printf("ERROR: could not open %s for writing\n", filename);
        return;
    }
    for (y = 0; y < 480; y++) {
        for (x = 0; x < 640; x++) {
            pixel = (unsigned short)VGA_READ_PIXEL(x, y);
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
   Key handling (sent to FPGA, which does the expansion)
   ===================================================================== */

static int hex_nibble(char c)
{
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

/* Parse hex chars into 16 bytes. Shorter input is repeated cyclically until
   32 chars are filled (e.g. "ab" becomes "abababab...ab"). Returns 1 on
   success, 0 if input is empty or contains any non-hex character. */
static int parse_hex_key(const char *s, uint8_t key[16])
{
    int i;
    int len;
    int hi, lo;
    char padded[33];

    while (*s == ' ' || *s == '\t') s++;

    len = 0;
    while (s[len] && s[len] != '\n' && s[len] != '\r'
           && s[len] != ' ' && s[len] != '\t') {
        len++;
    }

    if (len == 0) return 0;
    if (len > 32) len = 32;

    for (i = 0; i < len; i++) {
        if (hex_nibble(s[i]) < 0) return 0;
    }

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

/* Push 16 key bytes into the four 32-bit user_key PIOs.
   key[0..3] is the most significant word (bits 127..96), and so on. */
static int push_key_to_fpga(const uint8_t key[16])
{
    uint32_t w127_96, w95_64, w63_32, w31_0;

    int spins = 0;
    const int max_spins = 1000000;

    w127_96 = ((uint32_t)key[0]  << 24) | ((uint32_t)key[1]  << 16)
            | ((uint32_t)key[2]  << 8)  |  (uint32_t)key[3];
    w95_64  = ((uint32_t)key[4]  << 24) | ((uint32_t)key[5]  << 16)
            | ((uint32_t)key[6]  << 8)  |  (uint32_t)key[7];
    w63_32  = ((uint32_t)key[8]  << 24) | ((uint32_t)key[9]  << 16)
            | ((uint32_t)key[10] << 8)  |  (uint32_t)key[11];
    w31_0   = ((uint32_t)key[12] << 24) | ((uint32_t)key[13] << 16)
            | ((uint32_t)key[14] << 8)  |  (uint32_t)key[15];

    *user_key_127_96_ptr = w127_96;
    *user_key_95_64_ptr  = w95_64;
    *user_key_63_32_ptr  = w63_32;
    *user_key_31_0_ptr   = w31_0;
    __sync_synchronize();

    while ((*key_can_load_ptr == 0) && (spins < max_spins)) {
        spins++;
    }

    if (*key_can_load_ptr == 0) {
        printf("ERROR: key_can_load never asserted\n");
        return 0;
    }

    pulse_pio(key_load_ptr);
    return 1;
}


/* Prompt user for a 32-char hex key (with cyclic padding for shorter input).
   On success, also pushes the key out to the FPGA PIOs. */
static void prompt_and_set_key(uint8_t default_key[16])
{
    char buf[128];
    int c;
    uint8_t key[16];
    int i;

    printf("Enter 128-bit key as up to 32 hex characters. Don't enter anything to use the default key \n");
    printf("(shorter input will be repeated to fill 32): ");
    fflush(stdout);

    /* consume any leftover newline from prior scanf */
    while ((c = getchar()) != '\n' && c != EOF) {
        if (c != ' ' && c != '\t') {
            ungetc(c, stdin);
            break;
        }
    }

    if (!fgets(buf, sizeof(buf), stdin)) {
        printf("Input error, key not changed\n");
        return;
    }

    if (buf[0] == '\n' || buf[0] == '\0') {
        // printf("Empty input, key not changed\n");
        // return;
        memcpy(key, default_key, 16);
    }

    else if (!parse_hex_key(buf, key)) {
        printf("Invalid key, key not changed\n");
        return;
    }

    //push_key_to_fpga(key);

    if (!push_key_to_fpga(key)) {
    printf("Key not committed to FPGA\n");
    return;
}

    printf("Key pushed to FPGA: ");
    for (i = 0; i < 16; i++) printf("%02x", key[i]);
    printf("\n");
}

/* =====================================================================
   FPGA-driven encrypt and decrypt passes
   ===================================================================== */

static void run_encrypt_pass(void)
{
    int total_pixels;
    int total_blocks;
    int blocks_sent;
    int blocks_recv;
    uint16_t p[8];
    uint32_t e3, e2, e1, e0;

    *enc_start_ptr   = 0;
    *enc_out_ack_ptr = 0;
    *enc_reset_ptr   = 0;

    // printf("Before reset pulse: ready=0x%08x valid=0x%08x\n",
    //        *enc_input_ready_ptr, *enc_output_valid_ptr);
    pulse_pio(enc_reset_ptr);
    usleep(10);
    // printf("After reset pulse:  ready=0x%08x valid=0x%08x\n",
    //        *enc_input_ready_ptr, *enc_output_valid_ptr);

    total_pixels = 640 * 480;
    total_blocks = total_pixels / 8;
    blocks_sent  = 0;
    blocks_recv  = 0;

    while (blocks_recv < total_blocks) {
        while (blocks_sent < total_blocks && (*enc_input_ready_ptr != 0)) {
            load_8_pixels_from_vga(blocks_sent, p);
            write_8_pixels_to_fpga(p);
            pulse_pio(enc_start_ptr);
            blocks_sent++;
        }

        while (*enc_output_valid_ptr != 0) {
            e3 = *read_127_96_ptr;
            e2 = *read_95_64_ptr;
            e1 = *read_63_32_ptr;
            e0 = *read_31_0_ptr;

            plot_8_pixels_to_vga(blocks_recv, e3, e2, e1, e0);
            pulse_pio(enc_out_ack_ptr);
            blocks_recv++;
        }
    }

    printf("Encryption pass complete.\n");
}

static void run_decrypt_pass(void)
{
    int total_pixels;
    int i, k;
    int px, py;
    uint16_t p[8];
    unsigned int e3, e2, e1, e0;
    struct timespec ts;

    total_pixels = 640 * 480;
    ts.tv_sec  = 0;
    ts.tv_nsec = 10;

    for (i = 0; i < total_pixels; i = i + 8) {
        for (k = 0; k < 8; k++) {
            px = (i + k) % 640;
            py = (i + k) / 640;
            p[k] = VGA_READ_PIXEL(px, py);
        }

        *write_127_96_ptr = ((unsigned int)p[0] << 16) | p[1];
        *write_95_64_ptr  = ((unsigned int)p[2] << 16) | p[3];
        *write_63_32_ptr  = ((unsigned int)p[4] << 16) | p[5];
        *write_31_0_ptr   = ((unsigned int)p[6] << 16) | p[7];

        nanosleep(&ts, NULL);

        e3 = *read_127_96_ptr;
        e2 = *read_95_64_ptr;
        e1 = *read_63_32_ptr;
        e0 = *read_31_0_ptr;

        VGA_PIXEL((i)   % 640, (i)   / 640, (e3 >> 16) & 0xFFFF);
        VGA_PIXEL((i+1) % 640, (i+1) / 640,  e3        & 0xFFFF);
        VGA_PIXEL((i+2) % 640, (i+2) / 640, (e2 >> 16) & 0xFFFF);
        VGA_PIXEL((i+3) % 640, (i+3) / 640,  e2        & 0xFFFF);
        VGA_PIXEL((i+4) % 640, (i+4) / 640, (e1 >> 16) & 0xFFFF);
        VGA_PIXEL((i+5) % 640, (i+5) / 640,  e1        & 0xFFFF);
        VGA_PIXEL((i+6) % 640, (i+6) / 640, (e0 >> 16) & 0xFFFF);
        VGA_PIXEL((i+7) % 640, (i+7) / 640,  e0        & 0xFFFF);
    }

    printf("Decryption pass complete.\n");
}

/* =====================================================================
   Main
   ===================================================================== */

int main(void)
{
    struct timeval t1, t2;
    int cmd;
    char fname[256];
    uint8_t default_key[16] = {
        0x00,0x01,0x02,0x03, 0x04,0x05,0x06,0x07,
        0x08,0x09,0x0a,0x0b, 0x0c,0x0d,0x0e,0x0f
    };

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

    read_127_96_ptr = (volatile uint32_t *)((char *)vga_pixel_virtual_base + READ_127_96_PIO);
    read_95_64_ptr  = (volatile uint32_t *)((char *)vga_pixel_virtual_base + READ_95_64_PIO);
    read_63_32_ptr  = (volatile uint32_t *)((char *)vga_pixel_virtual_base + READ_63_32_PIO);
    read_31_0_ptr   = (volatile uint32_t *)((char *)vga_pixel_virtual_base + READ_31_0_PIO);

    write_127_96_ptr = (volatile uint32_t *)((char *)vga_pixel_virtual_base + WRITE_127_96_PIO);
    write_95_64_ptr  = (volatile uint32_t *)((char *)vga_pixel_virtual_base + WRITE_95_64_PIO);
    write_63_32_ptr  = (volatile uint32_t *)((char *)vga_pixel_virtual_base + WRITE_63_32_PIO);
    write_31_0_ptr   = (volatile uint32_t *)((char *)vga_pixel_virtual_base + WRITE_31_0_PIO);

    user_key_127_96_ptr = (volatile uint32_t *)((char *)vga_pixel_virtual_base + USER_KEY_127_96_PIO);
    user_key_95_64_ptr  = (volatile uint32_t *)((char *)vga_pixel_virtual_base + USER_KEY_95_64_PIO);
    user_key_63_32_ptr  = (volatile uint32_t *)((char *)vga_pixel_virtual_base + USER_KEY_63_32_PIO);
    user_key_31_0_ptr   = (volatile uint32_t *)((char *)vga_pixel_virtual_base + USER_KEY_31_0_PIO);

    mode_ptr = (volatile uint32_t *)((char *)vga_pixel_virtual_base + MODE_PIO);

    enc_start_ptr        = (volatile uint32_t *)((char *)vga_pixel_virtual_base + ENC_START_PIO);
    enc_out_ack_ptr      = (volatile uint32_t *)((char *)vga_pixel_virtual_base + ENC_OUT_ACK_PIO);
    enc_reset_ptr        = (volatile uint32_t *)((char *)vga_pixel_virtual_base + ENC_RESET_PIO);
    enc_input_ready_ptr  = (volatile uint32_t *)((char *)vga_pixel_virtual_base + ENC_INPUT_READY_PIO);
    enc_output_valid_ptr = (volatile uint32_t *)((char *)vga_pixel_virtual_base + ENC_OUTPUT_VALID_PIO);

    key_load_ptr     = (volatile uint32_t *)((char *)vga_pixel_virtual_base + KEY_LOAD_PIO);
    key_can_load_ptr = (volatile uint32_t *)((char *)vga_pixel_virtual_base + KEY_CAN_LOAD_PIO);

    VGA_box(0, 0, 639, 479, 0x0000);
    VGA_text_clear();

    /* Load a default key into the FPGA so it's not running with a garbage
       schedule on first encrypt. Matches the FIPS-197 example key. */
    *enc_start_ptr   = 0;
    *enc_out_ack_ptr = 0;
    *enc_reset_ptr   = 0;
    *key_load_ptr    = 0;

    prompt_and_set_key(default_key);


    pick_image();

    while (1) {
        printf("\nMenu:\n");
        printf("  0 = encrypt current frame\n");
        printf("  1 = decrypt current frame\n");
        printf("  2 = load new image\n");
        printf("  3 = set AES key\n");
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
            prompt_and_set_key(default_key);
            // printf("PIO readback test:\n");
            // printf("  user_key_127_96 (wrote 0x2b7e1516) = 0x%08x\n", *user_key_127_96_ptr);
            // printf("  user_key_95_64  (wrote 0x28aed2a6) = 0x%08x\n", *user_key_95_64_ptr);
            // printf("  user_key_63_32  (wrote 0xabf71588) = 0x%08x\n", *user_key_63_32_ptr);
            // printf("  user_key_31_0   (wrote 0x09cf4f3c) = 0x%08x\n", *user_key_31_0_ptr);
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

        if ((cmd != 0) && (cmd != 1)) {
            printf("Invalid command\n");
            continue;
        }

        gettimeofday(&t1, NULL);
        *mode_ptr = cmd;

        if (cmd == 0) {
            run_encrypt_pass();
        } else {
            run_decrypt_pass();
        }

        gettimeofday(&t2, NULL);
        elapsed = (t2.tv_sec - t1.tv_sec) * 1000.0
                + (t2.tv_usec - t1.tv_usec) / 1000.0;
        printf("Elapsed: %.2f ms\n", elapsed);
    }

    return 0;
}

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
