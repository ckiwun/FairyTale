
module	VGA_Controller(	//	Host Side
						iRed,
						iGreen,
						iBlue,
						iIsSkin,
						iIsGreen,
						idetectSkin,
						idetectBlack,
						oRequest,
						//	VGA Side
						oVGA_R,
						oVGA_G,
						oVGA_B,
						oVGA_H_SYNC,
						oVGA_V_SYNC,
						oVGA_SYNC,
						oVGA_BLANK,

						//	Control Signal
						iCLK,
						iRST_N,
						iZOOM_MODE_SW,
						change_mode,
						write_mode,

						//	Finger Patch Detection
						o_isFinger,
						KEY,
						is_finished,
						
						//	Wave hand detection
						add,
						sub,
						
						//lum & sat
						lum,
						sat,
						
						//skin_signal
						skin_signal,
						
						//different color
						varied_color,
						shimmer,
						display_num,
						pic_num,
						//interface
						local_addr,
						icon_number,
						interface_R,
						interface_G,
						interface_B
						);
`include "VGA_Param.h"

`ifdef VGA_640x480p60
//	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	96;
parameter	H_SYNC_BACK	=	48;
parameter	H_SYNC_ACT	=	640;	
parameter	H_SYNC_FRONT=	16;
parameter	H_SYNC_TOTAL=	800;

//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	2;
parameter	V_SYNC_BACK	=	33;
parameter	V_SYNC_ACT	=	480;	
parameter	V_SYNC_FRONT=	10;
parameter	V_SYNC_TOTAL=	525; 

`else
 // SVGA_800x600p60
////	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	128;         //Peli
parameter	H_SYNC_BACK	=	88;
parameter	H_SYNC_ACT	=	800;	
parameter	H_SYNC_FRONT=	40;
parameter	H_SYNC_TOTAL=	1056;
//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	4;
parameter	V_SYNC_BACK	=	23;
parameter	V_SYNC_ACT	=	600;	
parameter	V_SYNC_FRONT=	1;
parameter	V_SYNC_TOTAL=	628;

`endif
//	Start Offset
parameter	X_START		=	H_SYNC_CYC+H_SYNC_BACK;
parameter	Y_START		=	V_SYNC_CYC+V_SYNC_BACK;

// wave hand FSM
parameter	Idle		=	0;
parameter	R1			=	1;
parameter	R2			=	2;
parameter	R3			=	3;
parameter	TurnRight	=	4;
parameter	L1			=	5;
parameter	L2			=	6;
parameter	L3			=	7;
parameter	TurnLeft	=	8;
parameter	U1			=	9;
parameter	U2			=	10;
parameter	U3			=	11;
parameter	Change		=	12;

//	Host Side
input			[9:0]	iRed, iGreen, iBlue;

//
input					iIsSkin, iIsGreen;
input			[8:0]	idetectSkin;
input			[8:0]	idetectBlack;
//input			[1:0]

//state signals
input			[3:0]	lum, sat;

output	reg				oRequest;
//	VGA Side
output	reg		[9:0]	oVGA_R;
output	reg		[9:0]	oVGA_G;
output	reg		[9:0]	oVGA_B;
output	reg				oVGA_H_SYNC;
output	reg				oVGA_V_SYNC;
output	reg				oVGA_SYNC;
output	reg				oVGA_BLANK;

reg				[9:0]	mVGA_R;
reg				[9:0]	mVGA_G;
reg				[9:0]	mVGA_B;
reg						mVGA_H_SYNC;
reg						mVGA_V_SYNC;
wire					mVGA_SYNC;
wire					mVGA_BLANK;

//	Control Signal
input					iCLK;
input					iRST_N;
input 					iZOOM_MODE_SW;
input			[1:0]		change_mode;
reg				[9:0]	coorX, coorY;
reg				[6:0]	icon_X, icon_Y;
reg				[4:0]	patch_coorX, patch_coorY;
reg				[19:0]	counter, next_counter;

//	Internal Registers and Wires
reg				[12:0]	H_Cont;
reg				[12:0]	V_Cont;
wire			[12:0]	v_mask;
assign v_mask = 13'd0 ;//iZOOM_MODE_SW ? 13'd0 : 13'd26;

//	wave hand detection
reg				[2:0]	VPisSkin;
reg				[2:0]	next_VPisSkin;
reg				[3:0]	wavestate1, next_wavestate1;
reg				[3:0]	wavestate2,	next_wavestate2;
reg						resetWH;
output	reg				add;
output	reg				sub;

