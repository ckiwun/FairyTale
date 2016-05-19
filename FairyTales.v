`include "VGA_Param.h" 

module FairyTales(

	//////////// CLOCK //////////
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,

	//////////// Sma //////////
	SMA_CLKIN,
	SMA_CLKOUT,

	//////////// LED //////////
	LEDG,
	LEDR,

	//////////// KEY //////////
	KEY,

	//////////// EJTAG //////////
	EX_IO,

	//////////// SW //////////
	SW,

	//////////// SEG7 //////////
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,

	//////////// LCD //////////
	LCD_BLON,
	LCD_DATA,
	LCD_EN,
	LCD_ON,
	LCD_RS,
	LCD_RW,

	//////////// RS232 //////////
	UART_CTS,
	UART_RTS,
	UART_RXD,
	UART_TXD,

	//////////// PS2 for Keyboard and Mouse //////////
	PS2_CLK,
	PS2_CLK2,
	PS2_DAT,
	PS2_DAT2,

	//////////// SDCARD //////////
	SD_CLK,
	SD_CMD,
	SD_DAT,
	SD_WP_N,

	//////////// VGA //////////
	VGA_B,
	VGA_BLANK_N,
	VGA_CLK,
	VGA_G,
	VGA_HS,
	VGA_R,
	VGA_SYNC_N,
	VGA_VS,

	//////////// Audio //////////
	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACDAT,
	AUD_DACLRCK,
	AUD_XCK,

	//////////// I2C for EEPROM //////////
	EEP_I2C_SCLK,
	EEP_I2C_SDAT,

	//////////// I2C for Audio Tv-Decoder  //////////
	I2C_SCLK,
	I2C_SDAT,

	//////////// Ethernet 0 //////////
	ENET0_GTX_CLK,
	ENET0_INT_N,
	ENET0_LINK100,
	ENET0_MDC,
	ENET0_MDIO,
	ENET0_RST_N,
	ENET0_RX_CLK,
	ENET0_RX_COL,
	ENET0_RX_CRS,
	ENET0_RX_DATA,
	ENET0_RX_DV,
	ENET0_RX_ER,
	ENET0_TX_CLK,
	ENET0_TX_DATA,
	ENET0_TX_EN,
	ENET0_TX_ER,
	ENETCLK_25,

	//////////// Ethernet 1 //////////
	ENET1_GTX_CLK,
	ENET1_INT_N,
	ENET1_LINK100,
	ENET1_MDC,
	ENET1_MDIO,
	ENET1_RST_N,
	ENET1_RX_CLK,
	ENET1_RX_COL,
	ENET1_RX_CRS,
	ENET1_RX_DATA,
	ENET1_RX_DV,
	ENET1_RX_ER,
	ENET1_TX_CLK,
	ENET1_TX_DATA,
	ENET1_TX_EN,
	ENET1_TX_ER,

	//////////// TV Decoder //////////
	TD_CLK27,
	TD_DATA,
	TD_HS,
	TD_RESET_N,
	TD_VS,

	//////////// USB 2.0 OTG //////////
	OTG_ADDR,
	OTG_CS_N,
	OTG_DACK_N,
	OTG_DATA,
	OTG_DREQ,
	OTG_FSPEED,
	OTG_INT,
	OTG_LSPEED,
	OTG_RD_N,
	OTG_RST_N,
	OTG_WE_N,

	//////////// IR Receiver //////////
	IRDA_RXD,

	//////////// SDRAM //////////
	DRAM_ADDR,
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_CKE,
	DRAM_CLK,
	DRAM_CS_N,
	DRAM_DQ,
	DRAM_DQM,
	DRAM_RAS_N,
	DRAM_WE_N,

	//////////// SRAM //////////
	SRAM_ADDR,
	SRAM_CE_N,
	SRAM_DQ,
	SRAM_LB_N,
	SRAM_OE_N,
	SRAM_UB_N,
	SRAM_WE_N,

	//////////// Flash //////////
	FL_ADDR,
	FL_CE_N,
	FL_DQ,
	FL_OE_N,
	FL_RST_N,
	FL_RY,
	FL_WE_N,
	FL_WP_N,

	//////////// GPIO, GPIO connect to D5M - 5M Pixel Camera //////////
	D5M_D,
	D5M_FVAL,
	D5M_LVAL,
	D5M_PIXLCLK,
	D5M_RESET_N,
	D5M_SCLK,
	D5M_SDATA,
	D5M_STROBE,
	D5M_TRIGGER,
	D5M_XCLKIN,
	
	
	/////////// GPIO_1 ////////////////////////////////////////////////
	GPIO_1
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input		          		CLOCK_50;
input		          		CLOCK2_50;
input		          		CLOCK3_50;

//////////// Sma //////////
input		          		SMA_CLKIN;
output		          		SMA_CLKOUT;

//////////// LED //////////
output		     [8:0]		LEDG;
output		    [17:0]		LEDR;

//////////// KEY //////////
input		     [3:0]		KEY;

//////////// EJTAG //////////
inout		     [6:0]		EX_IO;

//////////// SW //////////
input		    [17:0]		SW;

//////////// SEG7 //////////
output		     [6:0]		HEX0;
output		     [6:0]		HEX1;
output		     [6:0]		HEX2;
output		     [6:0]		HEX3;
output		     [6:0]		HEX4;
output		     [6:0]		HEX5;
output		     [6:0]		HEX6;
output		     [6:0]		HEX7;

//////////// LCD //////////
output		          		LCD_BLON;
inout		     [7:0]		LCD_DATA;
output		          		LCD_EN;
output		          		LCD_ON;
output		          		LCD_RS;
output		          		LCD_RW;

//////////// RS232 //////////
output		          		UART_CTS;
input		          		UART_RTS;
input		          		UART_RXD;
output		          		UART_TXD;

//////////// PS2 for Keyboard and Mouse //////////
inout		          		PS2_CLK;
inout		          		PS2_CLK2;
inout		          		PS2_DAT;
inout		          		PS2_DAT2;

//////////// SDCARD //////////
output		          		SD_CLK;
inout		          		SD_CMD;
inout		     [3:0]		SD_DAT;
input		          		SD_WP_N;

//////////// VGA //////////
output		     [7:0]		VGA_B;
output		          		VGA_BLANK_N;
output		          		VGA_CLK;
output		     [7:0]		VGA_G;
output		          		VGA_HS;
output		     [7:0]		VGA_R;
output		          		VGA_SYNC_N;
output		          		VGA_VS;

//////////// Audio //////////
input		          		AUD_ADCDAT;
inout		          		AUD_ADCLRCK;
inout		          		AUD_BCLK;
output		          		AUD_DACDAT;
inout		          		AUD_DACLRCK;
output		          		AUD_XCK;

//////////// I2C for EEPROM //////////
output		          		EEP_I2C_SCLK;
inout		          		EEP_I2C_SDAT;

//////////// I2C for Audio Tv-Decoder  //////////
output		          		I2C_SCLK;
inout		          		I2C_SDAT;

//////////// Ethernet 0 //////////
output		          		ENET0_GTX_CLK;
input		          		ENET0_INT_N;
input		          		ENET0_LINK100;
output		          		ENET0_MDC;
inout		          		ENET0_MDIO;
output		          		ENET0_RST_N;
input		          		ENET0_RX_CLK;
input		          		ENET0_RX_COL;
input		          		ENET0_RX_CRS;
input		     [3:0]		ENET0_RX_DATA;
input		          		ENET0_RX_DV;
input		          		ENET0_RX_ER;
input		          		ENET0_TX_CLK;
output		     [3:0]		ENET0_TX_DATA;
output		          		ENET0_TX_EN;
output		          		ENET0_TX_ER;
input		          		ENETCLK_25;

//////////// Ethernet 1 //////////
output		          		ENET1_GTX_CLK;
input		          		ENET1_INT_N;
input		          		ENET1_LINK100;
output		          		ENET1_MDC;
inout		          		ENET1_MDIO;
output		          		ENET1_RST_N;
input		          		ENET1_RX_CLK;
input		          		ENET1_RX_COL;
input		          		ENET1_RX_CRS;
input		     [3:0]		ENET1_RX_DATA;
input		          		ENET1_RX_DV;
input		          		ENET1_RX_ER;
input		          		ENET1_TX_CLK;
output		     [3:0]		ENET1_TX_DATA;
output		          		ENET1_TX_EN;
output		          		ENET1_TX_ER;

//////////// TV Decoder //////////
input		          		TD_CLK27;
input		     [7:0]		TD_DATA;
input		          		TD_HS;
output		          		TD_RESET_N;
input		          		TD_VS;

//////////// USB 2.0 OTG //////////
output		     [1:0]		OTG_ADDR;
output		          		OTG_CS_N;
output		     [1:0]		OTG_DACK_N;
inout		    [15:0]		OTG_DATA;
input		     [1:0]		OTG_DREQ;
inout		          		OTG_FSPEED;
input		     [1:0]		OTG_INT;
inout		          		OTG_LSPEED;
output		          		OTG_RD_N;
output		          		OTG_RST_N;
output		          		OTG_WE_N;

//////////// IR Receiver //////////
input		          		IRDA_RXD;

//////////// SDRAM //////////
output		    [12:0]		DRAM_ADDR;
output		     [1:0]		DRAM_BA;
output		          		DRAM_CAS_N;
output		          		DRAM_CKE;
output		          		DRAM_CLK;
output		          		DRAM_CS_N;
inout		    [31:0]		DRAM_DQ;
output		     [3:0]		DRAM_DQM;
output		          		DRAM_RAS_N;
output		          		DRAM_WE_N;

//////////// SRAM //////////
output		    [19:0]		SRAM_ADDR;
output		          		SRAM_CE_N;
inout		    [15:0]		SRAM_DQ;
output		          		SRAM_LB_N;
output		          		SRAM_OE_N;
output		          		SRAM_UB_N;
output		          		SRAM_WE_N;

//////////// Flash //////////
output		    [22:0]		FL_ADDR;
output		          		FL_CE_N;
inout		     [7:0]		FL_DQ;
output		          		FL_OE_N;
output		          		FL_RST_N;
input		          		FL_RY;
output		          		FL_WE_N;
output		          		FL_WP_N;

//////////// GPIO, GPIO connect to D5M - 5M Pixel Camera //////////
input		    [11:0]		D5M_D;
input		          		D5M_FVAL;
input		          		D5M_LVAL;
input		          		D5M_PIXLCLK;
output		          		D5M_RESET_N;
output		          		D5M_SCLK;
inout		          		D5M_SDATA;
input		          		D5M_STROBE;
output		          		D5M_TRIGGER;
output		          		D5M_XCLKIN;


//=======================================================
//  REG/WIRE declarations
//=======================================================
wire	[15:0]	Read_DATA1;
wire	[15:0]	Read_DATA2;

wire	[11:0]	mCCD_DATA;
wire			mCCD_DVAL;
wire			mCCD_DVAL_d;
wire	[15:0]	X_Cont;
wire	[15:0]	Y_Cont;
wire	[9:0]	X_ADDR;
wire	[31:0]	Frame_Cont;
wire			DLY_RST_0;
wire			DLY_RST_1;
wire			DLY_RST_2;
wire			DLY_RST_3;
wire			DLY_RST_4;
wire			KEY3_RST_0;
wire			KEY3_RST_1;
wire			KEY3_RST_2;
wire			KEY3_RST_3;
wire			KEY3_RST_4;
wire			CHG_RST_0;
wire            CHG_RST_1;
wire            CHG_RST_2;
wire            CHG_RST_3;
wire            CHG_RST_4;
wire			Read;
wire			mRead;
wire			[9:0] pRed;
wire			[9:0] pGreen;
wire			[9:0] pBlue;
reg		[11:0]	rCCD_DATA;
reg				rCCD_LVAL;
reg				rCCD_FVAL;
wire	[11:0]	sCCD_R;
wire	[11:0]	sCCD_G;
wire	[11:0]	sCCD_B;
wire			sCCD_DVAL;

wire			sdram_ctrl_clk;
wire	[9:0]	oVGA_R;   				//	VGA Red[9:0]
wire	[9:0]	oVGA_G;	 				//	VGA Green[9:0]
wire	[9:0]	oVGA_B;   				//	VGA Blue[9:0]
wire		[3:0]	lum;
wire		[3:0]	sat;
wire				ch;

wire			RGBisfinish;
wire 	[8:0]	detectSkin;
wire	[8:0]	detectBlack;
wire			loose_detectSkin1;
wire			loose_detectSkin3;
wire			loose_detectSkin5;
wire			loose_detectSkin7;
wire			loose_detectSkin1357;
assign			loose_detectSkin1357=(loose_detectSkin1+loose_detectSkin3+loose_detectSkin5+loose_detectSkin7>2)?1:0;

wire			isSkin;
wire		 	isGreen;
// output for VGA_Controller
wire	[47:0]	o_isFinger;
wire			KEY_signal;
wire			is_finished;

wire	b_lum_add;
wire	b_lum_sub;
wire	b_sat_add;
wire	b_sat_sub;
wire	b_screen_shot;
wire	b_reset;
reg		pre_b_screen_shot;
wire	b_change_mode;
reg	[1:0]	change_mode;
reg	[1:0]	next_change_mode;
wire	b_write;
wire	b_write_back;
reg		write_mode;
wire	b_control;
wire	b_control_back;

assign b_lum_add = ~change_mode[1] || KEY_signal || ~o_isFinger[39];	
assign b_lum_sub = ~change_mode[1] || KEY_signal || ~o_isFinger[47];	
assign b_sat_add = ~change_mode[1] || KEY_signal || ~o_isFinger[38];	
assign b_sat_sub = ~change_mode[1] || KEY_signal || ~o_isFinger[46];
//assign b_screen_shot = ~change_mode[1] || KEY_signal || ~o_isFinger[40];
assign b_screen_shot = ~change_mode[1] || KEY_signal ||(~((detectSkin[0]&detectSkin[8]&loose_detectSkin1357)|(detectSkin[2]&detectSkin[6])&loose_detectSkin1357)||(~detectSkin[4]))&&( ~o_isFinger[40]);	
assign b_reset = 1;/*KEY_signal || ~o_isFinger[7];*/
assign b_control = change_mode[0] || KEY_signal || ~o_isFinger[7];
assign b_control_back = change_mode[0] || KEY_signal || ~o_isFinger[6];
assign b_change_mode = KEY_signal || ~o_isFinger[0];
assign b_write = change_mode[1] && (change_mode[0] || KEY_signal || ~o_isFinger[32]);
assign b_write_back = change_mode[1] && (change_mode[0] || KEY_signal || ~o_isFinger[24]);

// different color //
wire	b_write_red;
wire	b_write_yellow;
wire	b_write_blue;
wire	b_write_erase;
assign	b_write_red		= change_mode[1] && (~write_mode || change_mode[0] || KEY_signal || ~o_isFinger[2]);
assign	b_write_yellow	= change_mode[1] && (~write_mode || change_mode[0] || KEY_signal || ~o_isFinger[3]);
assign	b_write_blue	= change_mode[1] && (~write_mode || change_mode[0] || KEY_signal || ~o_isFinger[4]);
assign	b_write_erase	= 1;//change_mode[1] && (~write_mode || change_mode[0] || KEY_signal || ~o_isFinger[5]);


always @(*) begin
	case({b_write_red,b_write_yellow,b_write_blue,b_write_erase}) 
		4'b0111: 	next_varied_color = 2'b00;
		4'b1011:	next_varied_color = 2'b01;
		4'b1101:	next_varied_color = 2'b10;
		4'b1110: 	next_varied_color = 2'b11;
		default: 	next_varied_color = varied_color;
	endcase
end




///////////////////////////////////////////////////////////////////////////////////////////////////////////write

wire	write;
reg 	pre_write;
reg		next_write_mode;

assign 	write = write_mode ? b_write_back : b_write;
/*
assign	FL_RST_N = 1;
assign	FL_WP_N = 1;
assign  FL_CE_N = 0;
assign  FL_WE_N = 1;
assign	SRAM_CE_N = 0;
assign	SRAM_LB_N = 0;
assign	SRAM_UB_N = 0;

wire	[19:0]	VGAread_Addr;
reg		Init_FL_State;
reg		next_Init_FL_State;
reg		[20:0]	FL_counter;
reg		[20:0]	next_FL_counter;
reg		[15:0]	FL_DQ_buffer;
reg		[15:0]	next_FL_DQ_buffer;
wire	Init_FL_rst;
wire	sram_write_finish;
wire	sram_need_write;
reg		[22:0]	FL_ADDR;
reg		FL_OE_N;
reg		[19:0]	SRAM_ADDR;
reg		SRAM_WE_N;
reg		SRAM_OE_N;
reg		[15:0]	SRAM_DQ;
reg		UI_State;
reg		next_UI_State;
wire	UI_rst;

assign	UI_rst = (!KEY[0]);
assign  Init_FL_rst = (!KEY[0]);
assign	sram_need_write = 0;
assign	sram_write_finish = (FL_counter>=21'd1000000)?1:0;

parameter	REFRESH = 0;
parameter	IDLE = 1;
parameter	SRAM_WRITE = 0;
parameter	SRAM_READ = 1;

// sram-flash control
always @(*) begin
	case(UI_State)
		SRAM_WRITE:	begin
						SRAM_ADDR = FL_ADDR[20:1];
						SRAM_WE_N = 0;
						SRAM_OE_N = 1;
						if(FL_counter>21'd960000)
							SRAM_DQ = 'hz;
						else
							SRAM_DQ = FL_DQ_buffer;
						if(sram_write_finish)
							next_UI_State = SRAM_READ;
						else
							next_UI_State = SRAM_WRITE;
					end
		SRAM_READ:	begin
						SRAM_ADDR = VGAread_Addr;
						SRAM_WE_N = 1;
						SRAM_OE_N = 0;
						//SRAM_DQ = 0;
						if(sram_need_write)
							next_UI_State = SRAM_WRITE;
						else
							next_UI_State = SRAM_READ;
					end
	endcase
end

always @(posedge flash_clk_3M or posedge UI_rst) begin
	if(UI_rst) begin
		UI_State <= SRAM_WRITE;
	end
	else begin
		UI_State <= next_UI_State;
	end
end

//flash FSM control
always @(*) begin
	case(Init_FL_State)
		REFRESH:begin
					if(FL_counter[0])
						next_FL_DQ_buffer = {FL_DQ_buffer[15:8],FL_DQ};
					else
						next_FL_DQ_buffer = {FL_DQ,FL_DQ_buffer[7:0]};
					next_FL_counter = FL_counter + 1;
					FL_ADDR = FL_counter;
					FL_OE_N = 0;
					if(sram_write_finish)
						next_Init_FL_State = IDLE;
					else
						next_Init_FL_State = REFRESH;
				end
		IDLE:	begin
					next_FL_DQ_buffer = 0;
					next_FL_counter = 0;
					FL_ADDR = 0;
					FL_OE_N = 1;
					if(sram_need_write)
						next_Init_FL_State = REFRESH;
					else
						next_Init_FL_State = IDLE;
				end
	endcase
end

always @(posedge flash_clk_6M or posedge Init_FL_rst) begin
	if(Init_FL_rst) begin
		FL_counter <= 0;
		Init_FL_State <= REFRESH;
		FL_DQ_buffer <= 0;
	end
	else begin
		FL_counter <= next_FL_counter;
		Init_FL_State <= next_Init_FL_State;
		FL_DQ_buffer <= next_FL_DQ_buffer;
	end
end
*/
///////////////////////////////////////////////////////////////////////////////////////////////////
reg	[1:0]	varied_color; // 00:red 01:yellow 10:blue
reg	[1:0]	next_varied_color;

output [34:5] GPIO_1 ; 
//assign GPIO_1[16:5] = {detectBlack,change_mode,change,is_finished};

//power on start
wire             auto_start;
//=======================================================
//  Structural coding
//=======================================================
// D5M
assign	D5M_TRIGGER	=	1'b1;  // tRIGGER
assign	D5M_RESET_N	=	DLY_RST_1;
assign  VGA_CTRL_CLK = ~VGA_CLK;

assign	LEDR		=	SW;
assign	LEDG		=	Y_Cont;
assign	UART_TXD = UART_RXD;

//fetch the high 8 bits
assign  VGA_R = oVGA_R[9:2];
assign  VGA_G = oVGA_G[9:2];
assign  VGA_B = oVGA_B[9:2];

//D5M read 
always@(posedge D5M_PIXLCLK)
begin
	rCCD_DATA	<=	D5M_D;
	rCCD_LVAL	<=	D5M_LVAL;
	rCCD_FVAL	<=	D5M_FVAL;
end

//auto start when power on
assign auto_start = (/*(~KEY[0])||*/((CHG_RST_3)&&(!CHG_RST_4))||((KEY3_RST_3)&&(!KEY3_RST_4))||((DLY_RST_3)&&(!DLY_RST_4)))? 1'b1:1'b0;

//Reset module
Reset_Delay			u2	(	.iCLK(CLOCK2_50),
							.iRST(KEY[0]&b_reset),
							.oRST_0(DLY_RST_0),
							.oRST_1(DLY_RST_1),
							.oRST_2(DLY_RST_2),
							.oRST_3(DLY_RST_3),
							.oRST_4(DLY_RST_4)
						);
Reset_Delay_3		u10 (	.iCLK(CLOCK2_50),
							.iRST(delay_KEY3),
							.iFVAL(rCDD_FVAL),
							.oRST_0(KEY3_RST_0),
							.oRST_1(KEY3_RST_1),
							.oRST_2(KEY3_RST_2),
							.oRST_3(KEY3_RST_3),
							.oRST_4(KEY3_RST_4)
						);
Reset_Delay			u11	(	.iCLK(CLOCK2_50),
							.iRST(!(ChangeAddr||ChangeSW3)),
							.oRST_0(CHG_RST_0),
							.oRST_1(CHG_RST_1),
							.oRST_2(CHG_RST_2),
							.oRST_3(CHG_RST_3),
							.oRST_4(CHG_RST_4)
						);
//icon & ROM
wire	[3:0]	icon_num;
wire	[12:0]	icon_local_address;
wire	[15:0]	rom_address;
wire	[47:0]	rom_data;
wire	[7:0]	icon_Red;
wire	[7:0]	icon_Green;
wire	[7:0]	icon_Blue;

icon_transfer		u13 (	//host input
							.number(icon_num),
							.address(icon_local_address),
							.rom_address(rom_address),
							//host output
							.rom_data(rom_data),
							.oRed(icon_Red),
							.oGreen(icon_Green),
							.oBlue(icon_Blue)
						);
icon_rom			u12	(	.address(rom_address),
							.clock(VGA_CTRL_CLK),
							.q(rom_data)
						);
//D5M image capture
CCD_Capture			u3	(	.oDATA(mCCD_DATA),
							.oDVAL(mCCD_DVAL),
							.oX_Cont(X_Cont),
							.oY_Cont(Y_Cont),
							.oFrame_Cont(Frame_Cont),
							.iDATA(rCCD_DATA),
							.iFVAL(rCCD_FVAL),
							.iLVAL(rCCD_LVAL),
							.iSTART(/*!KEY[3]|*/auto_start),
							.iEND(1'b0/*!KEY[2]*/),
							.iCLK(~D5M_PIXLCLK),
							.iRST(DLY_RST_2&KEY3_RST_2&&CHG_RST_2)
						);
//D5M raw date convert to RGB data
`ifdef VGA_640x480p60
RAW2RGB				u4	(	.iCLK(D5M_PIXLCLK),
							.iRST(DLY_RST_1&KEY3_RST_1&CHG_RST_1),
							.iDATA(mCCD_DATA),
							.iDVAL(mCCD_DVAL),
							.oRed(sCCD_R),
							.oGreen(sCCD_G),
							.oBlue(sCCD_B),
							.oDVAL(sCCD_DVAL),
							.iX_Cont(X_Cont),
							.iY_Cont(Y_Cont)
						);
