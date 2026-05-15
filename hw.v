//Authors: Nikhil Sampath, Zarif Karim, Arnav Muthiayen

module DE1_SoC_Computer (
	////////////////////////////////////
	// FPGA Pins
	////////////////////////////////////

	// Clock pinss
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,
	CLOCK4_50,

	// ADC
	ADC_CS_N,
	ADC_DIN,
	ADC_DOUT,
	ADC_SCLK,

	// Audio
	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACDAT,
	AUD_DACLRCK,
	AUD_XCK,

	// SDRAM
	DRAM_ADDR,
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_CKE,
	DRAM_CLK,
	DRAM_CS_N,
	DRAM_DQ,
	DRAM_LDQM,
	DRAM_RAS_N,
	DRAM_UDQM,
	DRAM_WE_N,

	// I2C Bus for Configuration of the Audio and Video-In Chips
	FPGA_I2C_SCLK,
	FPGA_I2C_SDAT,

	// 40-Pin Headers
	GPIO_0,
	GPIO_1,
	
	// Seven Segment Displays
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,

	// IR
	IRDA_RXD,
	IRDA_TXD,

	// Pushbuttons
	KEY,

	// LEDs
	LEDR,

	// PS2 Ports
	PS2_CLK,
	PS2_DAT,
	
	PS2_CLK2,
	PS2_DAT2,

	// Slider Switches
	SW,

	// Video-In
	TD_CLK27,
	TD_DATA,
	TD_HS,
	TD_RESET_N,
	TD_VS,

	// VGA
	VGA_B,
	VGA_BLANK_N,
	VGA_CLK,
	VGA_G,
	VGA_HS,
	VGA_R,
	VGA_SYNC_N,
	VGA_VS,

	////////////////////////////////////
	// HPS Pins
	////////////////////////////////////
	
	// DDR3 SDRAM
	HPS_DDR3_ADDR,
	HPS_DDR3_BA,
	HPS_DDR3_CAS_N,
	HPS_DDR3_CKE,
	HPS_DDR3_CK_N,
	HPS_DDR3_CK_P,
	HPS_DDR3_CS_N,
	HPS_DDR3_DM,
	HPS_DDR3_DQ,
	HPS_DDR3_DQS_N,
	HPS_DDR3_DQS_P,
	HPS_DDR3_ODT,
	HPS_DDR3_RAS_N,
	HPS_DDR3_RESET_N,
	HPS_DDR3_RZQ,
	HPS_DDR3_WE_N,

	// Ethernet
	HPS_ENET_GTX_CLK,
	HPS_ENET_INT_N,
	HPS_ENET_MDC,
	HPS_ENET_MDIO,
	HPS_ENET_RX_CLK,
	HPS_ENET_RX_DATA,
	HPS_ENET_RX_DV,
	HPS_ENET_TX_DATA,
	HPS_ENET_TX_EN,

	// Flash
	HPS_FLASH_DATA,
	HPS_FLASH_DCLK,
	HPS_FLASH_NCSO,

	// Accelerometer
	HPS_GSENSOR_INT,
		
	// General Purpose I/O
	HPS_GPIO,
		
	// I2C
	HPS_I2C_CONTROL,
	HPS_I2C1_SCLK,
	HPS_I2C1_SDAT,
	HPS_I2C2_SCLK,
	HPS_I2C2_SDAT,

	// Pushbutton
	HPS_KEY,

	// LED
	HPS_LED,
		
	// SD Card
	HPS_SD_CLK,
	HPS_SD_CMD,
	HPS_SD_DATA,

	// SPI
	HPS_SPIM_CLK,
	HPS_SPIM_MISO,
	HPS_SPIM_MOSI,
	HPS_SPIM_SS,

	// UART
	HPS_UART_RX,
	HPS_UART_TX,

	// USB
	HPS_CONV_USB_N,
	HPS_USB_CLKOUT,
	HPS_USB_DATA,
	HPS_USB_DIR,
	HPS_USB_NXT,
	HPS_USB_STP
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

////////////////////////////////////
// FPGA Pins
////////////////////////////////////

// Clock pins
input						CLOCK_50;
input						CLOCK2_50;
input						CLOCK3_50;
input						CLOCK4_50;

// ADC
inout						ADC_CS_N;
output					ADC_DIN;
input						ADC_DOUT;
output					ADC_SCLK;

// Audio
input						AUD_ADCDAT;
inout						AUD_ADCLRCK;
inout						AUD_BCLK;
output					AUD_DACDAT;
inout						AUD_DACLRCK;
output					AUD_XCK;

// SDRAM
output 		[12: 0]	DRAM_ADDR;
output		[ 1: 0]	DRAM_BA;
output					DRAM_CAS_N;
output					DRAM_CKE;
output					DRAM_CLK;
output					DRAM_CS_N;
inout			[15: 0]	DRAM_DQ;
output					DRAM_LDQM;
output					DRAM_RAS_N;
output					DRAM_UDQM;
output					DRAM_WE_N;

// I2C Bus for Configuration of the Audio and Video-In Chips
output					FPGA_I2C_SCLK;
inout						FPGA_I2C_SDAT;

// 40-pin headers
inout			[35: 0]	GPIO_0;
inout			[35: 0]	GPIO_1;

// Seven Segment Displays
output		[ 6: 0]	HEX0;
output		[ 6: 0]	HEX1;
output		[ 6: 0]	HEX2;
output		[ 6: 0]	HEX3;
output		[ 6: 0]	HEX4;
output		[ 6: 0]	HEX5;

// IR
input						IRDA_RXD;
output					IRDA_TXD;

// Pushbuttons
input			[ 3: 0]	KEY;

// LEDs
output		[ 9: 0]	LEDR;

// PS2 Ports
inout						PS2_CLK;
inout						PS2_DAT;

inout						PS2_CLK2;
inout						PS2_DAT2;

// Slider Switches
input			[ 9: 0]	SW;

// Video-In
input						TD_CLK27;
input			[ 7: 0]	TD_DATA;
input						TD_HS;
output					TD_RESET_N;
input						TD_VS;

// VGA
output		[ 7: 0]	VGA_B;
output					VGA_BLANK_N;
output					VGA_CLK;
output		[ 7: 0]	VGA_G;
output					VGA_HS;
output		[ 7: 0]	VGA_R;
output					VGA_SYNC_N;
output					VGA_VS;



////////////////////////////////////
// HPS Pins
////////////////////////////////////
	
// DDR3 SDRAM
output		[14: 0]	HPS_DDR3_ADDR;
output		[ 2: 0]  HPS_DDR3_BA;
output					HPS_DDR3_CAS_N;
output					HPS_DDR3_CKE;
output					HPS_DDR3_CK_N;
output					HPS_DDR3_CK_P;
output					HPS_DDR3_CS_N;
output		[ 3: 0]	HPS_DDR3_DM;
inout			[31: 0]	HPS_DDR3_DQ;
inout			[ 3: 0]	HPS_DDR3_DQS_N;
inout			[ 3: 0]	HPS_DDR3_DQS_P;
output					HPS_DDR3_ODT;
output					HPS_DDR3_RAS_N;
output					HPS_DDR3_RESET_N;
input						HPS_DDR3_RZQ;
output					HPS_DDR3_WE_N;

// Ethernet
output					HPS_ENET_GTX_CLK;
inout						HPS_ENET_INT_N;
output					HPS_ENET_MDC;
inout						HPS_ENET_MDIO;
input						HPS_ENET_RX_CLK;
input			[ 3: 0]	HPS_ENET_RX_DATA;
input						HPS_ENET_RX_DV;
output		[ 3: 0]	HPS_ENET_TX_DATA;
output					HPS_ENET_TX_EN;

// Flash
inout			[ 3: 0]	HPS_FLASH_DATA;
output					HPS_FLASH_DCLK;
output					HPS_FLASH_NCSO;

// Accelerometer
inout						HPS_GSENSOR_INT;

// General Purpose I/O
inout			[ 1: 0]	HPS_GPIO;

// I2C
inout						HPS_I2C_CONTROL;
inout						HPS_I2C1_SCLK;
inout						HPS_I2C1_SDAT;
inout						HPS_I2C2_SCLK;
inout						HPS_I2C2_SDAT;

// Pushbutton
inout						HPS_KEY;

// LED
inout						HPS_LED;

// SD Card
output					HPS_SD_CLK;
inout						HPS_SD_CMD;
inout			[ 3: 0]	HPS_SD_DATA;

// SPI
output					HPS_SPIM_CLK;
input						HPS_SPIM_MISO;
output					HPS_SPIM_MOSI;
inout						HPS_SPIM_SS;

// UART
input						HPS_UART_RX;
output					HPS_UART_TX;

// USB
inout						HPS_CONV_USB_N;
input						HPS_USB_CLKOUT;
inout			[ 7: 0]	HPS_USB_DATA;
input						HPS_USB_DIR;
input						HPS_USB_NXT;
output					HPS_USB_STP;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire			[15: 0]	hex3_hex0;
//wire			[15: 0]	hex5_hex4;

//assign HEX0 = ~hex3_hex0[ 6: 0]; // hex3_hex0[ 6: 0]; 
//assign HEX1 = ~hex3_hex0[14: 8];
//assign HEX2 = ~hex3_hex0[22:16];
//assign HEX3 = ~hex3_hex0[30:24];
assign HEX4 = 7'b0000000;
assign HEX5 = 7'b1111111;

HexDigit Digit0(HEX0, hex3_hex0[3:0]);
HexDigit Digit1(HEX1, hex3_hex0[7:4]);
HexDigit Digit2(HEX2, hex3_hex0[11:8]);
HexDigit Digit3(HEX3, hex3_hex0[15:12]);

wire [31:0] write_127_96;
wire [31:0] write_95_64;
wire [31:0] write_63_32;
wire [31:0] write_31_0;

wire [31:0] read_127_96;
wire [31:0] read_95_64;
wire [31:0] read_63_32;
wire [31:0] read_31_0;

wire enc_start;
wire enc_out_ack;
wire enc_reset;
wire enc_input_ready;
wire enc_output_valid;
	
wire [127:0] hps_block_in = {write_127_96, write_95_64, write_63_32, write_31_0};


//=======================================================
//  Begin AES-128 Encryption (pipelined, encrypt-only)
//=======================================================

wire [31:0] enc_read_127_96;
wire [31:0] enc_read_95_64;
wire [31:0] enc_read_63_32;
wire [31:0] enc_read_31_0;

wire [31:0] user_key_127_96;
wire [31:0] user_key_95_64;
wire [31:0] user_key_63_32;
wire [31:0] user_key_31_0;

wire key_load;
wire key_can_load;

// Reassemble the user key from its four PIO words
wire [127:0] user_key_pio = {user_key_127_96, user_key_95_64,
                         user_key_63_32,  user_key_31_0};
								 
reg  [127:0] latched_user_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
								 
//assign hex3_hex0 = user_key_127_96[15:0];

reg key_load_d;

always @(posedge CLOCK_50 or posedge enc_reset) begin
    if (enc_reset) begin
        key_load_d <= 1'b0;
    end else begin
        key_load_d <= key_load;
    end
end


wire key_load_pulse = key_load & ~key_load_d;

wire engine_idle = (reserved_count == 0) &&
                   (out_count == 0) &&
                   ~v0 & ~v1 & ~v2 & ~v3 & ~v4 &
                   ~v5 & ~v6 & ~v7 & ~v8 & ~v9 & ~v10;

assign key_can_load = engine_idle;

always @(posedge CLOCK_50) begin
    if (key_load_pulse && key_can_load) begin
        latched_user_key <= user_key_pio;
    end
end

// All 11 round keys are derived from the user key
wire [127:0] enc_r0_key;
wire [127:0] enc_r1_key;
wire [127:0] enc_r2_key;
wire [127:0] enc_r3_key;
wire [127:0] enc_r4_key;
wire [127:0] enc_r5_key;
wire [127:0] enc_r6_key;
wire [127:0] enc_r7_key;
wire [127:0] enc_r8_key;
wire [127:0] enc_r9_key;
wire [127:0] enc_r10_key;

key_expansion ke (
    .user_key     (latched_user_key),
    .round_key_0  (enc_r0_key),
    .round_key_1  (enc_r1_key),
    .round_key_2  (enc_r2_key),
    .round_key_3  (enc_r3_key),
    .round_key_4  (enc_r4_key),
    .round_key_5  (enc_r5_key),
    .round_key_6  (enc_r6_key),
    .round_key_7  (enc_r7_key),
    .round_key_8  (enc_r8_key),
    .round_key_9  (enc_r9_key),
    .round_key_10 (enc_r10_key)
);

/* Edge detection for HPS control pulses */
reg enc_start_d;
reg enc_out_ack_d;

always @(posedge CLOCK_50 or posedge enc_reset) begin
    if (enc_reset) begin
        enc_start_d   <= 1'b0;
        enc_out_ack_d <= 1'b0;
    end else begin
        enc_start_d   <= enc_start;
        enc_out_ack_d <= enc_out_ack;
    end
end

wire enc_start_pulse   = enc_start   & ~enc_start_d;
wire enc_out_ack_pulse = enc_out_ack & ~enc_out_ack_d;

/* Reserve one future FIFO slot for every accepted block.
   Decrement only when HPS acknowledges that it has consumed an output block. */
localparam OUT_FIFO_DEPTH = 16;
reg [4:0] reserved_count;

assign enc_input_ready = (reserved_count < OUT_FIFO_DEPTH);
wire accept_block = enc_start_pulse & enc_input_ready;

/* Pipeline stage wires */
wire [127:0] s0_comb,  s0_data;
wire [127:0] s1_comb,  s1_data;
wire [127:0] s2_comb,  s2_data;
wire [127:0] s3_comb,  s3_data;
wire [127:0] s4_comb,  s4_data;
wire [127:0] s5_comb,  s5_data;
wire [127:0] s6_comb,  s6_data;
wire [127:0] s7_comb,  s7_data;
wire [127:0] s8_comb,  s8_data;
wire [127:0] s9_comb,  s9_data;
wire [127:0] s10_comb, s10_data;

wire v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10;

/* Stage 0: initial AddRoundKey */
addRoundKey enc_r0_ark (
    .data_in(hps_block_in),
    .round_key(enc_r0_key),
    .data_out(s0_comb)
);

pipeline_reg s0_reg (
    .clk(CLOCK_50),
    .reset(enc_reset),
    .valid_in(accept_block),
    .data_in(s0_comb),
    .valid_out(v0),
    .data_out(s0_data)
);

/* Stages 1-9: full rounds */
round r1 (.data_in(s0_data), .data_out(s1_comb), .round_key(enc_r1_key));
pipeline_reg s1_reg (.clk(CLOCK_50), .reset(enc_reset), .valid_in(v0), .data_in(s1_comb), .valid_out(v1), .data_out(s1_data));

round r2 (.data_in(s1_data), .data_out(s2_comb), .round_key(enc_r2_key));
pipeline_reg s2_reg (.clk(CLOCK_50), .reset(enc_reset), .valid_in(v1), .data_in(s2_comb), .valid_out(v2), .data_out(s2_data));

round r3 (.data_in(s2_data), .data_out(s3_comb), .round_key(enc_r3_key));
pipeline_reg s3_reg (.clk(CLOCK_50), .reset(enc_reset), .valid_in(v2), .data_in(s3_comb), .valid_out(v3), .data_out(s3_data));

round r4 (.data_in(s3_data), .data_out(s4_comb), .round_key(enc_r4_key));
pipeline_reg s4_reg (.clk(CLOCK_50), .reset(enc_reset), .valid_in(v3), .data_in(s4_comb), .valid_out(v4), .data_out(s4_data));

round r5 (.data_in(s4_data), .data_out(s5_comb), .round_key(enc_r5_key));
pipeline_reg s5_reg (.clk(CLOCK_50), .reset(enc_reset), .valid_in(v4), .data_in(s5_comb), .valid_out(v5), .data_out(s5_data));

round r6 (.data_in(s5_data), .data_out(s6_comb), .round_key(enc_r6_key));
pipeline_reg s6_reg (.clk(CLOCK_50), .reset(enc_reset), .valid_in(v5), .data_in(s6_comb), .valid_out(v6), .data_out(s6_data));

round r7 (.data_in(s6_data), .data_out(s7_comb), .round_key(enc_r7_key));
pipeline_reg s7_reg (.clk(CLOCK_50), .reset(enc_reset), .valid_in(v6), .data_in(s7_comb), .valid_out(v7), .data_out(s7_data));

round r8 (.data_in(s7_data), .data_out(s8_comb), .round_key(enc_r8_key));
pipeline_reg s8_reg (.clk(CLOCK_50), .reset(enc_reset), .valid_in(v7), .data_in(s8_comb), .valid_out(v8), .data_out(s8_data));

round r9 (.data_in(s8_data), .data_out(s9_comb), .round_key(enc_r9_key));
pipeline_reg s9_reg (.clk(CLOCK_50), .reset(enc_reset), .valid_in(v8), .data_in(s9_comb), .valid_out(v9), .data_out(s9_data));

/* Stage 10: final round */
last_round r10 (
    .data_in(s9_data),
    .data_out(s10_comb),
    .round_key(enc_r10_key)
);

pipeline_reg s10_reg (
    .clk(CLOCK_50),
    .reset(enc_reset),
    .valid_in(v9),
    .data_in(s10_comb),
    .valid_out(v10),
    .data_out(s10_data)
);

/* Output FIFO */
reg [127:0] out_fifo [0:OUT_FIFO_DEPTH-1];
reg [3:0] out_wr_ptr;
reg [3:0] out_rd_ptr;
reg [4:0] out_count;

wire fifo_push = v10;
wire fifo_pop  = enc_out_ack_pulse && (out_count != 0);

always @(posedge CLOCK_50 or posedge enc_reset) begin
    if (enc_reset) begin
        out_wr_ptr      <= 4'd0;
        out_rd_ptr      <= 4'd0;
        out_count       <= 5'd0;
        reserved_count  <= 5'd0;
    end else begin
        /* Track reserved FIFO slots */
        case ({accept_block, fifo_pop})
            2'b10: reserved_count <= reserved_count + 5'd1;
            2'b01: reserved_count <= reserved_count - 5'd1;
            default: reserved_count <= reserved_count;
        endcase

        /* Actual output FIFO push/pop */
        case ({fifo_push, fifo_pop})
            2'b10: begin
                out_fifo[out_wr_ptr] <= s10_data;
                out_wr_ptr <= out_wr_ptr + 4'd1;
                out_count  <= out_count + 5'd1;
            end
            2'b01: begin
                out_rd_ptr <= out_rd_ptr + 4'd1;
                out_count  <= out_count - 5'd1;
            end
            2'b11: begin
                out_fifo[out_wr_ptr] <= s10_data;
                out_wr_ptr <= out_wr_ptr + 4'd1;
                out_rd_ptr <= out_rd_ptr + 4'd1;
                out_count  <= out_count;
            end
            default: begin
                out_wr_ptr <= out_wr_ptr;
                out_rd_ptr <= out_rd_ptr;
                out_count  <= out_count;
            end
        endcase
    end
end

wire [127:0] output_block = out_fifo[out_rd_ptr];

assign enc_output_valid = (out_count != 0);

assign enc_read_127_96 = output_block[127:96];
assign enc_read_95_64  = output_block[95:64];
assign enc_read_63_32  = output_block[63:32];
assign enc_read_31_0   = output_block[31:0];

//=======================================================
//  End AES-128 Encryption
//=======================================================


//=======================================================
//  Begin AES-128 Decryption
//=======================================================
   wire [31:0] dec_read_127_96;
	wire [31:0] dec_read_95_64;
	wire [31:0] dec_read_63_32;
	wire [31:0] dec_read_31_0;
	
    //wire [127:0] cipher_in = 128'h3925841d02dc09fbdc118597196a0b32;

// Decrypt uses the same 11 round keys as encrypt, just consumed in reverse
wire [127:0] dec_r0_key  = enc_r0_key;
wire [127:0] dec_r1_key  = enc_r1_key;
wire [127:0] dec_r2_key  = enc_r2_key;
wire [127:0] dec_r3_key  = enc_r3_key;
wire [127:0] dec_r4_key  = enc_r4_key;
wire [127:0] dec_r5_key  = enc_r5_key;
wire [127:0] dec_r6_key  = enc_r6_key;
wire [127:0] dec_r7_key  = enc_r7_key;
wire [127:0] dec_r8_key  = enc_r8_key;
wire [127:0] dec_r9_key  = enc_r9_key;
wire [127:0] dec_r10_key = enc_r10_key;

    // Initial round
    wire [127:0] dec_r0_ark_out;

    // Rounds 1-9
    wire [127:0] dec_r1_ishift_out, dec_r1_isub_out, dec_r1_ark_out, dec_r1_imix_out;
    wire [127:0] dec_r2_ishift_out, dec_r2_isub_out, dec_r2_ark_out, dec_r2_imix_out;
    wire [127:0] dec_r3_ishift_out, dec_r3_isub_out, dec_r3_ark_out, dec_r3_imix_out;
    wire [127:0] dec_r4_ishift_out, dec_r4_isub_out, dec_r4_ark_out, dec_r4_imix_out;
    wire [127:0] dec_r5_ishift_out, dec_r5_isub_out, dec_r5_ark_out, dec_r5_imix_out;
    wire [127:0] dec_r6_ishift_out, dec_r6_isub_out, dec_r6_ark_out, dec_r6_imix_out;
    wire [127:0] dec_r7_ishift_out, dec_r7_isub_out, dec_r7_ark_out, dec_r7_imix_out;
    wire [127:0] dec_r8_ishift_out, dec_r8_isub_out, dec_r8_ark_out, dec_r8_imix_out;
    wire [127:0] dec_r9_ishift_out, dec_r9_isub_out, dec_r9_ark_out, dec_r9_imix_out;

    // Round 10 (no InvMixColumns)
    wire [127:0] dec_r10_ishift_out, dec_r10_isub_out, dec_r10_ark_out;

    // Initial round: AddRoundKey with round10_key
    addRoundKey dec_r0_ark (.data_in(hps_block_in), .round_key(dec_r10_key), .data_out(dec_r0_ark_out));

    // Round 1 (uses round9_key)
    inv_shift_rows  r1_ishift (.data_in(dec_r0_ark_out),     .data_out(dec_r1_ishift_out));
    inv_sub_bytes   r1_isub   (.in(dec_r1_ishift_out),       .out(dec_r1_isub_out));
    addRoundKey     dec_r1_ark(.data_in(dec_r1_isub_out),    .round_key(dec_r9_key), .data_out(dec_r1_ark_out));
    inv_mix_columns r1_imix   (.in(dec_r1_ark_out),          .out(dec_r1_imix_out));

    // Round 2 (uses round8_key)
    inv_shift_rows  r2_ishift (.data_in(dec_r1_imix_out),    .data_out(dec_r2_ishift_out));
    inv_sub_bytes   r2_isub   (.in(dec_r2_ishift_out),       .out(dec_r2_isub_out));
    addRoundKey     dec_r2_ark(.data_in(dec_r2_isub_out),    .round_key(dec_r8_key), .data_out(dec_r2_ark_out));
    inv_mix_columns r2_imix   (.in(dec_r2_ark_out),          .out(dec_r2_imix_out));

    // Round 3 (uses round7_key)
    inv_shift_rows  r3_ishift (.data_in(dec_r2_imix_out),    .data_out(dec_r3_ishift_out));
    inv_sub_bytes   r3_isub   (.in(dec_r3_ishift_out),       .out(dec_r3_isub_out));
    addRoundKey     dec_r3_ark(.data_in(dec_r3_isub_out),    .round_key(dec_r7_key), .data_out(dec_r3_ark_out));
    inv_mix_columns r3_imix   (.in(dec_r3_ark_out),          .out(dec_r3_imix_out));

    // Round 4 (uses round6_key)
    inv_shift_rows  r4_ishift (.data_in(dec_r3_imix_out),    .data_out(dec_r4_ishift_out));
    inv_sub_bytes   r4_isub   (.in(dec_r4_ishift_out),       .out(dec_r4_isub_out));
    addRoundKey     dec_r4_ark(.data_in(dec_r4_isub_out),        .round_key(dec_r6_key), .data_out(dec_r4_ark_out));
    inv_mix_columns r4_imix   (.in(dec_r4_ark_out),          .out(dec_r4_imix_out));

    // Round 5 (uses round5_key)
    inv_shift_rows  r5_ishift (.data_in(dec_r4_imix_out),    .data_out(dec_r5_ishift_out));
    inv_sub_bytes   r5_isub   (.in(dec_r5_ishift_out),       .out(dec_r5_isub_out));
    addRoundKey     dec_r5_ark(.data_in(dec_r5_isub_out),    .round_key(dec_r5_key), .data_out(dec_r5_ark_out));
    inv_mix_columns r5_imix   (.in(dec_r5_ark_out),          .out(dec_r5_imix_out));

    // Round 6 (uses round4_key)
    inv_shift_rows  r6_ishift (.data_in(dec_r5_imix_out),    .data_out(dec_r6_ishift_out));
    inv_sub_bytes   r6_isub   (.in(dec_r6_ishift_out),       .out(dec_r6_isub_out));
    addRoundKey     dec_r6_ark(.data_in(dec_r6_isub_out),    .round_key(dec_r4_key), .data_out(dec_r6_ark_out));
    inv_mix_columns r6_imix   (.in(dec_r6_ark_out),          .out(dec_r6_imix_out));

    // Round 7 (uses round3_key)
    inv_shift_rows  r7_ishift (.data_in(dec_r6_imix_out),    .data_out(dec_r7_ishift_out));
    inv_sub_bytes   r7_isub   (.in(dec_r7_ishift_out),       .out(dec_r7_isub_out));
    addRoundKey     dec_r7_ark(.data_in(dec_r7_isub_out),    .round_key(dec_r3_key), .data_out(dec_r7_ark_out));
    inv_mix_columns r7_imix   (.in(dec_r7_ark_out),          .out(dec_r7_imix_out));

    // Round 8 (uses round2_key)
    inv_shift_rows  r8_ishift (.data_in(dec_r7_imix_out),    .data_out(dec_r8_ishift_out));
    inv_sub_bytes   r8_isub   (.in(dec_r8_ishift_out),       .out(dec_r8_isub_out));
    addRoundKey     dec_r8_ark(.data_in(dec_r8_isub_out),    .round_key(dec_r2_key), .data_out(dec_r8_ark_out));
    inv_mix_columns r8_imix   (.in(dec_r8_ark_out),          .out(dec_r8_imix_out));

    // Round 9 (uses round1_key)
    inv_shift_rows  r9_ishift (.data_in(dec_r8_imix_out),    .data_out(dec_r9_ishift_out));
    inv_sub_bytes   r9_isub   (.in(dec_r9_ishift_out),       .out(dec_r9_isub_out));
    addRoundKey     dec_r9_ark(.data_in(dec_r9_isub_out),    .round_key(dec_r1_key), .data_out(dec_r9_ark_out));
    inv_mix_columns r9_imix   (.in(dec_r9_ark_out),          .out(dec_r9_imix_out));

    // Round 10: no InvMixColumns (uses round0_key)
    inv_shift_rows  r10_ishift (.data_in(dec_r9_imix_out),    .data_out(dec_r10_ishift_out));
    inv_sub_bytes   r10_isub   (.in(dec_r10_ishift_out),      .out(dec_r10_isub_out));
    addRoundKey     dec_r10_ark(.data_in(dec_r10_isub_out),   .round_key(dec_r0_key), .data_out(dec_r10_ark_out));

	assign dec_read_127_96 = dec_r10_ark_out[127:96];
	assign dec_read_95_64  = dec_r10_ark_out[95:64];
	assign dec_read_63_32  = dec_r10_ark_out[63:32];
    assign dec_read_31_0   = dec_r10_ark_out[31:0];
//=======================================================
//  End AES-128 Decryption
//=======================================================

wire mode;
//assign mode = SW[0];

assign read_127_96 = mode ? dec_read_127_96 : enc_read_127_96;
assign read_95_64  = mode ? dec_read_95_64 : enc_read_95_64;
assign read_63_32  = mode ? dec_read_63_32 : enc_read_63_32;
assign read_31_0   = mode ? dec_read_31_0 : enc_read_31_0;


assign LEDR[0] = enc_input_ready;
assign LEDR[1] = enc_start;
assign LEDR[2] = enc_start_pulse;
assign LEDR[3] = accept_block;
assign LEDR[4] = v0;
assign LEDR[5] = v5;
assign LEDR[6] = v10;
assign LEDR[7] = fifo_push;
assign LEDR[8] = enc_output_valid;
assign LEDR[9] = fifo_pop;
//assign hex3_hex0 = {6'b0, out_count[4:0], reserved_count[4:0]};

wire [127:0] dbg_key = enc_r10_key;
reg  [15:0]  hex_view;

always @(*) begin
    case (SW[2:0])
        3'd0: hex_view = dbg_key[15:0];
        3'd1: hex_view = dbg_key[31:16];
        3'd2: hex_view = dbg_key[47:32];
        3'd3: hex_view = dbg_key[63:48];
        3'd4: hex_view = dbg_key[79:64];
        3'd5: hex_view = dbg_key[95:80];
        3'd6: hex_view = dbg_key[111:96];
        3'd7: hex_view = dbg_key[127:112];
        default: hex_view = 16'h0000;
    endcase
end

assign hex3_hex0 = hex_view;

//=======================================================
//  Structural coding
//=======================================================

Computer_System The_System (
	////////////////////////////////////
	// FPGA Side
	////////////////////////////////////
	
	// AES PIO's
	.read_127_96_pio_external_connection_export(read_127_96),
	.read_95_64_pio_external_connection_export(read_95_64),
	.read_63_32_pio_external_connection_export(read_63_32),
	.read_31_0_pio_external_connection_export(read_31_0),
	
	.write_127_96_pio_external_connection_export(write_127_96),
	.write_95_64_pio_external_connection_export(write_95_64),
	.write_63_32_pio_external_connection_export(write_63_32),
	.write_31_0_pio_external_connection_export(write_31_0),
	
	.mode_external_connection_export(mode),
	
	.enc_input_ready_external_connection_export(enc_input_ready),
	.enc_out_ack_external_connection_export(enc_out_ack),
	.enc_reset_external_connection_export(enc_reset),
	.enc_start_external_connection_export(enc_start),
	.enc_output_valid_external_connection_export(enc_output_valid),
	
	//User Key input
	.user_key_127_96_pio_external_connection_export(user_key_127_96),
	.user_key_95_64_pio_external_connection_export(user_key_95_64),
	.user_key_63_32_pio_external_connection_export(user_key_63_32),
	.user_key_31_0_pio_external_connection_export(user_key_31_0),
	
	.key_can_load_external_connection_export(key_can_load),
	.key_load_external_connection_export(key_load),
	
	
	

	// Global signals
	.system_pll_ref_clk_clk					(CLOCK_50),
	.system_pll_ref_reset_reset			(1'b0),

	// AV Config
	.av_config_SCLK							(FPGA_I2C_SCLK),
	.av_config_SDAT							(FPGA_I2C_SDAT),

	// VGA Subsystem
	.vga_pll_ref_clk_clk 					(CLOCK2_50),
	.vga_pll_ref_reset_reset				(1'b0),
	.vga_CLK										(VGA_CLK),
	.vga_BLANK									(VGA_BLANK_N),
	.vga_SYNC									(VGA_SYNC_N),
	.vga_HS										(VGA_HS),
	.vga_VS										(VGA_VS),
	.vga_R										(VGA_R),
	.vga_G										(VGA_G),
	.vga_B										(VGA_B),
	
	// SDRAM
	.sdram_clk_clk								(DRAM_CLK),
   .sdram_addr									(DRAM_ADDR),
	.sdram_ba									(DRAM_BA),
	.sdram_cas_n								(DRAM_CAS_N),
	.sdram_cke									(DRAM_CKE),
	.sdram_cs_n									(DRAM_CS_N),
	.sdram_dq									(DRAM_DQ),
	.sdram_dqm									({DRAM_UDQM,DRAM_LDQM}),
	.sdram_ras_n								(DRAM_RAS_N),
	.sdram_we_n									(DRAM_WE_N),
	
	////////////////////////////////////
	// HPS Side
	////////////////////////////////////
	// DDR3 SDRAM
	.memory_mem_a			(HPS_DDR3_ADDR),
	.memory_mem_ba			(HPS_DDR3_BA),
	.memory_mem_ck			(HPS_DDR3_CK_P),
	.memory_mem_ck_n		(HPS_DDR3_CK_N),
	.memory_mem_cke		(HPS_DDR3_CKE),
	.memory_mem_cs_n		(HPS_DDR3_CS_N),
	.memory_mem_ras_n		(HPS_DDR3_RAS_N),
	.memory_mem_cas_n		(HPS_DDR3_CAS_N),
	.memory_mem_we_n		(HPS_DDR3_WE_N),
	.memory_mem_reset_n	(HPS_DDR3_RESET_N),
	.memory_mem_dq			(HPS_DDR3_DQ),
	.memory_mem_dqs		(HPS_DDR3_DQS_P),
	.memory_mem_dqs_n		(HPS_DDR3_DQS_N),
	.memory_mem_odt		(HPS_DDR3_ODT),
	.memory_mem_dm			(HPS_DDR3_DM),
	.memory_oct_rzqin		(HPS_DDR3_RZQ),
		  
	// Ethernet
	.hps_io_hps_io_gpio_inst_GPIO35	(HPS_ENET_INT_N),
	.hps_io_hps_io_emac1_inst_TX_CLK	(HPS_ENET_GTX_CLK),
	.hps_io_hps_io_emac1_inst_TXD0	(HPS_ENET_TX_DATA[0]),
	.hps_io_hps_io_emac1_inst_TXD1	(HPS_ENET_TX_DATA[1]),
	.hps_io_hps_io_emac1_inst_TXD2	(HPS_ENET_TX_DATA[2]),
	.hps_io_hps_io_emac1_inst_TXD3	(HPS_ENET_TX_DATA[3]),
	.hps_io_hps_io_emac1_inst_RXD0	(HPS_ENET_RX_DATA[0]),
	.hps_io_hps_io_emac1_inst_MDIO	(HPS_ENET_MDIO),
	.hps_io_hps_io_emac1_inst_MDC		(HPS_ENET_MDC),
	.hps_io_hps_io_emac1_inst_RX_CTL	(HPS_ENET_RX_DV),
	.hps_io_hps_io_emac1_inst_TX_CTL	(HPS_ENET_TX_EN),
	.hps_io_hps_io_emac1_inst_RX_CLK	(HPS_ENET_RX_CLK),
	.hps_io_hps_io_emac1_inst_RXD1	(HPS_ENET_RX_DATA[1]),
	.hps_io_hps_io_emac1_inst_RXD2	(HPS_ENET_RX_DATA[2]),
	.hps_io_hps_io_emac1_inst_RXD3	(HPS_ENET_RX_DATA[3]),

	// Flash
	.hps_io_hps_io_qspi_inst_IO0	(HPS_FLASH_DATA[0]),
	.hps_io_hps_io_qspi_inst_IO1	(HPS_FLASH_DATA[1]),
	.hps_io_hps_io_qspi_inst_IO2	(HPS_FLASH_DATA[2]),
	.hps_io_hps_io_qspi_inst_IO3	(HPS_FLASH_DATA[3]),
	.hps_io_hps_io_qspi_inst_SS0	(HPS_FLASH_NCSO),
	.hps_io_hps_io_qspi_inst_CLK	(HPS_FLASH_DCLK),

	// Accelerometer
	.hps_io_hps_io_gpio_inst_GPIO61	(HPS_GSENSOR_INT),

	//.adc_sclk                        (ADC_SCLK),
	//.adc_cs_n                        (ADC_CS_N),
	//.adc_dout                        (ADC_DOUT),
	//.adc_din                         (ADC_DIN),

	// General Purpose I/O
	.hps_io_hps_io_gpio_inst_GPIO40	(HPS_GPIO[0]),
	.hps_io_hps_io_gpio_inst_GPIO41	(HPS_GPIO[1]),

	// I2C
	.hps_io_hps_io_gpio_inst_GPIO48	(HPS_I2C_CONTROL),
	.hps_io_hps_io_i2c0_inst_SDA		(HPS_I2C1_SDAT),
	.hps_io_hps_io_i2c0_inst_SCL		(HPS_I2C1_SCLK),
	.hps_io_hps_io_i2c1_inst_SDA		(HPS_I2C2_SDAT),
	.hps_io_hps_io_i2c1_inst_SCL		(HPS_I2C2_SCLK),

	// Pushbutton
	.hps_io_hps_io_gpio_inst_GPIO54	(HPS_KEY),

	// LED
	.hps_io_hps_io_gpio_inst_GPIO53	(HPS_LED),

	// SD Card
	.hps_io_hps_io_sdio_inst_CMD	(HPS_SD_CMD),
	.hps_io_hps_io_sdio_inst_D0	(HPS_SD_DATA[0]),
	.hps_io_hps_io_sdio_inst_D1	(HPS_SD_DATA[1]),
	.hps_io_hps_io_sdio_inst_CLK	(HPS_SD_CLK),
	.hps_io_hps_io_sdio_inst_D2	(HPS_SD_DATA[2]),
	.hps_io_hps_io_sdio_inst_D3	(HPS_SD_DATA[3]),

	// SPI
	.hps_io_hps_io_spim1_inst_CLK		(HPS_SPIM_CLK),
	.hps_io_hps_io_spim1_inst_MOSI	(HPS_SPIM_MOSI),
	.hps_io_hps_io_spim1_inst_MISO	(HPS_SPIM_MISO),
	.hps_io_hps_io_spim1_inst_SS0		(HPS_SPIM_SS),

	// UART
	.hps_io_hps_io_uart0_inst_RX	(HPS_UART_RX),
	.hps_io_hps_io_uart0_inst_TX	(HPS_UART_TX),

	// USB
	.hps_io_hps_io_gpio_inst_GPIO09	(HPS_CONV_USB_N),
	.hps_io_hps_io_usb1_inst_D0		(HPS_USB_DATA[0]),
	.hps_io_hps_io_usb1_inst_D1		(HPS_USB_DATA[1]),
	.hps_io_hps_io_usb1_inst_D2		(HPS_USB_DATA[2]),
	.hps_io_hps_io_usb1_inst_D3		(HPS_USB_DATA[3]),
	.hps_io_hps_io_usb1_inst_D4		(HPS_USB_DATA[4]),
	.hps_io_hps_io_usb1_inst_D5		(HPS_USB_DATA[5]),
	.hps_io_hps_io_usb1_inst_D6		(HPS_USB_DATA[6]),
	.hps_io_hps_io_usb1_inst_D7		(HPS_USB_DATA[7]),
	.hps_io_hps_io_usb1_inst_CLK		(HPS_USB_CLKOUT),
	.hps_io_hps_io_usb1_inst_STP		(HPS_USB_STP),
	.hps_io_hps_io_usb1_inst_DIR		(HPS_USB_DIR),
	.hps_io_hps_io_usb1_inst_NXT		(HPS_USB_NXT)
);
endmodule

//=======================================================
//  Pipelining Modules by Rounds
//=======================================================

module pipeline_reg(
	input [127:0] data_in,
	output reg [127:0] data_out,
	input clk,
	input reset,
	input valid_in,
	output reg valid_out
	
);
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			valid_out <= 1'b0;
			data_out <= 128'b0;
		end
		else begin
			valid_out <= valid_in;
			if (valid_in)
				data_out <= data_in;
		end
	end
endmodule


module round (
	input [127:0] data_in,
	output [127:0] data_out,
	input [127:0] round_key
);

	wire [127:0] sub_out;
	wire [127:0] shift_out;
	wire [127:0] mix_out;
	
	sub_bytes sub (.in(data_in), .out(sub_out));
	shift_rows shift (.data_in(sub_out), .data_out(shift_out));
	mix_columns mix (.in(shift_out), .out(mix_out));
	addRoundKey ark (.data_in(mix_out), .round_key(round_key), .data_out(data_out));
endmodule

module last_round (
	input [127:0] data_in,
	output [127:0] data_out,
	input [127:0] round_key
);

	wire [127:0] sub_out;
	wire [127:0] shift_out;

	
	sub_bytes sub (.in(data_in), .out(sub_out));
	shift_rows shift (.data_in(sub_out), .data_out(shift_out));
	addRoundKey ark (.data_in(shift_out), .round_key(round_key), .data_out(data_out));
endmodule


// =============================================================================
// AES-128 Key Expansion
// =============================================================================
module key_expansion (
    input  [127:0] user_key,
    output [127:0] round_key_0,
    output [127:0] round_key_1,
    output [127:0] round_key_2,
    output [127:0] round_key_3,
    output [127:0] round_key_4,
    output [127:0] round_key_5,
    output [127:0] round_key_6,
    output [127:0] round_key_7,
    output [127:0] round_key_8,
    output [127:0] round_key_9,
    output [127:0] round_key_10
);

    assign round_key_0 = user_key;

    next_round_key kr1  (.prev_key(round_key_0),  .rcon_byte(8'h01), .next_key(round_key_1));
    next_round_key kr2  (.prev_key(round_key_1),  .rcon_byte(8'h02), .next_key(round_key_2));
    next_round_key kr3  (.prev_key(round_key_2),  .rcon_byte(8'h04), .next_key(round_key_3));
    next_round_key kr4  (.prev_key(round_key_3),  .rcon_byte(8'h08), .next_key(round_key_4));
    next_round_key kr5  (.prev_key(round_key_4),  .rcon_byte(8'h10), .next_key(round_key_5));
    next_round_key kr6  (.prev_key(round_key_5),  .rcon_byte(8'h20), .next_key(round_key_6));
    next_round_key kr7  (.prev_key(round_key_6),  .rcon_byte(8'h40), .next_key(round_key_7));
    next_round_key kr8  (.prev_key(round_key_7),  .rcon_byte(8'h80), .next_key(round_key_8));
    next_round_key kr9  (.prev_key(round_key_8),  .rcon_byte(8'h1b), .next_key(round_key_9));
    next_round_key kr10 (.prev_key(round_key_9),  .rcon_byte(8'h36), .next_key(round_key_10));

endmodule


module next_round_key (
    input  [127:0] prev_key,
    input  [7:0]   rcon_byte,
    output [127:0] next_key
);

    wire [31:0] W0, W1, W2, W3;
    assign W0 = prev_key[127:96];
    assign W1 = prev_key[95:64];
    assign W2 = prev_key[63:32];
    assign W3 = prev_key[31:0];

    // RotWord on W3
    wire [31:0] rot_W3;
    assign rot_W3 = {W3[23:16], W3[15:8], W3[7:0], W3[31:24]};

    // SubWord on rot_W3
    wire [31:0] sub_rot_W3;
    s_box sw_b3 (.xy(rot_W3[31:24]), .out(sub_rot_W3[31:24]));
    s_box sw_b2 (.xy(rot_W3[23:16]), .out(sub_rot_W3[23:16]));
    s_box sw_b1 (.xy(rot_W3[15:8]),  .out(sub_rot_W3[15:8]));
    s_box sw_b0 (.xy(rot_W3[7:0]),   .out(sub_rot_W3[7:0]));

    // XOR with Rcon (only the high byte is nonzero)
    wire [31:0] g_W3;
    assign g_W3 = sub_rot_W3 ^ {rcon_byte, 24'h000000};

    wire [31:0] W4, W5, W6, W7;
    assign W4 = W0 ^ g_W3;
    assign W5 = W1 ^ W4;
    assign W6 = W2 ^ W5;
    assign W7 = W3 ^ W6;

    assign next_key = {W4, W5, W6, W7};

endmodule

//=======================================================
//  Encryption addRoundKey
//=======================================================

module addRoundKey (
    input [127:0] data_in,
    input [127:0] round_key,
    output [127:0] data_out
);
    assign data_out = data_in ^ round_key;

endmodule

//=======================================================
//  Encryption subBytes
//=======================================================

module sub_bytes (
    input  [127:0] in,
    output [127:0] out
);
    // instead of looping, instantiate 16 S-boxes for each byte of the input

    // Col 0
    s_box sbox00(.xy(in[127:120]), .out(out[127:120]));
    s_box sbox01(.xy(in[119:112]), .out(out[119:112]));
    s_box sbox02(.xy(in[111:104]), .out(out[111:104]));
    s_box sbox03(.xy(in[103:96]), .out(out[103:96]));

    // Col 1
    s_box sbox10(.xy(in[95:88]), .out(out[95:88]));
    s_box sbox11(.xy(in[87:80]), .out(out[87:80]));
    s_box sbox12(.xy(in[79:72]), .out(out[79:72]));
    s_box sbox13(.xy(in[71:64]), .out(out[71:64]));

    // Col 2
    s_box sbox20(.xy(in[63:56]), .out(out[63:56]));
    s_box sbox21(.xy(in[55:48]), .out(out[55:48]));
    s_box sbox22(.xy(in[47:40]), .out(out[47:40]));
    s_box sbox23(.xy(in[39:32]), .out(out[39:32]));

    // Col 3
    s_box sbox30(.xy(in[31:24]), .out(out[31:24]));
    s_box sbox31(.xy(in[23:16]), .out(out[23:16]));
    s_box sbox32(.xy(in[15:8]), .out(out[15:8]));
    s_box sbox33(.xy(in[7:0]), .out(out[7:0]));

endmodule

//=======================================================
//  Encryption S-Box (a lookup table)
//=======================================================

module s_box (
    input [7:0] xy,
    output reg [7:0] out
);	
		
    // S_Box
    always @(*) begin
        case (xy)
            8'h00: out=8'h63;
            8'h01: out=8'h7c;
            8'h02: out=8'h77;
            8'h03: out=8'h7b;
            8'h04: out=8'hf2;
            8'h05: out=8'h6b;
            8'h06: out=8'h6f;
            8'h07: out=8'hc5;
            8'h08: out=8'h30;
            8'h09: out=8'h01;
            8'h0a: out=8'h67;
            8'h0b: out=8'h2b;
            8'h0c: out=8'hfe;
            8'h0d: out=8'hd7;
            8'h0e: out=8'hab;
            8'h0f: out=8'h76;
            8'h10: out=8'hca;
            8'h11: out=8'h82;
            8'h12: out=8'hc9;
            8'h13: out=8'h7d;
            8'h14: out=8'hfa;
            8'h15: out=8'h59;
            8'h16: out=8'h47;
            8'h17: out=8'hf0;
            8'h18: out=8'had;
            8'h19: out=8'hd4;
            8'h1a: out=8'ha2;
            8'h1b: out=8'haf;
            8'h1c: out=8'h9c;
            8'h1d: out=8'ha4;
            8'h1e: out=8'h72;
            8'h1f: out=8'hc0;
            8'h20: out=8'hb7;
            8'h21: out=8'hfd;
            8'h22: out=8'h93;
            8'h23: out=8'h26;
            8'h24: out=8'h36;
            8'h25: out=8'h3f;
            8'h26: out=8'hf7;
            8'h27: out=8'hcc;
            8'h28: out=8'h34;
            8'h29: out=8'ha5;
            8'h2a: out=8'he5;
            8'h2b: out=8'hf1;
            8'h2c: out=8'h71;
            8'h2d: out=8'hd8;
            8'h2e: out=8'h31;
            8'h2f: out=8'h15;
            8'h30: out=8'h04;
            8'h31: out=8'hc7;
            8'h32: out=8'h23;
            8'h33: out=8'hc3;
            8'h34: out=8'h18;
            8'h35: out=8'h96;
            8'h36: out=8'h05;
            8'h37: out=8'h9a;
            8'h38: out=8'h07;
            8'h39: out=8'h12;
            8'h3a: out=8'h80;
            8'h3b: out=8'he2;
            8'h3c: out=8'heb;
            8'h3d: out=8'h27;
            8'h3e: out=8'hb2;
            8'h3f: out=8'h75;
            8'h40: out=8'h09;
            8'h41: out=8'h83;
            8'h42: out=8'h2c;
            8'h43: out=8'h1a;
            8'h44: out=8'h1b;
            8'h45: out=8'h6e;
            8'h46: out=8'h5a;
            8'h47: out=8'ha0;
            8'h48: out=8'h52;
            8'h49: out=8'h3b;
            8'h4a: out=8'hd6;
            8'h4b: out=8'hb3;
            8'h4c: out=8'h29;
            8'h4d: out=8'he3;
            8'h4e: out=8'h2f;
            8'h4f: out=8'h84;
            8'h50: out=8'h53;
            8'h51: out=8'hd1;
            8'h52: out=8'h00;
            8'h53: out=8'hed;
            8'h54: out=8'h20;
            8'h55: out=8'hfc;
            8'h56: out=8'hb1;
            8'h57: out=8'h5b;
            8'h58: out=8'h6a;
            8'h59: out=8'hcb;
            8'h5a: out=8'hbe;
            8'h5b: out=8'h39;
            8'h5c: out=8'h4a;
            8'h5d: out=8'h4c;
            8'h5e: out=8'h58;
            8'h5f: out=8'hcf;
            8'h60: out=8'hd0;
            8'h61: out=8'hef;
            8'h62: out=8'haa;
            8'h63: out=8'hfb;
            8'h64: out=8'h43;
            8'h65: out=8'h4d;
            8'h66: out=8'h33;
            8'h67: out=8'h85;
            8'h68: out=8'h45;
            8'h69: out=8'hf9;
            8'h6a: out=8'h02;
            8'h6b: out=8'h7f;
            8'h6c: out=8'h50;
            8'h6d: out=8'h3c;
            8'h6e: out=8'h9f;
            8'h6f: out=8'ha8;
            8'h70: out=8'h51;
            8'h71: out=8'ha3;
            8'h72: out=8'h40;
            8'h73: out=8'h8f;
            8'h74: out=8'h92;
            8'h75: out=8'h9d;
            8'h76: out=8'h38;
            8'h77: out=8'hf5;
            8'h78: out=8'hbc;
            8'h79: out=8'hb6;
            8'h7a: out=8'hda;
            8'h7b: out=8'h21;
            8'h7c: out=8'h10;
            8'h7d: out=8'hff;
            8'h7e: out=8'hf3;
            8'h7f: out=8'hd2;
            8'h80: out=8'hcd;
            8'h81: out=8'h0c;
            8'h82: out=8'h13;
            8'h83: out=8'hec;
            8'h84: out=8'h5f;
            8'h85: out=8'h97;
            8'h86: out=8'h44;
            8'h87: out=8'h17;
            8'h88: out=8'hc4;
            8'h89: out=8'ha7;
            8'h8a: out=8'h7e;
            8'h8b: out=8'h3d;
            8'h8c: out=8'h64;
            8'h8d: out=8'h5d;
            8'h8e: out=8'h19;
            8'h8f: out=8'h73;
            8'h90: out=8'h60;
            8'h91: out=8'h81;
            8'h92: out=8'h4f;
            8'h93: out=8'hdc;
            8'h94: out=8'h22;
            8'h95: out=8'h2a;
            8'h96: out=8'h90;
            8'h97: out=8'h88;
            8'h98: out=8'h46;
            8'h99: out=8'hee;
            8'h9a: out=8'hb8;
            8'h9b: out=8'h14;
            8'h9c: out=8'hde;
            8'h9d: out=8'h5e;
            8'h9e: out=8'h0b;
            8'h9f: out=8'hdb;
            8'ha0: out=8'he0;
            8'ha1: out=8'h32;
            8'ha2: out=8'h3a;
            8'ha3: out=8'h0a;
            8'ha4: out=8'h49;
            8'ha5: out=8'h06;
            8'ha6: out=8'h24;
            8'ha7: out=8'h5c;
            8'ha8: out=8'hc2;
            8'ha9: out=8'hd3;
            8'haa: out=8'hac;
            8'hab: out=8'h62;
            8'hac: out=8'h91;
            8'had: out=8'h95;
            8'hae: out=8'he4;
            8'haf: out=8'h79;
            8'hb0: out=8'he7;
            8'hb1: out=8'hc8;
            8'hb2: out=8'h37;
            8'hb3: out=8'h6d;
            8'hb4: out=8'h8d;
            8'hb5: out=8'hd5;
            8'hb6: out=8'h4e;
            8'hb7: out=8'ha9;
            8'hb8: out=8'h6c;
            8'hb9: out=8'h56;
            8'hba: out=8'hf4;
            8'hbb: out=8'hea;
            8'hbc: out=8'h65;
            8'hbd: out=8'h7a;
            8'hbe: out=8'hae;
            8'hbf: out=8'h08;
            8'hc0: out=8'hba;
            8'hc1: out=8'h78;
            8'hc2: out=8'h25;
            8'hc3: out=8'h2e;
            8'hc4: out=8'h1c;
            8'hc5: out=8'ha6;
            8'hc6: out=8'hb4;
            8'hc7: out=8'hc6;
            8'hc8: out=8'he8;
            8'hc9: out=8'hdd;
            8'hca: out=8'h74;
            8'hcb: out=8'h1f;
            8'hcc: out=8'h4b;
            8'hcd: out=8'hbd;
            8'hce: out=8'h8b;
            8'hcf: out=8'h8a;
            8'hd0: out=8'h70;
            8'hd1: out=8'h3e;
            8'hd2: out=8'hb5;
            8'hd3: out=8'h66;
            8'hd4: out=8'h48;
            8'hd5: out=8'h03;
            8'hd6: out=8'hf6;
            8'hd7: out=8'h0e;
            8'hd8: out=8'h61;
            8'hd9: out=8'h35;
            8'hda: out=8'h57;
            8'hdb: out=8'hb9;
            8'hdc: out=8'h86;
            8'hdd: out=8'hc1;
            8'hde: out=8'h1d;
            8'hdf: out=8'h9e;
            8'he0: out=8'he1;
            8'he1: out=8'hf8;
            8'he2: out=8'h98;
            8'he3: out=8'h11;
            8'he4: out=8'h69;
            8'he5: out=8'hd9;
            8'he6: out=8'h8e;
            8'he7: out=8'h94;
            8'he8: out=8'h9b;
            8'he9: out=8'h1e;
            8'hea: out=8'h87;
            8'heb: out=8'he9;
            8'hec: out=8'hce;
            8'hed: out=8'h55;
            8'hee: out=8'h28;
            8'hef: out=8'hdf;
            8'hf0: out=8'h8c;
            8'hf1: out=8'ha1;
            8'hf2: out=8'h89;
            8'hf3: out=8'h0d;
            8'hf4: out=8'hbf;
            8'hf5: out=8'he6;
            8'hf6: out=8'h42;
            8'hf7: out=8'h68;
            8'hf8: out=8'h41;
            8'hf9: out=8'h99;
            8'hfa: out=8'h2d;
            8'hfb: out=8'h0f;
            8'hfc: out=8'hb0;
            8'hfd: out=8'h54;
            8'hfe: out=8'hbb;
            8'hff:   out=8'h16;
            default: out = 8'h00;
        endcase
    end

endmodule

//=======================================================
//  Encryption shift Rows
//=======================================================

module shift_rows (
    input [127:0] data_in,
    output [127:0] data_out
);
    wire [7:0] B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11, B12, B13, B14, B15;

    assign B0  = data_in[127:120];
    assign B1  = data_in[119:112];
    assign B2  = data_in[111:104];
    assign B3  = data_in[103:96];
    assign B4  = data_in[95:88];
    assign B5  = data_in[87:80];
    assign B6  = data_in[79:72];
    assign B7  = data_in[71:64];
    assign B8  = data_in[63:56];
    assign B9  = data_in[55:48];
    assign B10 = data_in[47:40];
    assign B11 = data_in[39:32];
    assign B12 = data_in[31:24];
    assign B13 = data_in[23:16];
    assign B14 = data_in[15:8];
    assign B15 = data_in[7:0];

    // Row 0: no shift     -> B0,  B4,  B8,  B12
    // Row 1: shift left 1 -> B5,  B9,  B13, B1
    // Row 2: shift left 2 -> B10, B14, B2,  B6
    // Row 3: shift left 3 -> B15, B3,  B7,  B11

    // Column 0
    assign data_out[127:120] = B0;
    assign data_out[119:112] = B5;
    assign data_out[111:104] = B10;
    assign data_out[103:96]  = B15;

    // Column 1
    assign data_out[95:88]   = B4;
    assign data_out[87:80]   = B9;
    assign data_out[79:72]   = B14;
    assign data_out[71:64]   = B3;

    // Column 2
    assign data_out[63:56]   = B8;
    assign data_out[55:48]   = B13;
    assign data_out[47:40]   = B2;
    assign data_out[39:32]   = B7;

    // Column 3
    assign data_out[31:24]   = B12;
    assign data_out[23:16]   = B1;
    assign data_out[15:8]    = B6;
    assign data_out[7:0]     = B11;

endmodule

//=======================================================
//  Encryption mixColumns
//=======================================================

module mix_columns (
    input [127:0] in,
    output [127:0] out
);

    wire [7:0] B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11, B12, B13, B14, B15;
    assign B0  = in[127:120];
    assign B1  = in[119:112];
    assign B2  = in[111:104];
    assign B3  = in[103:96];
    assign B4  = in[95:88];
    assign B5  = in[87:80];
    assign B6  = in[79:72];
    assign B7  = in[71:64];
    assign B8  = in[63:56];
    assign B9  = in[55:48];
    assign B10 = in[47:40];
    assign B11 = in[39:32];
    assign B12 = in[31:24];
    assign B13 = in[23:16];
    assign B14 = in[15:8];
    assign B15 = in[7:0];

    // Column 0
    wire [7:0] b0t2, b1t3, b1t2, b2t3, b2t2, b3t3, b3t2, b0t3;

    gf_mult2 m_b0t2(.a(B0), .out(b0t2));
    gf_mult3 m_b1t3(.a(B1), .out(b1t3));
    gf_mult2 m_b1t2(.a(B1), .out(b1t2));
    gf_mult3 m_b2t3(.a(B2), .out(b2t3));
    gf_mult2 m_b2t2(.a(B2), .out(b2t2));
    gf_mult3 m_b3t3(.a(B3), .out(b3t3));
    gf_mult2 m_b3t2(.a(B3), .out(b3t2));
    gf_mult3 m_b0t3(.a(B0), .out(b0t3));

    assign out[127:120] = b0t2 ^ b1t3 ^ B2 ^ B3;
    assign out[119:112] = B0 ^ b1t2 ^ b2t3 ^ B3;
    assign out[111:104] = B0 ^ B1 ^ b2t2 ^ b3t3;
    assign out[103:96]  = b0t3 ^ B1 ^ B2 ^ b3t2;

    // Column 1
    wire [7:0] b4t2, b5t3, b5t2, b6t3, b6t2, b7t3, b7t2, b4t3;

    gf_mult2 m_b4t2(.a(B4), .out(b4t2));
    gf_mult3 m_b5t3(.a(B5), .out(b5t3));
    gf_mult2 m_b5t2(.a(B5), .out(b5t2));
    gf_mult3 m_b6t3(.a(B6), .out(b6t3));
    gf_mult2 m_b6t2(.a(B6), .out(b6t2));
    gf_mult3 m_b7t3(.a(B7), .out(b7t3));
    gf_mult2 m_b7t2(.a(B7), .out(b7t2));
    gf_mult3 m_b4t3(.a(B4), .out(b4t3));

    assign out[95:88]   = b4t2 ^ b5t3 ^ B6 ^ B7;
    assign out[87:80]   = B4 ^ b5t2 ^ b6t3 ^ B7;
    assign out[79:72]   = B4 ^ B5 ^ b6t2 ^ b7t3;
    assign out[71:64]   = b4t3 ^ B5 ^ B6 ^ b7t2;

    // Column 2
    wire [7:0] b8t2, b9t3, b9t2, b10t3, b10t2, b11t3, b11t2, b8t3;

    gf_mult2 m_b8t2(.a(B8), .out(b8t2));
    gf_mult3 m_b9t3(.a(B9), .out(b9t3));
    gf_mult2 m_b9t2(.a(B9), .out(b9t2));
    gf_mult3 m_b10t3(.a(B10), .out(b10t3));
    gf_mult2 m_b10t2(.a(B10), .out(b10t2));
    gf_mult3 m_b11t3(.a(B11), .out(b11t3));
    gf_mult2 m_b11t2(.a(B11), .out(b11t2));
    gf_mult3 m_b8t3(.a(B8), .out(b8t3));

    assign out[63:56]   = b8t2 ^ b9t3 ^ B10 ^ B11;
    assign out[55:48]   = B8 ^ b9t2 ^ b10t3 ^ B11;
    assign out[47:40]   = B8 ^ B9 ^ b10t2 ^ b11t3;
    assign out[39:32]   = b8t3 ^ B9 ^ B10 ^ b11t2;

    // Column 3
    wire [7:0] b12t2, b13t3, b13t2, b14t3, b14t2, b15t3, b15t2, b12t3;

    gf_mult2 m_b12t2(.a(B12), .out(b12t2));
    gf_mult3 m_b13t3(.a(B13), .out(b13t3));
    gf_mult2 m_b13t2(.a(B13), .out(b13t2));
    gf_mult3 m_b14t3(.a(B14), .out(b14t3));
    gf_mult2 m_b14t2(.a(B14), .out(b14t2));
    gf_mult3 m_b15t3(.a(B15), .out(b15t3));
    gf_mult2 m_b15t2(.a(B15), .out(b15t2));
    gf_mult3 m_b12t3(.a(B12), .out(b12t3));

    assign out[31:24]   = b12t2 ^ b13t3 ^ B14 ^ B15;
    assign out[23:16]   = B12 ^ b13t2 ^ b14t3 ^ B15;
    assign out[15:8]    = B12 ^ B13 ^ b14t2 ^ b15t3;
    assign out[7:0]     = b12t3 ^ B13 ^ B14 ^ b15t2;

endmodule

//=======================================================
//  Decryption sub Bytes
//=======================================================

module inv_sub_bytes (
    input [127:0] in,
    output [127:0] out
);

    // Col 0
    inv_s_box sbox00(.xy(in[127:120]), .out(out[127:120]));
    inv_s_box sbox01(.xy(in[119:112]), .out(out[119:112]));
    inv_s_box sbox02(.xy(in[111:104]), .out(out[111:104]));
    inv_s_box sbox03(.xy(in[103:96]), .out(out[103:96]));

    // Col 1
    inv_s_box sbox10(.xy(in[95:88]), .out(out[95:88]));
    inv_s_box sbox11(.xy(in[87:80]), .out(out[87:80]));
    inv_s_box sbox12(.xy(in[79:72]), .out(out[79:72]));
    inv_s_box sbox13(.xy(in[71:64]), .out(out[71:64]));

    // Col 2
    inv_s_box sbox20(.xy(in[63:56]), .out(out[63:56]));
    inv_s_box sbox21(.xy(in[55:48]), .out(out[55:48]));
    inv_s_box sbox22(.xy(in[47:40]), .out(out[47:40]));
    inv_s_box sbox23(.xy(in[39:32]), .out(out[39:32]));

    // Col 3
    inv_s_box sbox30(.xy(in[31:24]), .out(out[31:24]));
    inv_s_box sbox31(.xy(in[23:16]), .out(out[23:16]));
    inv_s_box sbox32(.xy(in[15:8]), .out(out[15:8]));
    inv_s_box sbox33(.xy(in[7:0]), .out(out[7:0]));

endmodule

//=======================================================
//  Decryption S BOX (the opposite of encryption lookup table)
//=======================================================

module inv_s_box (
    input  [7:0] xy,
    output reg [7:0] out
);

    always @(*) begin
        case (xy)
            8'h00: out = 8'h52;
            8'h01: out = 8'h09;
            8'h02: out = 8'h6a;
            8'h03: out = 8'hd5;
            8'h04: out = 8'h30;
            8'h05: out = 8'h36;
            8'h06: out = 8'ha5;
            8'h07: out = 8'h38;
            8'h08: out = 8'hbf;
            8'h09: out = 8'h40;
            8'h0a: out = 8'ha3;
            8'h0b: out = 8'h9e;
            8'h0c: out = 8'h81;
            8'h0d: out = 8'hf3;
            8'h0e: out = 8'hd7;
            8'h0f: out = 8'hfb;
            8'h10: out = 8'h7c;
            8'h11: out = 8'he3;
            8'h12: out = 8'h39;
            8'h13: out = 8'h82;
            8'h14: out = 8'h9b;
            8'h15: out = 8'h2f;
            8'h16: out = 8'hff;
            8'h17: out = 8'h87;
            8'h18: out = 8'h34;
            8'h19: out = 8'h8e;
            8'h1a: out = 8'h43;
            8'h1b: out = 8'h44;
            8'h1c: out = 8'hc4;
            8'h1d: out = 8'hde;
            8'h1e: out = 8'he9;
            8'h1f: out = 8'hcb;
            8'h20: out = 8'h54;
            8'h21: out = 8'h7b;
            8'h22: out = 8'h94;
            8'h23: out = 8'h32;
            8'h24: out = 8'ha6;
            8'h25: out = 8'hc2;
            8'h26: out = 8'h23;
            8'h27: out = 8'h3d;
            8'h28: out = 8'hee;
            8'h29: out = 8'h4c;
            8'h2a: out = 8'h95;
            8'h2b: out = 8'h0b;
            8'h2c: out = 8'h42;
            8'h2d: out = 8'hfa;
            8'h2e: out = 8'hc3;
            8'h2f: out = 8'h4e;
            8'h30: out = 8'h08;
            8'h31: out = 8'h2e;
            8'h32: out = 8'ha1;
            8'h33: out = 8'h66;
            8'h34: out = 8'h28;
            8'h35: out = 8'hd9;
            8'h36: out = 8'h24;
            8'h37: out = 8'hb2;
            8'h38: out = 8'h76;
            8'h39: out = 8'h5b;
            8'h3a: out = 8'ha2;
            8'h3b: out = 8'h49;
            8'h3c: out = 8'h6d;
            8'h3d: out = 8'h8b;
            8'h3e: out = 8'hd1;
            8'h3f: out = 8'h25;
            8'h40: out = 8'h72;
            8'h41: out = 8'hf8;
            8'h42: out = 8'hf6;
            8'h43: out = 8'h64;
            8'h44: out = 8'h86;
            8'h45: out = 8'h68;
            8'h46: out = 8'h98;
            8'h47: out = 8'h16;
            8'h48: out = 8'hd4;
            8'h49: out = 8'ha4;
            8'h4a: out = 8'h5c;
            8'h4b: out = 8'hcc;
            8'h4c: out = 8'h5d;
            8'h4d: out = 8'h65;
            8'h4e: out = 8'hb6;
            8'h4f: out = 8'h92;
            8'h50: out = 8'h6c;
            8'h51: out = 8'h70;
            8'h52: out = 8'h48;
            8'h53: out = 8'h50;
            8'h54: out = 8'hfd;
            8'h55: out = 8'hed;
            8'h56: out = 8'hb9;
            8'h57: out = 8'hda;
            8'h58: out = 8'h5e;
            8'h59: out = 8'h15;
            8'h5a: out = 8'h46;
            8'h5b: out = 8'h57;
            8'h5c: out = 8'ha7;
            8'h5d: out = 8'h8d;
            8'h5e: out = 8'h9d;
            8'h5f: out = 8'h84;
            8'h60: out = 8'h90;
            8'h61: out = 8'hd8;
            8'h62: out = 8'hab;
            8'h63: out = 8'h00;
            8'h64: out = 8'h8c;
            8'h65: out = 8'hbc;
            8'h66: out = 8'hd3;
            8'h67: out = 8'h0a;
            8'h68: out = 8'hf7;
            8'h69: out = 8'he4;
            8'h6a: out = 8'h58;
            8'h6b: out = 8'h05;
            8'h6c: out = 8'hb8;
            8'h6d: out = 8'hb3;
            8'h6e: out = 8'h45;
            8'h6f: out = 8'h06;
            8'h70: out = 8'hd0;
            8'h71: out = 8'h2c;
            8'h72: out = 8'h1e;
            8'h73: out = 8'h8f;
            8'h74: out = 8'hca;
            8'h75: out = 8'h3f;
            8'h76: out = 8'h0f;
            8'h77: out = 8'h02;
            8'h78: out = 8'hc1;
            8'h79: out = 8'haf;
            8'h7a: out = 8'hbd;
            8'h7b: out = 8'h03;
            8'h7c: out = 8'h01;
            8'h7d: out = 8'h13;
            8'h7e: out = 8'h8a;
            8'h7f: out = 8'h6b;
            8'h80: out = 8'h3a;
            8'h81: out = 8'h91;
            8'h82: out = 8'h11;
            8'h83: out = 8'h41;
            8'h84: out = 8'h4f;
            8'h85: out = 8'h67;
            8'h86: out = 8'hdc;
            8'h87: out = 8'hea;
            8'h88: out = 8'h97;
            8'h89: out = 8'hf2;
            8'h8a: out = 8'hcf;
            8'h8b: out = 8'hce;
            8'h8c: out = 8'hf0;
            8'h8d: out = 8'hb4;
            8'h8e: out = 8'he6;
            8'h8f: out = 8'h73;
            8'h90: out = 8'h96;
            8'h91: out = 8'hac;
            8'h92: out = 8'h74;
            8'h93: out = 8'h22;
            8'h94: out = 8'he7;
            8'h95: out = 8'had;
            8'h96: out = 8'h35;
            8'h97: out = 8'h85;
            8'h98: out = 8'he2;
            8'h99: out = 8'hf9;
            8'h9a: out = 8'h37;
            8'h9b: out = 8'he8;
            8'h9c: out = 8'h1c;
            8'h9d: out = 8'h75;
            8'h9e: out = 8'hdf;
            8'h9f: out = 8'h6e;
            8'ha0: out = 8'h47;
            8'ha1: out = 8'hf1;
            8'ha2: out = 8'h1a;
            8'ha3: out = 8'h71;
            8'ha4: out = 8'h1d;
            8'ha5: out = 8'h29;
            8'ha6: out = 8'hc5;
            8'ha7: out = 8'h89;
            8'ha8: out = 8'h6f;
            8'ha9: out = 8'hb7;
            8'haa: out = 8'h62;
            8'hab: out = 8'h0e;
            8'hac: out = 8'haa;
            8'had: out = 8'h18;
            8'hae: out = 8'hbe;
            8'haf: out = 8'h1b;
            8'hb0: out = 8'hfc;
            8'hb1: out = 8'h56;
            8'hb2: out = 8'h3e;
            8'hb3: out = 8'h4b;
            8'hb4: out = 8'hc6;
            8'hb5: out = 8'hd2;
            8'hb6: out = 8'h79;
            8'hb7: out = 8'h20;
            8'hb8: out = 8'h9a;
            8'hb9: out = 8'hdb;
            8'hba: out = 8'hc0;
            8'hbb: out = 8'hfe;
            8'hbc: out = 8'h78;
            8'hbd: out = 8'hcd;
            8'hbe: out = 8'h5a;
            8'hbf: out = 8'hf4;
            8'hc0: out = 8'h1f;
            8'hc1: out = 8'hdd;
            8'hc2: out = 8'ha8;
            8'hc3: out = 8'h33;
            8'hc4: out = 8'h88;
            8'hc5: out = 8'h07;
            8'hc6: out = 8'hc7;
            8'hc7: out = 8'h31;
            8'hc8: out = 8'hb1;
            8'hc9: out = 8'h12;
            8'hca: out = 8'h10;
            8'hcb: out = 8'h59;
            8'hcc: out = 8'h27;
            8'hcd: out = 8'h80;
            8'hce: out = 8'hec;
            8'hcf: out = 8'h5f;
            8'hd0: out = 8'h60;
            8'hd1: out = 8'h51;
            8'hd2: out = 8'h7f;
            8'hd3: out = 8'ha9;
            8'hd4: out = 8'h19;
            8'hd5: out = 8'hb5;
            8'hd6: out = 8'h4a;
            8'hd7: out = 8'h0d;
            8'hd8: out = 8'h2d;
            8'hd9: out = 8'he5;
            8'hda: out = 8'h7a;
            8'hdb: out = 8'h9f;
            8'hdc: out = 8'h93;
            8'hdd: out = 8'hc9;
            8'hde: out = 8'h9c;
            8'hdf: out = 8'hef;
            8'he0: out = 8'ha0;
            8'he1: out = 8'he0;
            8'he2: out = 8'h3b;
            8'he3: out = 8'h4d;
            8'he4: out = 8'hae;
            8'he5: out = 8'h2a;
            8'he6: out = 8'hf5;
            8'he7: out = 8'hb0;
            8'he8: out = 8'hc8;
            8'he9: out = 8'heb;
            8'hea: out = 8'hbb;
            8'heb: out = 8'h3c;
            8'hec: out = 8'h83;
            8'hed: out = 8'h53;
            8'hee: out = 8'h99;
            8'hef: out = 8'h61;
            8'hf0: out = 8'h17;
            8'hf1: out = 8'h2b;
            8'hf2: out = 8'h04;
            8'hf3: out = 8'h7e;
            8'hf4: out = 8'hba;
            8'hf5: out = 8'h77;
            8'hf6: out = 8'hd6;
            8'hf7: out = 8'h26;
            8'hf8: out = 8'he1;
            8'hf9: out = 8'h69;
            8'hfa: out = 8'h14;
            8'hfb: out = 8'h63;
            8'hfc: out = 8'h55;
            8'hfd: out = 8'h21;
            8'hfe: out = 8'h0c;
            8'hff: out = 8'h7d;
            default: out =8'h00;
        endcase
    end

endmodule

//=======================================================
//  Decryption Shift Rows
//=======================================================

module inv_shift_rows (
    input [127:0] data_in,
    output [127:0] data_out
);

    wire [7:0] B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11, B12, B13, B14, B15;

    assign B0  = data_in[127:120];
    assign B1  = data_in[119:112];
    assign B2  = data_in[111:104];
    assign B3  = data_in[103:96];
    assign B4  = data_in[95:88];
    assign B5  = data_in[87:80];
    assign B6  = data_in[79:72];
    assign B7  = data_in[71:64];
    assign B8  = data_in[63:56];
    assign B9  = data_in[55:48];
    assign B10 = data_in[47:40];
    assign B11 = data_in[39:32];
    assign B12 = data_in[31:24];
    assign B13 = data_in[23:16];
    assign B14 = data_in[15:8];
    assign B15 = data_in[7:0];

    // Row 0: no shift      -> B0,  B4,  B8,  B12
    // Row 1: shift right 1 -> B13, B1,  B5,  B9
    // Row 2: shift right 2 -> B10, B14, B2,  B6
    // Row 3: shift right 3 -> B7,  B11, B15, B3

    // Column 0
    assign data_out[127:120] = B0;
    assign data_out[119:112] = B13;
    assign data_out[111:104] = B10;
    assign data_out[103:96]  = B7;

    // Column 1
    assign data_out[95:88]   = B4;
    assign data_out[87:80]   = B1;
    assign data_out[79:72]   = B14;
    assign data_out[71:64]   = B11;

    // Column 2
    assign data_out[63:56]   = B8;
    assign data_out[55:48]   = B5;
    assign data_out[47:40]   = B2;
    assign data_out[39:32]   = B15;

    // Column 3
    assign data_out[31:24]   = B12;
    assign data_out[23:16]   = B9;
    assign data_out[15:8]    = B6;
    assign data_out[7:0]     = B3;

endmodule

//=======================================================
//  Decryption mix columns
//=======================================================

module inv_mix_columns(
    input [127:0] in,
    output [127:0] out
);

    wire [7:0] B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11, B12, B13, B14, B15;
    assign B0  = in[127:120];
    assign B1  = in[119:112];
    assign B2  = in[111:104];
    assign B3  = in[103:96];
    assign B4  = in[95:88];
    assign B5  = in[87:80];
    assign B6  = in[79:72];
    assign B7  = in[71:64];
    assign B8  = in[63:56];
    assign B9  = in[55:48];
    assign B10 = in[47:40];
    assign B11 = in[39:32];
    assign B12 = in[31:24];
    assign B13 = in[23:16];
    assign B14 = in[15:8];
    assign B15 = in[7:0];

    // Column 0
    wire [7:0] b0t14, b1t11, b2t13, b3t9;
    wire [7:0] b0t9, b1t14, b2t11, b3t13;
    wire [7:0] b0t13, b1t9, b2t14, b3t11;
    wire [7:0] b0t11, b1t13, b2t9, b3t14;

    gf_mult14 m_b0t14(.a(B0), .out(b0t14));
    gf_mult11 m_b1t11(.a(B1), .out(b1t11));
    gf_mult13 m_b2t13(.a(B2), .out(b2t13));
    gf_mult9  m_b3t9(.a(B3), .out(b3t9));

    gf_mult9  m_b0t9(.a(B0), .out(b0t9));
    gf_mult14 m_b1t14(.a(B1), .out(b1t14));
    gf_mult11 m_b2t11(.a(B2), .out(b2t11));
    gf_mult13 m_b3t13(.a(B3), .out(b3t13));

    gf_mult13 m_b0t13(.a(B0), .out(b0t13));
    gf_mult9  m_b1t9(.a(B1), .out(b1t9));
    gf_mult14 m_b2t14(.a(B2), .out(b2t14));
    gf_mult11 m_b3t11(.a(B3), .out(b3t11));

    gf_mult11 m_b0t11(.a(B0), .out(b0t11));
    gf_mult13 m_b1t13(.a(B1), .out(b1t13));
    gf_mult9  m_b2t9(.a(B2), .out(b2t9));
    gf_mult14 m_b3t14(.a(B3), .out(b3t14));

    assign out[127:120] = b0t14 ^ b1t11 ^ b2t13 ^ b3t9;
    assign out[119:112] = b0t9 ^ b1t14 ^ b2t11 ^ b3t13;
    assign out[111:104] = b0t13 ^ b1t9 ^ b2t14 ^ b3t11;
    assign out[103:96]  = b0t11 ^ b1t13 ^ b2t9 ^ b3t14;

    // Column 1
    wire [7:0] b4t14, b5t11, b6t13, b7t9;
    wire [7:0] b4t9, b5t14, b6t11, b7t13;
    wire [7:0] b4t13, b5t9, b6t14, b7t11;
    wire [7:0] b4t11, b5t13, b6t9, b7t14;

    gf_mult14 m_b4t14(.a(B4), .out(b4t14));
    gf_mult11 m_b5t11(.a(B5), .out(b5t11));
    gf_mult13 m_b6t13(.a(B6), .out(b6t13));
    gf_mult9  m_b7t9(.a(B7), .out(b7t9));

    gf_mult9  m_b4t9(.a(B4), .out(b4t9));
    gf_mult14 m_b5t14(.a(B5), .out(b5t14));
    gf_mult11 m_b6t11(.a(B6), .out(b6t11));
    gf_mult13 m_b7t13(.a(B7), .out(b7t13));

    gf_mult13 m_b4t13(.a(B4), .out(b4t13));
    gf_mult9  m_b5t9(.a(B5), .out(b5t9));
    gf_mult14 m_b6t14(.a(B6), .out(b6t14));
    gf_mult11 m_b7t11(.a(B7), .out(b7t11));

    gf_mult11 m_b4t11(.a(B4), .out(b4t11));
    gf_mult13 m_b5t13(.a(B5), .out(b5t13));
    gf_mult9  m_b6t9(.a(B6), .out(b6t9));
    gf_mult14 m_b7t14(.a(B7), .out(b7t14));

    assign out[95:88]   = b4t14 ^ b5t11 ^ b6t13 ^ b7t9;
    assign out[87:80]   = b4t9 ^ b5t14 ^ b6t11 ^ b7t13;
    assign out[79:72]   = b4t13 ^ b5t9 ^ b6t14 ^ b7t11;
    assign out[71:64]   = b4t11 ^ b5t13 ^ b6t9 ^ b7t14;

    // Column 2
    wire [7:0] b8t14, b9t11, b10t13, b11t9;
    wire [7:0] b8t9, b9t14, b10t11, b11t13;
    wire [7:0] b8t13, b9t9, b10t14, b11t11;
    wire [7:0] b8t11, b9t13, b10t9, b11t14;

    gf_mult14 m_b8t14(.a(B8), .out(b8t14));
    gf_mult11 m_b9t11(.a(B9), .out(b9t11));
    gf_mult13 m_b10t13(.a(B10), .out(b10t13));
    gf_mult9  m_b11t9(.a(B11), .out(b11t9));

    gf_mult9  m_b8t9(.a(B8), .out(b8t9));
    gf_mult14 m_b9t14(.a(B9), .out(b9t14));
    gf_mult11 m_b10t11(.a(B10), .out(b10t11));
    gf_mult13 m_b11t13(.a(B11), .out(b11t13));

    gf_mult13 m_b8t13(.a(B8), .out(b8t13));
    gf_mult9  m_b9t9(.a(B9), .out(b9t9));
    gf_mult14 m_b10t14(.a(B10), .out(b10t14));
    gf_mult11 m_b11t11(.a(B11), .out(b11t11));

    gf_mult11 m_b8t11(.a(B8), .out(b8t11));
    gf_mult13 m_b9t13(.a(B9), .out(b9t13));
    gf_mult9  m_b10t9(.a(B10), .out(b10t9));
    gf_mult14 m_b11t14(.a(B11), .out(b11t14));

    assign out[63:56]   = b8t14 ^ b9t11 ^ b10t13 ^ b11t9;
    assign out[55:48]   = b8t9 ^ b9t14 ^ b10t11 ^ b11t13;
    assign out[47:40]   = b8t13 ^ b9t9 ^ b10t14 ^ b11t11;
    assign out[39:32]   = b8t11 ^ b9t13 ^ b10t9 ^ b11t14;

    // Column 3
    wire [7:0] b12t14, b13t11, b14t13, b15t9;
    wire [7:0] b12t9, b13t14, b14t11, b15t13;
    wire [7:0] b12t13, b13t9, b14t14, b15t11;
    wire [7:0] b12t11, b13t13, b14t9, b15t14;

    gf_mult14 m_b12t14(.a(B12), .out(b12t14));
    gf_mult11 m_b13t11(.a(B13), .out(b13t11));
    gf_mult13 m_b14t13(.a(B14), .out(b14t13));
    gf_mult9  m_b15t9(.a(B15), .out(b15t9));

    gf_mult9  m_b12t9(.a(B12), .out(b12t9));
    gf_mult14 m_b13t14(.a(B13), .out(b13t14));
    gf_mult11 m_b14t11(.a(B14), .out(b14t11));
    gf_mult13 m_b15t13(.a(B15), .out(b15t13));

    gf_mult13 m_b12t13(.a(B12), .out(b12t13));
    gf_mult9  m_b13t9(.a(B13), .out(b13t9));
    gf_mult14 m_b14t14(.a(B14), .out(b14t14));
    gf_mult11 m_b15t11(.a(B15), .out(b15t11));

    gf_mult11 m_b12t11(.a(B12), .out(b12t11));
    gf_mult13 m_b13t13(.a(B13), .out(b13t13));
    gf_mult9  m_b14t9(.a(B14), .out(b14t9));
    gf_mult14 m_b15t14(.a(B15), .out(b15t14));

    assign out[31:24]   = b12t14 ^ b13t11 ^ b14t13 ^ b15t9;
    assign out[23:16]   = b12t9 ^ b13t14 ^ b14t11 ^ b15t13;
    assign out[15:8]    = b12t13 ^ b13t9 ^ b14t14 ^ b15t11;
    assign out[7:0]     = b12t11 ^ b13t13 ^ b14t9 ^ b15t14;

endmodule

//=======================================================
//  Special Greates Factor Multiplication modules
//=======================================================

module gf_mult2 (
    input  [7:0] a,
    output [7:0] out
);
    assign out = (a[7]) ? ((a << 1) ^ 8'h1b) : (a << 1);
endmodule

module gf_mult3 (
    input  [7:0] a,
    output [7:0] out
);
    wire [7:0] t;
    gf_mult2 m(.a(a), .out(t));
    assign out = t ^ a;
endmodule

module gf_mult9 (
    input [7:0] a,
    output [7:0] out
);
    wire [7:0] a2, a4, a8;
    gf_mult2 m_a2(.a(a), .out(a2));
    gf_mult2 m_a4(.a(a2), .out(a4));
    gf_mult2 m_a8(.a(a4), .out(a8));

    assign out = a8 ^ a;
endmodule

module gf_mult11 (
    input [7:0] a,
    output [7:0] out
);
    wire [7:0] a2, a4, a8;
    gf_mult2 m_a2(.a(a), .out(a2));
    gf_mult2 m_a4(.a(a2), .out(a4));
    gf_mult2 m_a8(.a(a4), .out(a8));

    assign out = a8 ^ a2 ^ a;
endmodule

module gf_mult13 (
    input [7:0] a,
    output [7:0] out
);
    wire [7:0] a2, a4, a8;
    gf_mult2 m_a2(.a(a), .out(a2));
    gf_mult2 m_a4(.a(a2), .out(a4));
    gf_mult2 m_a8(.a(a4), .out(a8));

    assign out = a8 ^ a4 ^ a;
endmodule

module gf_mult14 (
    input [7:0] a,
    output [7:0] out
);
    wire [7:0] a2, a4, a8;
    gf_mult2 m_a2(.a(a), .out(a2));
    gf_mult2 m_a4(.a(a2), .out(a4));
    gf_mult2 m_a8(.a(a4), .out(a8));

    assign out = a8 ^ a4 ^ a2;
endmodule

// AI was used to generate this code, but it is not perfect. Please review and test it before using it in production.