// write mode 
input 					write_mode;


//	Finger Patch Detection	//
output reg		[47:0]	o_isFinger;
reg				[47:0] 	pre_isFinger;
output reg				is_finished;
reg 					pre_is_finished;
reg						next_is_finished;
reg				[47:0] 	tmp_isFinger, next_tmp_isFinger;
integer					iteration;
reg				[3:0] 	count_for_15, pre_count_for_15;
reg				[47:0]	alternate_isFinger, pre_alternate_isFinger;
reg				[8:0]	alternate_isSkin, pre_alternate_isSkin;
reg 					alternate_skin_signal, pre_alternate_skin_signal;			

output reg				skin_signal;
output reg				KEY;
reg 					next_KEY;


//	different color //
input	[1:0]	varied_color;
input			shimmer;

// display num
input	[3:0]	display_num;
input	[3:0]	pic_num;

// interface
output 	reg	[12:0]	local_addr;
output	reg	[3:0]	icon_number;
input		[7:0]	interface_R;
input		[7:0]	interface_G;
input		[7:0]	interface_B;

////////////////////////////////////////////////////////
assign	mVGA_BLANK	=	mVGA_H_SYNC & mVGA_V_SYNC;
assign	mVGA_SYNC	=	1'b0;
			
always@(posedge iCLK or negedge iRST_N)
	begin
		if (!iRST_N)
			begin
				oVGA_R <= 0;
				oVGA_G <= 0;
                oVGA_B <= 0;
				oVGA_BLANK <= 0;
				oVGA_SYNC <= 0;
				oVGA_H_SYNC <= 0;
				oVGA_V_SYNC <= 0; 
			end
		else
			begin
				oVGA_R <= mVGA_R;
				oVGA_G <= mVGA_G;
                oVGA_B <= mVGA_B;
				oVGA_BLANK <= mVGA_BLANK;
				oVGA_SYNC <= mVGA_SYNC;
				oVGA_H_SYNC <= mVGA_H_SYNC;
				oVGA_V_SYNC <= mVGA_V_SYNC;				
			end               
	end

//	Pixel LUT Address Generator
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	oRequest	<=	0;
	else
	begin
		if(	H_Cont>=X_START-2 && H_Cont<X_START+H_SYNC_ACT-2 &&
			V_Cont>=Y_START && V_Cont<Y_START+V_SYNC_ACT )
		oRequest	<=	1;
		else
		oRequest	<=	0;
	end
end

//	H_Sync Generator, Ref. 40 MHz Clock
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		H_Cont		<=	0;
		mVGA_H_SYNC	<=	0;
	end
	else
	begin
		//	H_Sync Counter
		if( H_Cont < H_SYNC_TOTAL )
		H_Cont	<=	H_Cont+1;
		else
		H_Cont	<=	0;
		//	H_Sync Generator
		if( H_Cont < H_SYNC_CYC )
		mVGA_H_SYNC	<=	0;
		else
		mVGA_H_SYNC	<=	1;
	end
end

//	V_Sync Generator, Ref. H_Sync
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		V_Cont		<=	0;
		mVGA_V_SYNC	<=	0;
	end
	else
	begin
		//	When H_Sync Re-start
		if(H_Cont==0)
		begin
			//	V_Sync Counter
			if( V_Cont < V_SYNC_TOTAL )
			V_Cont	<=	V_Cont+1;
			else
			V_Cont	<=	0;
			//	V_Sync Generator
			if(	V_Cont < V_SYNC_CYC )
			mVGA_V_SYNC	<=	0;
			else
			mVGA_V_SYNC	<=	1;
		end
	end
end