`else
RAW2RGB				u4	(	.iCLK(D5M_PIXLCLK),
							.iRST_n(DLY_RST_1&KEY3_RST_1&CHG_RST_1),
							.iData(mCCD_DATA),
							.iDval(mCCD_DVAL),
							.oRed(sCCD_R),
							.oGreen(sCCD_G),
							.oBlue(sCCD_B),
							.oDval(sCCD_DVAL),
							.iX_Cont(X_Cont),
							.iY_Cont(Y_Cont),
							.write_mode(write_mode&change_mode[1]),
							.detectSkin(detectSkin),
							.detectBlack(detectBlack),
							.varied_color(varied_color),
							.loose_detectSkin1(loose_detectSkin1),
							.loose_detectSkin3(loose_detectSkin3),
							.loose_detectSkin5(loose_detectSkin5),
							.loose_detectSkin7(loose_detectSkin7)
						);
`endif
//Frame count display
SEG7_LUT_8 			u5	(	.oSEG0(HEX0),.oSEG1(HEX1),
							.oSEG2(HEX2),.oSEG3(HEX3),
							.oSEG4(HEX4),.oSEG5(HEX5),
							.oSEG6(HEX6),.oSEG7(HEX7),
							.iDIG({display_num,pic_num,2'b00,change_mode,2'b00,varied_color,Frame_Cont[15:0]})
						);
						
sdram_pll 			u6	(
							.inclk0(CLOCK2_50),
							.c0(sdram_ctrl_clk),
							.c1(DRAM_CLK),
							.c2(D5M_XCLKIN), //25M
`ifdef VGA_640x480p60
							.c3(VGA_CLK)     //25M 
`else
						    .c4(VGA_CLK)     //40M 	
`endif
						);

wire	flash_clk_3M;
wire	flash_clk_6M;
						
flash_pll			pll01(
							.inclk0(CLOCK2_50),
							.c0(flash_clk_6M),
							.c1(flash_clk_3M)
						);
						
wire	SDRAM_WR;
wire	SDRAM_RD;
						
//SDRam Read and Write as Frame Buffer
Sdram_Control	u7	(		//	HOST Side						
						    .RESET_N(KEY[0]&b_reset&delay_KEY3),
							.CLK(sdram_ctrl_clk),
							.SNAP(~delay_KEY3),
							.ChangeAddr(ChangeAddr||ChangeSW3),
							//	FIFO Write Side 1
							.WR1_DATA({1'b0,sCCD_G[11:7],sCCD_B[11:2]}),
							.WR1(sCCD_DVAL),
`ifdef VGA_640x480p60
							.WR1_ADDR(0+pic_num*640*480/2),
						    .WR1_MAX_ADDR(640*480/2+pic_num*640*480/2),
						    .WR1_LENGTH(8'h50),
`else
							.WR1_ADDR(0+pic_num*800*600/2),
							.WR1_MAX_ADDR(800*600/2+pic_num*800*600/2),
							.WR1_LENGTH(8'h80),
`endif							
							.WR1_LOAD((!DLY_RST_0)||(!KEY3_RST_0)||(!CHG_RST_0)),
							.WR1_CLK(D5M_PIXLCLK),

							//	FIFO Write Side 2
							.WR2_DATA({1'b0,sCCD_G[6:2],sCCD_R[11:2]}),
							.WR2(sCCD_DVAL),
`ifdef VGA_640x480p60
							.WR2_ADDR(23'h200000+pic_num*640*480/2 ),
						    .WR2_MAX_ADDR(23'h200000+640*480/2+pic_num*640*480/2),
							.WR2_LENGTH(8'h50),
`else			
							.WR2_ADDR(23'h200000+pic_num*800*600/2 ),				
							.WR2_MAX_ADDR(23'h200000+800*600/2+pic_num*800*600/2),
							.WR2_LENGTH(8'h80),
`endif	
							.WR2_LOAD((!DLY_RST_0)||(!KEY3_RST_0)||(!CHG_RST_0)),
							.WR2_CLK(D5M_PIXLCLK),

							//	FIFO Read Side 1
						    .RD1_DATA(Read_DATA1),
				        	.RD1(Read),
`ifdef VGA_640x480p60
				        	.RD1_ADDR(0+offset_num*640*480/2),
						    .RD1_MAX_ADDR(640*480/2+offset_num*640*480/2),
							.RD1_LENGTH(8'h50),
`else
				        	.RD1_ADDR(0+offset_num*800*600/2),
							.RD1_MAX_ADDR(800*600/2+offset_num*800*600/2),
							.RD1_LENGTH(8'h80),
`endif
							.RD1_LOAD((!DLY_RST_0)||(!KEY3_RST_0)||(!CHG_RST_0)),
							.RD1_CLK(~VGA_CTRL_CLK),
							
							//	FIFO Read Side 2
						    .RD2_DATA(Read_DATA2),
							.RD2(Read),
`ifdef VGA_640x480p60
							.RD2_ADDR(23'h200000+offset_num*640*480/2),
						    .RD2_MAX_ADDR(23'h200000+640*480/2+offset_num*640*480/2),
							.RD2_LENGTH(8'h50),
`else
							.RD2_ADDR(23'h200000+offset_num*800*600/2),
							.RD2_MAX_ADDR(23'h200000+800*600/2+offset_num*800*600/2),
							.RD2_LENGTH(8'h80),
`endif
				        	.RD2_LOAD((!DLY_RST_0)||(!KEY3_RST_0)||(!CHG_RST_0)),
							.RD2_CLK(~VGA_CTRL_CLK),
							
							//	SDRAM Side
						    .SA(DRAM_ADDR),
							.BA(DRAM_BA),
							.CS_N(DRAM_CS_N),
							.CKE(DRAM_CKE),
							.RAS_N(DRAM_RAS_N),
							.CAS_N(DRAM_CAS_N),
							.WE_N(DRAM_WE_N),
							.DQ(DRAM_DQ),
							.DQM(DRAM_DQM),
							//	SDRAM Frame done signal
							.Frame_wdone(Frame_wdone),
							.Frame_rdone(Frame_rdone)
						);
//D5M I2C control
I2C_CCD_Config 		u8	(	//	Host Side
							.iCLK(CLOCK2_50),
							.iRST_N(DLY_RST_2&KEY3_RST_2&CHG_RST_2),
							.iEXPOSURE_ADJ(1'b1/*KEY[1]*/),
							.iEXPOSURE_DEC_p(SW[0]),
							.iZOOM_MODE_SW(SW[15]),
							//	I2C Side
							.I2C_SCLK(D5M_SCLK),
							.I2C_SDAT(D5M_SDATA)
						);
						
Complexion_Detection	u9(
							.clk(VGA_CTRL_CLK),
							.rst(KEY[0]&b_reset),
							//  luminance
							.add_lum(b_lum_add|(change_mode!=2'b10)),
							.sub_lum(b_lum_sub|(change_mode!=2'b10)),
							.add_sat(b_sat_add|(change_mode!=2'b10)),
							.sub_sat(b_sat_sub|(change_mode!=2'b10)),
							//  Control side
							.oRequest(Read),
							.iRed(Read_DATA2[9:0]),
							.iGreen({Read_DATA1[14:10],Read_DATA2[14:10]}),
							.iBlue(Read_DATA1[9:0]),
							.iIsSkin(Read_DATA1[15]),
							.iIsGreen(Read_DATA2[15]),
							//  VGA side
							.iRequest(mRead),
							.oRed(pRed),
							.oGreen(pGreen),
							.oBlue(pBlue),
							.oIsSkin(isSkin),
							.oIsGreen(isGreen),
							//  Control
							.iSwitch({SW[17],SW[16]}),
							.luminance(lum),
							.saturation(sat)
						);

VGA_Controller		u1	(	//	Host Side
							.oRequest(mRead),
							.iRed(pRed),
							.iGreen(pGreen),
							.iBlue(pBlue),
							.iIsSkin(isSkin),
							.iIsGreen(isGreen),
							.idetectSkin(detectSkin),
							.idetectBlack(detectBlack),
							//	VGA Side
							.oVGA_R(oVGA_R),
							.oVGA_G(oVGA_G),
							.oVGA_B(oVGA_B),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC_N),
							.oVGA_BLANK(VGA_BLANK_N),
							//	Control Signal
							.iCLK(VGA_CTRL_CLK),
							.iRST_N(DLY_RST_2&KEY3_RST_2&CHG_RST_2),
							.iZOOM_MODE_SW(SW[15]),
							.change_mode(change_mode),
							.write_mode(write_mode),
							// 	Finger Patch Detection	//
							.o_isFinger(o_isFinger),
							.KEY(KEY_signal),
							.is_finished(is_finished),
							//	Wave hand detection
							.add(vga_add),
							.sub(vga_sub),
							.lum(lum),
							.sat(sat),
							//  skin_signal
							.skin_signal(change),
							//  different color
							.varied_color(varied_color),
							.shimmer(snap_counter[23]),
							.display_num(display_num),
							.pic_num(pic_num),
							//  interface
							.local_addr(icon_local_address),
							.icon_number(icon_num),
							.interface_R(icon_Red),
							.interface_G(icon_Green),
							.interface_B(icon_Blue)
						);


reg		[3:0]		pic_num;
reg		[3:0]		next_pic_num;
reg		[3:0]		display_num;
reg		[3:0]		next_display_num;
reg		[3:0]		offset_num;
reg					event_add;
reg					event_sub;
wire				vga_add;
wire				vga_sub;
reg					pre_KEY1;
reg					pre_KEY2;
reg					pre_KEY3;
reg					pre_SW3;
reg					pre_Frame_wdone;
reg					pre_Frame_rdone;
wire				pic_rst;
wire				Frame_wdone;
wire				Frame_rdone;
wire	[22:0]		SDRAM_ADDR;
wire				SDRAM_WRITE;
wire				SDRAM_READ;
reg					delay_KEY3;
reg					next_delay_KEY3;
reg					press_KEY3;
reg					next_press_KEY3;
reg					delay_SW3;
reg					next_delay_SW3;
reg					ChangeAddr;
reg					next_ChangeAddr;
reg					ChangeSW3;
reg					next_ChangeSW3;
reg					SW3hasChange;
reg					next_SW3hasChange;
reg					AddrhasChange;
reg					next_AddrhasChange;
reg		[31:0]		snap_counter;
reg		[31:0]		next_snap_counter;
reg					snap_counting_state;
reg					next_snap_counting_state;
parameter			SNAP_COUNT = 0;
parameter			SNAP_IDLE = 1;
wire				screen_shot;
//	continue_15_frames
wire				change;

assign				screen_shot = (snap_counter==32'd100_000_000)? 0 : 1 ;

assign pic_rst = KEY[0]&b_reset;
//======combinational========//
always @(*)begin
	/////////////////////// mode control ///////////////////////
	if (change_mode[0] && change) //normal
		next_change_mode[0] = 0;
	else if ((~change_mode[0])&&(~b_change_mode)&&~(pic_num == 0)) //display
		next_change_mode[0] = 1;
	else
		next_change_mode[0] = change_mode[0];	
	
	if (~change_mode[1] && ~b_control) //button interface
		next_change_mode[1] = 1;
	else if (change_mode[1] && ~b_control_back)	 //normal
		next_change_mode[1] = 0;		
	else
		next_change_mode[1] = change_mode[1];
		
	/////////////////////// write mode control ///////////////////////
	if (~b_control)
		next_write_mode = 0;
	else 
		if ({pre_write,write} == 2'b10)
			next_write_mode = ~write_mode;
		else
			next_write_mode = write_mode;
			
	/////////////////////// screen shot delay ///////////////////////		
	case(snap_counting_state)
		SNAP_COUNT: begin
						if(snap_counter==32'd100_000_000) 
							next_snap_counting_state = SNAP_IDLE;
						else 
							next_snap_counting_state = snap_counting_state;
					end
		SNAP_IDLE:	begin
						if(~b_screen_shot)
							next_snap_counting_state = SNAP_COUNT;
						else 
							next_snap_counting_state = snap_counting_state;
					end
	endcase
	
	if(~b_screen_shot)
		next_snap_counter = 0;
	else if(snap_counting_state==SNAP_COUNT) 
		next_snap_counter = snap_counter + 1;
	else //snap_counting_state==SNAP_IDLE
		next_snap_counter = 0;
	
	if ({pre_Frame_wdone,Frame_wdone}==2'b10) 
		if(press_KEY3)
			next_delay_KEY3 = 0;
		else
			next_delay_KEY3 = 1;
	else 
		next_delay_KEY3 = 1;
	
	if ({pre_Frame_rdone,Frame_rdone}==2'b10) begin
		next_delay_SW3 = change_mode[0];
		if(SW3hasChange)
			next_ChangeSW3 = 1;
		else
			next_ChangeSW3 = 0;
		if(AddrhasChange)
			next_ChangeAddr = 1;
		else
			next_ChangeAddr = 0;
	end	
	else begin
		next_delay_SW3 = delay_SW3;
		next_ChangeSW3 = 0;
		next_ChangeAddr = 0;
	end
	
	offset_num = change_mode[0] ? display_num : pic_num;
	
	if(!change_mode[0]) begin
		if(change_mode[1]&&({pre_KEY3,screen_shot}==2'b10)&&(pic_num!=4'b0111)) begin
			next_pic_num = pic_num + 1;
			next_press_KEY3 = 1;
		end
		else begin
			next_pic_num = pic_num;
			if (press_KEY3 == 1&&({pre_Frame_wdone,Frame_wdone}!=2'b10))
				next_press_KEY3 = 1;
			else
				next_press_KEY3 = 0;
		end
	end
	else begin
		next_press_KEY3 = 0;
		next_pic_num = pic_num;
	end
	
	if(pre_SW3^change_mode[0]) 
		next_SW3hasChange = 1;
	else 
		if(SW3hasChange == 1&&({pre_Frame_rdone,Frame_rdone}!=2'b10))
			next_SW3hasChange = 1;
		else
			next_SW3hasChange = 0;
	
	if(event_add||event_sub) 
		next_AddrhasChange = 1;
	else 
		if(AddrhasChange == 1&&({pre_Frame_rdone,Frame_rdone}!=2'b10))
			next_AddrhasChange = 1;
		else
			next_AddrhasChange = 0;
	
	/////////////////////// display mode: picture add or sub ///////////////////////
	event_add = vga_add&change_mode[0]/*||({pre_KEY1,KEY[1]}==2'b10)*/;
	event_sub = vga_sub&change_mode[0]/*||({pre_KEY2,KEY[2]}==2'b10)*/;
	casex({event_add,event_sub})
		2'b1x:	begin
					if (display_num == pic_num - 1)
						next_display_num = 0;
					else
						next_display_num = display_num + 1;
				end
		2'b01:	begin
					if (display_num == 0)
						next_display_num = pic_num - 1;
					else
						next_display_num = display_num - 1;
				end
		default:		next_display_num = display_num;
	endcase
	
end

//======sequential===========//
always @(posedge CLOCK2_50 or negedge pic_rst)begin
	if(!pic_rst) begin
		pic_num <= 0;
		display_num <= 0;
//		pre_KEY1 <= 0;
//		pre_KEY2 <= 0;
		pre_KEY3 <= 0;
		pre_SW3 <= 0;
		pre_Frame_wdone <= 0;
		pre_Frame_rdone <= 0;
		delay_KEY3 <= 0;
		press_KEY3 <= 0;
		delay_SW3 <= 0;
		ChangeAddr <= 0;
		ChangeSW3 <= 0;
		SW3hasChange <= 0;
		AddrhasChange <= 0;
		change_mode	<= 0;
		write_mode <= 0;
		pre_write <= 1;
		varied_color <= 0;
		snap_counter <= 0;
		snap_counting_state <= SNAP_IDLE;
	end
	else begin
		pic_num <= next_pic_num;
		display_num <= next_display_num;
//		pre_KEY1 <= KEY[1];
//		pre_KEY2 <= KEY[2];
		pre_KEY3 <= screen_shot;
		pre_SW3 <= change_mode[0];
		pre_Frame_wdone <= Frame_wdone;
		pre_Frame_rdone <= Frame_rdone;
		delay_KEY3 <= next_delay_KEY3;
		press_KEY3 <= next_press_KEY3;
		delay_SW3 <= next_delay_SW3;
		ChangeAddr <= next_ChangeAddr;
		ChangeSW3 <= next_ChangeSW3;
		SW3hasChange <= next_SW3hasChange;
		AddrhasChange <= next_AddrhasChange;
		change_mode <= next_change_mode;
		write_mode <= next_write_mode;
		pre_write <= write;
		varied_color <= next_varied_color;
		snap_counter <= next_snap_counter;
		snap_counting_state <= next_snap_counting_state;
	end

end

endmodule