always @(*)	begin
		resetWH = add | sub /*| ch*/;
		//	wave hand detection
		VPisSkin[0] = idetectSkin[6]|idetectSkin[7]|idetectSkin[8]; //left
		VPisSkin[1] = idetectSkin[3]|idetectSkin[4]|idetectSkin[5]; //middle
		VPisSkin[2] = idetectSkin[0]|idetectSkin[1]|idetectSkin[2]; //right
		
		case(wavestate1)
			Idle:		begin
							add = 0;
							casex({VPisSkin,resetWH})
								4'b0010:	next_wavestate1 = R1;
								//4'b0100:	next_wavestate1 = R2;
								4'bxxx1:	next_wavestate1 = Idle;
								default:	next_wavestate1 = wavestate1;
							endcase
						end
			R1:			begin
							add = 0;
							casex({VPisSkin,resetWH})
								4'b01x0:	next_wavestate1 = R2;
								4'bxxx1:	next_wavestate1 = Idle;
								default:	next_wavestate1 = wavestate1;
							endcase
						end
			R2:			begin
							add = 0;
							casex({VPisSkin,resetWH})
								4'b1xx0:	next_wavestate1 = R3;
								4'bxxx1:	next_wavestate1 = Idle;
								default:	next_wavestate1 = wavestate1;
							endcase
						end
			R3:			begin
							add = 0;
							casex({VPisSkin,resetWH})
								4'b0000:	next_wavestate1 = TurnRight;
								4'bxxx1:	next_wavestate1 = Idle;
								default:	next_wavestate1 = wavestate1;
							endcase
						end
			TurnRight:	begin
							add = 1;
							casex({VPisSkin,resetWH})
								default:next_wavestate1 = Idle;
							endcase
						end
		endcase
		
		case(wavestate2)
			Idle:		begin
							sub = 0;
							casex({VPisSkin,resetWH})
								4'b1000:	next_wavestate2 = L1;
								//4'b0100:	next_wavestate2 = L2;
								4'bxxx1:	next_wavestate2 = Idle;
								default:	next_wavestate2 = wavestate2;
							endcase
						end
			L1:			begin
							sub = 0;
							casex({VPisSkin,resetWH})
								4'bx100:	next_wavestate2 = L2;
								4'bxxx1:	next_wavestate2 = Idle;
								default:	next_wavestate2 = wavestate2;
							endcase
						end
			L2:			begin
							sub = 0;
							casex({VPisSkin,resetWH})
								4'bxx10:	next_wavestate2 = L3;
								4'bxxx1:	next_wavestate2 = Idle;
								default:	next_wavestate2 = wavestate2;
							endcase
						end
			L3:			begin
							sub = 0;
							casex({VPisSkin,resetWH})
								4'b0000:	next_wavestate2 = TurnLeft;
								4'bxxx1:	next_wavestate2 = Idle;
								default:	next_wavestate2 = wavestate2;
							endcase
						end
			TurnLeft:	begin
							sub = 1;
							casex({VPisSkin,resetWH})
								default:next_wavestate2 = Idle;
							endcase
						end
		endcase
		
	//coordinate	
		coorX = counter % 800;
		patch_coorX = coorX / 100;
		coorY = counter / 800;
		patch_coorY = coorY / 100;
		
		icon_X = coorX - patch_coorX*100 - 9;
		icon_Y = coorY - patch_coorY*100 - 10;
		
		local_addr = icon_Y + icon_X*80;
		
		if((H_Cont == X_START-2)&(V_Cont == Y_START+v_mask))
			next_counter = 0;
		else begin
			if(H_Cont>=X_START-2 && H_Cont<X_START+H_SYNC_ACT-2 &&
				V_Cont>=Y_START && V_Cont<Y_START+V_SYNC_ACT)
				next_counter = counter + 1;
			else
				next_counter = counter;
		end
	//interface
		if (coorX[0]^coorY[0]) begin	
		
		if (change_mode[1] == 0) begin
			// toolbox open
			if ((coorX < 790)&&(coorX > 710)&&(coorY < 90)&&(coorY > 10)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 5;
				mVGA_R[9:2] = interface_R;
				mVGA_G[9:2] = interface_G; 
				mVGA_B[9:2] = interface_B;
			end		
			else begin
				mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
								V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
								?	iRed	:	0;
				mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
								V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
								?	iGreen	:	0;
				mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
								V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
								?	iBlue	:	0;					
			end
		end
		// toolbox close
		else if (change_mode == 2'b10) begin
			if ((coorX < 690)&&(coorX > 610)&&(coorY < 90)&&(coorY > 10)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 4;
				mVGA_R[9:2] = interface_R;
			    mVGA_G[9:2] = interface_G; 
			    mVGA_B[9:2] = interface_B;
			end		
			//sat +
			else if ((coorX < 690)&&(coorX > 610)&&(coorY < 490)&&(coorY > 410)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 8;
				mVGA_R[9:2] = interface_R;
				mVGA_G[9:2] = interface_G;
				mVGA_B[9:2] = interface_B;
			end
			//sat -
			else if ((coorX < 690)&&(coorX > 610)&&(coorY < 590)&&(coorY > 510)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 11;
				mVGA_R[9:2] = interface_R;
				mVGA_G[9:2] = interface_G;
				mVGA_B[9:2] = interface_B;
			end
			//lum +
			else if ((coorX < 790)&&(coorX > 710)&&(coorY < 490)&&(coorY > 410)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 9;
				mVGA_R[9:2] = interface_R;
				mVGA_G[9:2] = interface_G;
				mVGA_B[9:2] = interface_B;
			end
			//lum -
			else if ((coorX < 790)&&(coorX > 710)&&(coorY < 590)&&(coorY > 510)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 12;
				mVGA_R[9:2] = interface_R;
				mVGA_G[9:2] = interface_G;
				mVGA_B[9:2] = interface_B;
			end
			// camera
			else if ((coorX < 90)&&(coorX > 10)&&(coorY < 590)&&(coorY > 510)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 10;
				if (shimmer) begin
					if (interface_B == 0) begin
						mVGA_R[9:2] = interface_R;
					    mVGA_G[9:2] = interface_G;
					    mVGA_B[9:2] = interface_B;
					end
					else begin
						mVGA_R[9:2] = (interface_R + 50 > 255) ? 255 : interface_R + 50;
						mVGA_G[9:2] = (interface_G + 50 > 255) ? 255 : interface_G + 50;
						mVGA_B[9:2] = (interface_B + 50 > 255) ? 255 : interface_B + 50;
					end
				end
				else begin
					mVGA_R[9:2] = interface_R;
					mVGA_G[9:2] = interface_G; 
					mVGA_B[9:2] = interface_B;
				end
			end
			// display mode on
			else if ((coorX < 90)&&(coorX > 10)&&(coorY < 90)&&(coorY > 10)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 0;
				mVGA_R[9:2] = interface_R;
				mVGA_G[9:2] = interface_G; 
				mVGA_B[9:2] = interface_B;
			end
			//pic num indicator
			else if(coorX + 20<200&&coorX + 20>100&&coorY + 20<100) begin
				case(pic_num)
					1:	begin
							if(coorX + 20<135&&coorX + 20>131&&coorY + 20<93&&coorY + 20>58
								) begin
								mVGA_R 	= 10'h3ff;
								mVGA_G 	= 10'h3ff;
								mVGA_B 	= 10'h3ff;
							end
							else begin
								mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iRed	:	0;
								mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iGreen	:	0;
								mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iBlue	:	0;
							end
						end
					2:	begin
							if(coorX + 20<135&&coorX + 20>131&&coorY + 20<74&&coorY + 20>58 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<58&&coorY + 20>54 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<77&&coorY + 20>74 ||
								coorX + 20<119&&coorX + 20>116&&coorY + 20<93&&coorY + 20>77 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<97&&coorY + 20>93
							) begin
								mVGA_R 	= 10'h3ff;
								mVGA_G 	= 10'h3ff;
								mVGA_B 	= 10'h3ff;
							end
							else begin
								mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iRed	:	0;
								mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iGreen	:	0;
								mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iBlue	:	0;
							end
						end
					3:	begin
							if(coorX + 20<135&&coorX + 20>131&&coorY + 20<74&&coorY + 20>58 ||
								coorX + 20<135&&coorX + 20>131&&coorY + 20<93&&coorY + 20>77 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<58&&coorY + 20>54 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<77&&coorY + 20>74 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<97&&coorY + 20>93
							) begin
								mVGA_R 	= 10'h3ff;
								mVGA_G 	= 10'h3ff;
								mVGA_B 	= 10'h3ff;
							end
							else begin
								mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iRed	:	0;
								mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iGreen	:	0;
								mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iBlue	:	0;
							end
						end
					4:	begin
							if(coorX + 20<135&&coorX + 20>131&&coorY + 20<74&&coorY + 20>58 ||
								coorX + 20<135&&coorX + 20>131&&coorY + 20<93&&coorY + 20>77 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<77&&coorY + 20>74 ||
								coorX + 20<119&&coorX + 20>116&&coorY + 20<74&&coorY + 20>58
							) begin
								mVGA_R 	= 10'h3ff;
								mVGA_G 	= 10'h3ff;
								mVGA_B 	= 10'h3ff;
							end
							else begin
								mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iRed	:	0;
								mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iGreen	:	0;
								mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iBlue	:	0;
							end
						end
					5:	begin
							if(coorX + 20<135&&coorX + 20>131&&coorY + 20<93&&coorY + 20>77 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<58&&coorY + 20>54 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<77&&coorY + 20>74 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<97&&coorY + 20>93 ||
								coorX + 20<119&&coorX + 20>116&&coorY + 20<74&&coorY + 20>58
							) begin
								mVGA_R 	= 10'h3ff;
								mVGA_G 	= 10'h3ff;
								mVGA_B 	= 10'h3ff;
							end
							else begin
								mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iRed	:	0;
								mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iGreen	:	0;
								mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iBlue	:	0;
							end
						end
					6:	begin
							if(coorX + 20<135&&coorX + 20>131&&coorY + 20<93&&coorY + 20>77 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<58&&coorY + 20>54 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<77&&coorY + 20>74 ||
								coorX + 20<119&&coorX + 20>116&&coorY + 20<93&&coorY + 20>77 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<97&&coorY + 20>93 ||
								coorX + 20<119&&coorX + 20>116&&coorY + 20<74&&coorY + 20>58
							) begin
								mVGA_R 	= 10'h3ff;
								mVGA_G 	= 10'h3ff;
								mVGA_B 	= 10'h3ff;
							end
							else begin
								mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iRed	:	0;
								mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iGreen	:	0;
								mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iBlue	:	0;
							end
						end
					7:	begin
							if(coorX + 20<135&&coorX + 20>131&&coorY + 20<74&&coorY + 20>58 ||
								coorX + 20<135&&coorX + 20>131&&coorY + 20<93&&coorY + 20>77 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<58&&coorY + 20>54 ||
								coorX + 20<119&&coorX + 20>116&&coorY + 20<74&&coorY + 20>58
							) begin
								mVGA_R 	= 10'h3ff;
								mVGA_G 	= 10'h3ff;
								mVGA_B 	= 10'h3ff;
							end
							else begin
								mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iRed	:	0;
								mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iGreen	:	0;
								mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iBlue	:	0;
							end
						end
					0:	begin
							if(coorX + 20<135&&coorX + 20>131&&coorY + 20<74&&coorY + 20>58 ||
								coorX + 20<135&&coorX + 20>131&&coorY + 20<93&&coorY + 20>77 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<58&&coorY + 20>54 ||
								coorX + 20<119&&coorX + 20>116&&coorY + 20<74&&coorY + 20>58 ||
								coorX + 20<119&&coorX + 20>116&&coorY + 20<93&&coorY + 20>77 ||
								coorX + 20<133&&coorX + 20>117&&coorY + 20<97&&coorY + 20>93
							) begin
								mVGA_R 	= 10'h3ff;
								mVGA_G 	= 10'h3ff;
								mVGA_B 	= 10'h3ff;
							end
							else begin
								mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iRed	:	0;
								mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iGreen	:	0;
								mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iBlue	:	0;
							end
						end
					default: begin
								mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iRed	:	0;
								mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iGreen	:	0;
								mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
												V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
												?	iBlue	:	0;
							end
				endcase
			end
			//lum indicator
			else if ((coorX < 770)&&(coorX > 740)&&(coorY < 400)&&(coorY > 155)) begin
				if ((coorY < 400 - lum*15)&&(coorY > 380 - lum*15)) begin 
					mVGA_R 	= 10'd920;
					mVGA_G 	= 10'd800;
					mVGA_B 	= 10'd400;
				end
				else begin
					mVGA_R 	= 10'd512;
					mVGA_G 	= 10'd512;
					mVGA_B 	= 10'd512;
				end
			end
			//sat indicator
			else if ((coorX < 670)&&(coorX > 640)&&(coorY < 400)&&(coorY > 155)) begin
				if ((coorY < 400 - sat*15)&&(coorY > 380 - sat*15)) begin 
					mVGA_R 	= 10'd40;
					mVGA_G 	= 10'd400;
					mVGA_B 	= 10'd900;
				end
				else begin
					mVGA_R 	= 10'd512;
					mVGA_G 	= 10'd512;
					mVGA_B 	= 10'd512;
				end
			end
			// write mode on
			else if (~write_mode && (((coorX - 50)*(coorX - 50) + (coorY - 450)*(coorY - 450)) <= 1225)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 7;
				mVGA_R[9:2] = interface_R;
				mVGA_G[9:2] = interface_G;
				mVGA_B[9:2] = interface_B;
			end	
			// pen red
			else if (write_mode && (((coorX - 250)*(coorX - 250) + (coorY - 50)*(coorY - 50)) <= 1225)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 1;
				mVGA_R[9:2] = interface_R;
				mVGA_G[9:2] = interface_G;
				mVGA_B[9:2] = interface_B;
			end		
			// pen yellow
			else if (write_mode && (((coorX - 350)*(coorX - 350) + (coorY - 50)*(coorY - 50)) <= 1225)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 2;
				mVGA_R[9:2] = interface_R;
				mVGA_G[9:2] = interface_G;
				mVGA_B[9:2] = interface_B;
			end	
			// pen blue
			else if (write_mode && (((coorX - 450)*(coorX - 450) + (coorY - 50)*(coorY - 50)) <= 1225)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 3;
				mVGA_R[9:2] = interface_R;
				mVGA_G[9:2] = interface_G;
				mVGA_B[9:2] = interface_B;
			end	
			// write mode off
			else if (write_mode && (((coorX - 50)*(coorX - 50) + (coorY - 350)*(coorY - 350)) <= 1225)/*&&~(coorX%50 == 0)&&~(coorY%50 == 0)*/) begin
				icon_number = 6;
				mVGA_R[9:2] = interface_R;
				mVGA_G[9:2] = interface_G;
				mVGA_B[9:2] = interface_B;
			end	
			// write frame
			else if (write_mode&&(coorX < 600)&&(coorX > 200)&&(coorY < 580)&&(coorY > 380)) begin
				if ((coorX > 598)||(coorX < 202)||(coorY > 578)||(coorY < 382)) begin
					if	(varied_color == 2'b00) begin //red
						mVGA_R 	= 10'h3ff;
						mVGA_G 	= 10'd0;
						mVGA_B 	= 10'd0;
					end
					else if (varied_color == 2'b01) begin // yellow
						mVGA_R 	= 10'h3ff;
						mVGA_G 	= 10'h3ff;
						mVGA_B 	= 10'd0;
					end
					else if (varied_color == 2'b10) begin //blue
						mVGA_R 	= 10'd0;
						mVGA_G 	= 10'd0;
						mVGA_B 	= 10'h3ff;
					end
					else	begin
						mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
										V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
										?	iRed	:	0;
						mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
										V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
										?	iGreen	:	0;
						mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
										V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
										?	iBlue	:	0;
					end
				end
				else begin
					mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
									V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
									?	iRed	:	0;
					mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
									V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
									?	iGreen	:	0;
					mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
				    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
				    				?	iBlue	:	0;
				end		
			end	
			else begin
				if (o_isFinger[patch_coorY*8 + patch_coorX]) begin
					if ((coorX - patch_coorX*100 - 50)*(coorX - patch_coorX*100 - 50) + (coorY - patch_coorY*100 - 50)*(coorY - patch_coorY*100 - 50) <= 800) begin
					mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
									V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT ) ?
									((iRed + 250 < 1023) ? iRed + 250 : 10'd1023 ) : 0;
					mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
									V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT ) ?
									((iGreen + 250 < 1023) ? iGreen + 250 : 10'd1023) : 0;
					mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
									V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT ) ?
									((iBlue + 250 < 1023) ? iBlue + 250 : 10'd1023 ):	0;
					end
					else if ((coorX - patch_coorX*100 - 50)*(coorX - patch_coorX*100 - 50) + (coorY - patch_coorY*100 - 50)*(coorY - patch_coorY*100 - 50) <= 2000) begin
				    mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
				    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT ) ?
				    				((iRed + 150 < 1023) ? iRed + 150 : 10'd1023  ) : 0;
				    mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
				    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT ) ?
				    				((iGreen + 150 < 1023) ? iGreen + 150 : 10'd1023 ) : 0;
				    mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
				    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT ) ?
				    				((iBlue + 150 < 1023) ? iBlue + 150 : 10'd1023  ):	0;
				    end
					else begin
					mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
									V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT ) ?
									((iRed + 50 < 1023) ? iRed + 50 : 10'd1023  ) : 0;
				    mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
				    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT ) ?
				    				((iGreen + 50 < 1023) ? iGreen + 50 : 10'd1023 ) : 0;
				    mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
				    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT ) ?
				    				((iBlue + 50 < 1023) ? iBlue + 50 : 10'd1023  ):	0;
				    end
				end
				else begin
					mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
				    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
				    				?	iRed	:	0;
				    mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
				    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
				    				?	iGreen	:	0;
				    mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
				    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
				    				?	iBlue	:	0;		
				end
			end							
		end
		else begin //display
			case(display_num)
				0:	begin
						if(coorX<769&&coorX>762&&coorY<587&&coorY>516
							) begin
							mVGA_R 	= 10'h3ff;
							mVGA_G 	= 10'd0;
							mVGA_B 	= 10'd0;
						end
						else begin
							mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iRed	:	0;
							mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iGreen	:	0;
							mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iBlue	:	0;
						end
					end
				1:	begin
						if(coorX<769&&coorX>762&&coorY<548&&coorY>516 ||
							coorX<766&&coorX>734&&coorY<516&&coorY>509 ||
							coorX<766&&coorX>734&&coorY<555&&coorY>548 ||
							coorX<738&&coorX>731&&coorY<587&&coorY>555 ||
							coorX<766&&coorX>734&&coorY<594&&coorY>587
						) begin
							mVGA_R 	= 10'h3ff;
							mVGA_G 	= 10'd0;
							mVGA_B 	= 10'd0;
						end
						else begin
							mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iRed	:	0;
							mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iGreen	:	0;
							mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iBlue	:	0;
						end
					end
				2:	begin
						if(coorX<769&&coorX>762&&coorY<548&&coorY>516 ||
							coorX<769&&coorX>762&&coorY<587&&coorY>555 ||
							coorX<766&&coorX>734&&coorY<516&&coorY>509 ||
							coorX<766&&coorX>734&&coorY<555&&coorY>548 ||
							coorX<766&&coorX>734&&coorY<594&&coorY>587
						) begin
							mVGA_R 	= 10'h3ff;
							mVGA_G 	= 10'd0;
							mVGA_B 	= 10'd0;
						end
						else begin
							mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iRed	:	0;
							mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iGreen	:	0;
							mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iBlue	:	0;
						end
					end
				3:	begin
						if(coorX<769&&coorX>762&&coorY<548&&coorY>516 ||
							coorX<769&&coorX>762&&coorY<587&&coorY>555 ||
							coorX<766&&coorX>734&&coorY<555&&coorY>548 ||
							coorX<738&&coorX>731&&coorY<548&&coorY>516
						) begin
							mVGA_R 	= 10'h3ff;
							mVGA_G 	= 10'd0;
							mVGA_B 	= 10'd0;
						end
						else begin
							mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iRed	:	0;
							mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iGreen	:	0;
							mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iBlue	:	0;
						end
					end
				4:	begin
						if(coorX<769&&coorX>762&&coorY<587&&coorY>555 ||
							coorX<766&&coorX>734&&coorY<516&&coorY>509 ||
							coorX<766&&coorX>734&&coorY<555&&coorY>548 ||
							coorX<766&&coorX>734&&coorY<594&&coorY>587 ||
							coorX<738&&coorX>731&&coorY<548&&coorY>516
						) begin
							mVGA_R 	= 10'h3ff;
							mVGA_G 	= 10'd0;
							mVGA_B 	= 10'd0;
						end
						else begin
							mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iRed	:	0;
							mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iGreen	:	0;
							mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iBlue	:	0;
						end
					end
				5:	begin
						if(coorX<769&&coorX>762&&coorY<587&&coorY>555 ||
							coorX<766&&coorX>734&&coorY<516&&coorY>509 ||
							coorX<766&&coorX>734&&coorY<555&&coorY>548 ||
							coorX<738&&coorX>731&&coorY<587&&coorY>555 ||
							coorX<766&&coorX>734&&coorY<594&&coorY>587 ||
							coorX<738&&coorX>731&&coorY<548&&coorY>516
						) begin
							mVGA_R 	= 10'h3ff;
							mVGA_G 	= 10'd0;
							mVGA_B 	= 10'd0;
						end
						else begin
							mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iRed	:	0;
							mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iGreen	:	0;
							mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iBlue	:	0;
						end
					end
				6:	begin
						if(coorX<769&&coorX>762&&coorY<548&&coorY>516 ||
							coorX<769&&coorX>762&&coorY<587&&coorY>555 ||
							coorX<766&&coorX>734&&coorY<516&&coorY>509 ||
							coorX<738&&coorX>731&&coorY<548&&coorY>516
						) begin
							mVGA_R 	= 10'h3ff;
							mVGA_G 	= 10'd0;
							mVGA_B 	= 10'd0;
						end
						else begin
							mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iRed	:	0;
							mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iGreen	:	0;
							mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iBlue	:	0;
						end
					end
				7:	begin
						if(coorX<769&&coorX>762&&coorY<548&&coorY>516 ||
							coorX<769&&coorX>762&&coorY<587&&coorY>555 ||
							coorX<766&&coorX>734&&coorY<516&&coorY>509 ||
							coorX<738&&coorX>731&&coorY<548&&coorY>516 ||
							coorX<766&&coorX>734&&coorY<555&&coorY>548 ||
							coorX<738&&coorX>731&&coorY<587&&coorY>555 ||
							coorX<766&&coorX>734&&coorY<594&&coorY>587
						) begin
							mVGA_R 	= 10'h3ff;
							mVGA_G 	= 10'd0;
							mVGA_B 	= 10'd0;
						end
						else begin
							mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iRed	:	0;
							mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iGreen	:	0;
							mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iBlue	:	0;
						end
					end
				default: begin
							mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iRed	:	0;
							mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iGreen	:	0;
							mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
											V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
											?	iBlue	:	0;
						end
			endcase
		end
		end
		
		else begin
			mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
		    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
		    				?	iRed	:	0;
		    mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
		    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
		    				?	iGreen	:	0;
		    mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
		    				V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
		    				?	iBlue	:	0;				
		end
		
		//48 patch finger detect
		if ((coorX == 0) && (coorY == 0) ) 
			next_tmp_isFinger = 48'hffffffffffff;
		else  if ((coorX%100!=0)&&(coorY%100!=0)&&(coorX%50==0)&&(coorY%50==0)) begin
			for (iteration = 0; iteration < 48; iteration = iteration +1) begin
				if (iteration == patch_coorY*8 + patch_coorX)
					next_tmp_isFinger[iteration] = tmp_isFinger[iteration] & iIsGreen;
				else
					next_tmp_isFinger[iteration] = tmp_isFinger[iteration];
			end
		end
		else
			next_tmp_isFinger = tmp_isFinger;

		if ({pre_is_finished,is_finished} == 2'b01) begin 
			if (pre_count_for_15 == 15) begin
				alternate_isFinger = 48'hffffffffffff;
				alternate_isSkin = 9'b111111111;
				count_for_15 = 0;
				o_isFinger = pre_alternate_isFinger;
				alternate_skin_signal = 1;
				skin_signal = pre_alternate_skin_signal;
			end
			else begin
				alternate_isFinger = pre_alternate_isFinger & tmp_isFinger;
				alternate_isSkin = pre_alternate_isSkin & idetectBlack;
				count_for_15 = pre_count_for_15 + 1;
				o_isFinger = pre_isFinger;
				if(pre_alternate_isSkin[0] + pre_alternate_isSkin[1] +  pre_alternate_isSkin[2] + pre_alternate_isSkin[3] +  pre_alternate_isSkin[4] + pre_alternate_isSkin[5] +  pre_alternate_isSkin[6] + pre_alternate_isSkin[7] +  pre_alternate_isSkin[8] < 6)
					alternate_skin_signal = 0;
				else
					alternate_skin_signal = pre_alternate_skin_signal;
				skin_signal = 0;
			end
		end
		else begin 
			alternate_isFinger = pre_alternate_isFinger;
			alternate_isSkin = pre_alternate_isSkin;
			count_for_15 = pre_count_for_15;
			o_isFinger = pre_isFinger;
			alternate_skin_signal = pre_alternate_skin_signal;
			skin_signal = 0;
		end
		
		//frame finish signal
		if ((coorX==799)&&(coorY==599)) 
			next_is_finished = 1;
		else if ((coorX==0)&&(coorY==0))
			next_is_finished = 0;
		else 
			next_is_finished = is_finished;

		//generate fake KEY signal
		if (({pre_is_finished,is_finished} == 2'b01) && (pre_count_for_15 == 4'd15)) 
			next_KEY = 0;
		else
			next_KEY = 1;
end

// counter and coordinate (X,Y)
always@(posedge iCLK or negedge iRST_N)
begin
		if(!iRST_N) begin
			counter <= 0;
			is_finished <= 0;
			pre_is_finished <= 0;
			pre_isFinger <= 48'hffffffffffff;
			pre_alternate_skin_signal <= 1;
			pre_alternate_isFinger <= 48'hffffffffffff;
			pre_alternate_isSkin <= 9'b111111111;
			tmp_isFinger <= 48'hffffffffffff;
			pre_count_for_15 <= 0;
			wavestate1	<=	Idle;
			wavestate2	<=	Idle;
			KEY <= 1;
		end
		else begin
			counter <= next_counter;
			is_finished <= next_is_finished;
			pre_is_finished <= is_finished;
			pre_isFinger <= o_isFinger;
			pre_alternate_skin_signal <= alternate_skin_signal;
			pre_alternate_isFinger <= alternate_isFinger;
			pre_alternate_isSkin <= alternate_isSkin;
			tmp_isFinger <= next_tmp_isFinger;
			pre_count_for_15 <= count_for_15;
			wavestate1	<=	next_wavestate1;
			wavestate2	<=	next_wavestate2;
			KEY <= next_KEY;
		end

end

endmodule

