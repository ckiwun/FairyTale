
`include "VGA_Param.h"
`ifdef VGA_640x480p60
module RAW2RGB(	oRed,
				oGreen,
				oBlue,
				oDVAL,
				iX_Cont,
				iY_Cont,
				iDATA,
				iDVAL,
				iCLK,
				iRST
				);

input	[10:0]	iX_Cont;
input	[10:0]	iY_Cont;
input	[11:0]	iDATA;
input			iDVAL;
input			iCLK;
input			iRST;
output	[11:0]	oRed;
output	[11:0]	oGreen;
output	[11:0]	oBlue;
output			oDVAL;
wire	[11:0]	mDATA_0;
wire	[11:0]	mDATA_1;
reg		[11:0]	mDATAd_0;
reg		[11:0]	mDATAd_1;
reg		[11:0]	mCCD_R;
reg		[12:0]	mCCD_G;
reg		[11:0]	mCCD_B;
reg				mDVAL;

assign	oRed	=	mCCD_R[11:0];
assign	oGreen	=	mCCD_G[12:1];
assign	oBlue	=	mCCD_B[11:0];
assign	oDVAL	=	mDVAL;




Line_Buffer1 	u0	(	.clken(iDVAL),
						.clock(iCLK),
						.shiftin(iDATA),
						.taps0x(mDATA_1),
						.taps1x(mDATA_0)	);

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		mCCD_R	<=	0;
		mCCD_G	<=	0;
		mCCD_B	<=	0;
		mDATAd_0<=	0;
		mDATAd_1<=	0;
		mDVAL	<=	0;
	end
	else
	begin
		mDATAd_0	<=	mDATA_0;
		mDATAd_1	<=	mDATA_1;
		mDVAL		<=	{iY_Cont[0]|iX_Cont[0]}	?	1'b0	:	iDVAL;
		if({iY_Cont[0],iX_Cont[0]}==2'b10)
		begin
			mCCD_R	<=	mDATA_0;
			mCCD_G	<=	mDATAd_0+mDATA_1;
			mCCD_B	<=	mDATAd_1;
		end	
		else if({iY_Cont[0],iX_Cont[0]}==2'b11)
		begin
			mCCD_R	<=	mDATAd_0;
			mCCD_G	<=	mDATA_0+mDATAd_1;
			mCCD_B	<=	mDATA_1;
		end
		else if({iY_Cont[0],iX_Cont[0]}==2'b00)
		begin
			mCCD_R	<=	mDATA_1;
			mCCD_G	<=	mDATA_0+mDATAd_1;
			mCCD_B	<=	mDATAd_0;
		end
		else if({iY_Cont[0],iX_Cont[0]}==2'b01)
		begin
			mCCD_R	<=	mDATAd_1;
			mCCD_G	<=	mDATAd_0+mDATA_1;
			mCCD_B	<=	mDATA_0;
		end
	end
end

endmodule
`else
module	RAW2RGB				(	iCLK,iRST_n,
								//Read Port 1
								iData,
								iDval,
								oRed,
								oGreen,
								oBlue,
								oDval,
								iZoom,
								iX_Cont,
								iY_Cont,
								write_mode,
								detectSkin,
								detectBlack,
								//different color
								varied_color,
								loose_detectSkin1,
								loose_detectSkin3,
								loose_detectSkin5,
								loose_detectSkin7
							);


input			iCLK,iRST_n;
input	[11:0]	iData;
input			iDval;
output	reg [11:0]	oRed;
output	reg [11:0]	oGreen;
output	reg [11:0]	oBlue;
output			oDval;
input	[1:0]	iZoom;
input	[15:0]	iX_Cont;
input	[15:0]	iY_Cont;
input	write_mode;

wire	[11:0]	wData0;
wire	[11:0]	wData1;
wire	[11:0]	wData2;

reg		[11:0]	rRed;
reg		[12:0]	rGreen;
reg		[11:0]	rBlue;
reg				rDval;
reg		[11:0]	wData0_d1,wData0_d2;
reg		[11:0]	wData1_d1,wData1_d2;
reg		[11:0]	wData2_d1,wData2_d2;

reg				oDval;

reg				dval_ctrl;
reg				dval_ctrl_en;
//out
parameter	size = 10;


parameter	patches = 400*200/(size*size);
parameter	bit_of_patches = 7;
//	smoother	handwrite


reg		[(patches-1):0]	o_handwrite;
reg		[(patches-1):0]	next_o_handwrite;
reg		[(patches-1):0]	process_handwrite;
reg		[(patches-1):0]	next_process_handwrite;

always @(posedge iCLK or negedge iRST_n) begin
	if (!iRST_n) begin	
		o_handwrite <= 0;
		process_handwrite <= 0;
	end
	else begin
		o_handwrite <= next_o_handwrite;
		process_handwrite <= next_process_handwrite;
	end
end


always @(*) begin

		
	if	(iX_Cont == 600 && iY_Cont == 280) 
		next_o_handwrite = process_handwrite;
	else  
		next_o_handwrite = o_handwrite;
	
	if	(iX_Cont > 200 && iX_Cont < 600 && iY_Cont > 80 && iY_Cont < 280 ) begin
		for (iteration = 0; iteration < patches ; iteration = iteration + 1) begin
			if ((iteration == (patch_X-200/size)+(patch_Y-80/size)*(400/size)) && iteration > (400/size) && iteration < (patches-1-(400/size)) && iteration%(400/size) != 0 && iteration%(400/size) != (400/size)-1) begin
				if	( 	final_handwrite[iteration-(400/size)-1] + final_handwrite[iteration-(400/size)] + final_handwrite[iteration-(400/size)+1]
						+ final_handwrite[iteration-1] + final_handwrite[iteration+1]
						+ final_handwrite[iteration+(400/size)-1] + final_handwrite[iteration+(400/size)] + final_handwrite[iteration+(400/size)+1] > 5)
					next_process_handwrite[iteration] = 1 /*process_handwrite[iteration]*/;
				else if ( final_handwrite[iteration-(400/size)-1] + final_handwrite[iteration-(400/size)] + final_handwrite[iteration-(400/size)+1]
						+ final_handwrite[iteration-1] + final_handwrite[iteration+1]
						+ final_handwrite[iteration+(400/size)-1] + final_handwrite[iteration+(400/size)] + final_handwrite[iteration+(400/size)+1] < 3)
					next_process_handwrite[iteration] = 0 /*process_handwrite[iteration]*/;
				else
					next_process_handwrite[iteration] = process_handwrite[iteration];
			end
			else
					next_process_handwrite[iteration] = process_handwrite[iteration];
		end
	end
	else 
		next_process_handwrite = process_handwrite;

end




reg		iIsGreen;
reg		[(patches-1):0]	tmp_handwrite ;
reg		[(patches-1):0]	next_tmp_handwrite;
reg		[(patches-1):0]	final_handwrite;
reg		[(patches-1):0] pre_final_handwrite;
integer iteration;
wire	[bit_of_patches:0]	patch_X;
wire	[bit_of_patches:0]	patch_Y;
assign	patch_X = iX_Cont / size;
assign	patch_Y = iY_Cont / size;


// different color //

input [1:0]	varied_color;



always @(*) begin
	if ((oGreen-oRed) > 12'd0 && ((oGreen-oRed) < 12'd600)&& oBlue < 12'd3000)
			iIsGreen = 1;
	else
			iIsGreen = 0;
			
	if(iX_Cont == 200 && iY_Cont == 380 ) begin
		final_handwrite = write_mode ? process_handwrite : {patches{1'b0}};
		next_tmp_handwrite = {patches{write_mode}};
	end
	else if(iX_Cont > 200 && iX_Cont < 600 && iY_Cont > 380 && iY_Cont < 580 && (iX_Cont%size > 3 && iX_Cont%size < 7 ) && (iY_Cont%size > 3 && iY_Cont%size < 7) ) begin
		for (iteration = 0; iteration < patches ; iteration = iteration + 1) begin
			if (iteration == (iX_Cont-200)/size+(iY_Cont-380)/size*(400/size) ) 
				next_tmp_handwrite[iteration] = tmp_handwrite[iteration] & iIsGreen;
			else 
				next_tmp_handwrite[iteration] = tmp_handwrite[iteration];
		end
		final_handwrite = pre_final_handwrite;
	end
	else if (iX_Cont == 799 && iY_Cont == 599 ) begin
		final_handwrite = /*(varied_color == 2'b11) ? (pre_final_handwrite & ~tmp_handwrite) : (*/pre_final_handwrite | tmp_handwrite/*)*/; 
		next_tmp_handwrite = tmp_handwrite;
	end
	else begin
		final_handwrite = pre_final_handwrite;
		next_tmp_handwrite = tmp_handwrite;
	end
end

//write writehand to screen
always @(*) begin
	if(iX_Cont > 200 && iX_Cont < 600 && iY_Cont > 380 && iY_Cont < 580) begin
			if (o_handwrite[(iX_Cont-200)/size+(iY_Cont-380)/size*(400/size)]) begin
				if	(varied_color == 2'b00) begin // red
					oRed = 		12'hfff;
					oGreen = 	12'd0;
					oBlue = 	12'd0;
				end
				else if (varied_color == 2'b01) begin // yellow
					oRed = 12'hfff;
					oGreen = 12'hfff;
					oBlue = 12'd0;
				end
				else if (varied_color == 2'b10) begin // blue
					oRed = 12'd0;
					oGreen = 12'd0;
					oBlue = 12'hfff;				
				end
				else  begin
					oRed = 	rRed;//12'hfff;
					oGreen =  rGreen[12:1];//12'd0;
					oBlue = rBlue;//12'd0;	
				end
			end
			else begin
					oRed = rRed;
					oGreen = rGreen[12:1];
					oBlue = rBlue;
			end
	end	
	else begin
		oRed = rRed;
       oGreen = rGreen[12:1];
      oBlue = rBlue;
	end
end

always @(posedge iCLK or negedge iRST_n) begin
	if (!iRST_n) begin	
		tmp_handwrite	<=	{patches{1'b1}};
		pre_final_handwrite <= 	0;
	end
	else begin
		tmp_handwrite	<=	next_tmp_handwrite;
		pre_final_handwrite	<=	final_handwrite;
	end
end



Line_Buffer	L1	(
					.clken(iDval),
					.clock(iCLK),
					.shiftin(iData),
					.shiftout(),
					.taps2x(wData0),
					.taps1x(wData1),
					.taps0x(wData2)
				);

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				dval_ctrl<=0;
			end	
		else
			begin
				if(iY_Cont>1)
					begin
						dval_ctrl<=1;
					end		
				else
					begin
						dval_ctrl<=0;
					end
			end	
	end

always@(posedge dval_ctrl or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				dval_ctrl_en<=0;
			end	
		else
			begin
				dval_ctrl_en<=1;
			end	
	end


always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				rDval<=0;
				oDval <= 0;
			end	
		else
			if(dval_ctrl_en)
				begin
					rDval<=iDval;	
					oDval<=rDval;
				end
			else
				begin
					rDval<=iDval;
					oDval<=0;
				end	
	end

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				wData0_d1<=0;
				wData0_d2<=0;
				wData1_d1<=0;
				wData1_d2<=0;
				wData2_d1<=0;
				wData2_d2<=0;				
			end
		else
			begin
				{wData0_d2,wData0_d1}<={wData0_d1,wData0};
				{wData1_d2,wData1_d1}<={wData1_d1,wData1};
				{wData2_d2,wData2_d1}<={wData2_d1,wData2};
			end
	end		
	
always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				rRed<=0;
				rGreen<=0;
				rBlue<=0;	
			end

		else if ({iY_Cont[0],iX_Cont[0]} == 2'b11)
			begin
				if (iY_Cont == 12'd1)
					begin
						rRed<=wData1_d1;
						rGreen<=wData0_d1+wData1;
						rBlue<=wData0;
					end		
				else
					begin
						rRed<=wData1_d1;
						rGreen<=wData1+wData2_d1;
						rBlue<=wData2;
					end
			end		
		else if ({iY_Cont[0],iX_Cont[0]} == 2'b10)
			begin
				if (iY_Cont == 12'd1)
					begin
						if (iX_Cont == 12'b0)
							begin
								rRed<=wData0_d2;
								rGreen<={wData1_d2,1'b0};
								rBlue<=wData1_d1;
							end
						else
							begin
								rRed<=wData1;
								rGreen<=wData1_d1+wData0;
								rBlue<=wData0_d1;	
							end
					end		
				else
					begin
						// for last one X pixel of the colowm process
						if (iX_Cont == 12'b0)
							begin
								rRed<=wData2_d2;
								rGreen<={wData2_d1,1'b0};
								rBlue<=wData1_d1;
							end
						// normal X pixel of the colowm process
						else
							begin
								rRed<=wData1;
								rGreen<=wData1_d1+wData2;
								rBlue<=wData2_d1;	
							end	
					end	
			end		
		else if ({iY_Cont[0],iX_Cont[0]} == 2'b01)
			begin
				rRed<=wData2_d1;
				rGreen<=wData2+wData1_d1;
				rBlue<=wData1;		
			end	

		else if ({iY_Cont[0],iX_Cont[0]} == 2'b00)
			begin
				if (iX_Cont == 12'b0)
					begin
						rRed<=wData1_d2;
						rGreen<={wData2_d2,1'b0};
						rBlue<=wData2_d1;
					end
				// normal X of the colowm process
				
				else
					begin
						rRed<=wData2;
						rGreen<=wData2_d1+wData1;
						rBlue<=wData1_d1;	
					end	
			end	
	end
output	reg	[8:0]	detectSkin;
output	reg	[8:0]	detectBlack;
reg		[8:0]	next_detectSkin;
reg		[8:0]	next_detectBlack;
output	reg			loose_detectSkin1;
reg					next_loose_detectSkin1;
output	reg			loose_detectSkin3;
reg					next_loose_detectSkin3;
output	reg			loose_detectSkin5;
reg					next_loose_detectSkin5;
output	reg			loose_detectSkin7;
reg					next_loose_detectSkin7;
reg		[3:0]		tmp_skincount1;
reg		[3:0]		next_tmp_skincount1;
reg		[3:0]		tmp_skincount3;
reg		[3:0]		next_tmp_skincount3;
reg		[3:0]		tmp_skincount5;
reg		[3:0]		next_tmp_skincount5;
reg		[3:0]		tmp_skincount7;
reg		[3:0]		next_tmp_skincount7;
reg		iIsSkin;
reg		iIsBlack;
	
always @(*) begin
		if (((oRed-oGreen) > 12'd160) && ((oRed-oGreen) < 12'd1120) && oGreen>oBlue && oBlue > 400 && oBlue < 1600 && oRed > 400)
			iIsSkin = 1;
		else
			iIsSkin = 0;
		if(oRed<700 && oGreen<700 & oBlue<700)
			iIsBlack = 1;
		else
			iIsBlack = 0;
	//	wave hand detection
		if(iX_Cont==200&&iY_Cont==150)	// (1,1)
			next_detectSkin[0] = iIsSkin;
		else
			next_detectSkin[0] = detectSkin[0];
		if(iX_Cont==200&&iY_Cont==300)	// (1,2)
			next_detectSkin[1] = iIsSkin;
		else
			next_detectSkin[1] = detectSkin[1];
		if(iX_Cont==200&&iY_Cont==450)	// (1,3)
			next_detectSkin[2] = iIsSkin;
		else
			next_detectSkin[2] = detectSkin[2];
		if(iX_Cont==400&&iY_Cont==150)	// (2,1)
			next_detectSkin[3] = iIsSkin;
		else
			next_detectSkin[3] = detectSkin[3];
		if(iX_Cont==400&&iY_Cont==300)	// (2,2)
			next_detectSkin[4] = iIsSkin;
		else
			next_detectSkin[4] = detectSkin[4];
		if(iX_Cont==400&&iY_Cont==450)	// (2,3)
			next_detectSkin[5] = iIsSkin;
		else
			next_detectSkin[5] = detectSkin[5];
		if(iX_Cont==600&&iY_Cont==150)	// (3,1)
			next_detectSkin[6] = iIsSkin;
		else
			next_detectSkin[6] = detectSkin[6];
		if(iX_Cont==600&&iY_Cont==300)	// (3,2)
			next_detectSkin[7] = iIsSkin;
		else
			next_detectSkin[7] = detectSkin[7];
		if(iX_Cont==600&&iY_Cont==450)	// (3,3)
			next_detectSkin[8] = iIsSkin;
		else
			next_detectSkin[8] = detectSkin[8];
		//loose skin detect
		//patch 1
		if(	  iX_Cont==350&&iY_Cont==100||iX_Cont==400&&iY_Cont==100||iX_Cont==450&&iY_Cont==100
			||iX_Cont==350&&iY_Cont==150||iX_Cont==400&&iY_Cont==150||iX_Cont==450&&iY_Cont==150
			||iX_Cont==350&&iY_Cont==200||iX_Cont==400&&iY_Cont==200||iX_Cont==450&&iY_Cont==200)
			next_tmp_skincount1 = tmp_skincount1 + 1;
		else if(iX_Cont==0&&iY_Cont==0)
			next_tmp_skincount1 = 0;
		else
			next_tmp_skincount1 = tmp_skincount1;
		if(iX_Cont == 799 && iY_Cont ==599)
			next_loose_detectSkin1 = (tmp_skincount1 > 1)?1:0;
		else
			next_loose_detectSkin1 = loose_detectSkin1;
		//patch 3
		if(	  iX_Cont==150&&iY_Cont==250||iX_Cont==200&&iY_Cont==250||iX_Cont==250&&iY_Cont==250
			||iX_Cont==150&&iY_Cont==300||iX_Cont==200&&iY_Cont==300||iX_Cont==250&&iY_Cont==300
			||iX_Cont==150&&iY_Cont==350||iX_Cont==200&&iY_Cont==350||iX_Cont==250&&iY_Cont==350)
			next_tmp_skincount3 = tmp_skincount3 + 1;
		else if(iX_Cont==0&&iY_Cont==0)
			next_tmp_skincount3 = 0;
		else
			next_tmp_skincount3 = tmp_skincount3;
		if(iX_Cont == 799 && iY_Cont ==599)
			next_loose_detectSkin3 = (tmp_skincount3 > 1)?1:0;
		else
			next_loose_detectSkin3 = loose_detectSkin3;
		//patch 5
		if(	  iX_Cont==550&&iY_Cont==250||iX_Cont==600&&iY_Cont==250||iX_Cont==650&&iY_Cont==250
			||iX_Cont==550&&iY_Cont==300||iX_Cont==600&&iY_Cont==300||iX_Cont==650&&iY_Cont==300
			||iX_Cont==550&&iY_Cont==350||iX_Cont==600&&iY_Cont==350||iX_Cont==650&&iY_Cont==350)
			next_tmp_skincount5 = tmp_skincount5 + 1;
		else if(iX_Cont==0&&iY_Cont==0)
			next_tmp_skincount5 = 0;
		else
			next_tmp_skincount5 = tmp_skincount5;
		if(iX_Cont == 799 && iY_Cont ==599)
			next_loose_detectSkin5 = (tmp_skincount5 > 1)?1:0;
		else
			next_loose_detectSkin5 = loose_detectSkin5;
		//patch 7
		if(	  iX_Cont==350&&iY_Cont==400||iX_Cont==400&&iY_Cont==400||iX_Cont==450&&iY_Cont==400
			||iX_Cont==350&&iY_Cont==450||iX_Cont==400&&iY_Cont==450||iX_Cont==450&&iY_Cont==450
			||iX_Cont==350&&iY_Cont==500||iX_Cont==400&&iY_Cont==500||iX_Cont==450&&iY_Cont==500)
			next_tmp_skincount7 = tmp_skincount7 + 1;
		else if(iX_Cont==0&&iY_Cont==0)
			next_tmp_skincount7 = 0;
		else
			next_tmp_skincount7 = tmp_skincount7;
		if(iX_Cont == 799 && iY_Cont ==599)
			next_loose_detectSkin7 = (tmp_skincount7 > 1)?1:0;
		else
			next_loose_detectSkin7 = loose_detectSkin7;
		
	//	wave hand detection
		if(iX_Cont==200&&iY_Cont==150)	// (1,1)
			next_detectBlack[0] = iIsBlack;
		else
			next_detectBlack[0] = detectBlack[0];
		if(iX_Cont==200&&iY_Cont==300)	// (1,2)
			next_detectBlack[1] = iIsBlack;
		else
			next_detectBlack[1] = detectBlack[1];
		if(iX_Cont==200&&iY_Cont==450)	// (1,3)
			next_detectBlack[2] = iIsBlack;
		else
			next_detectBlack[2] = detectBlack[2];
		if(iX_Cont==400&&iY_Cont==150)	// (2,1)
			next_detectBlack[3] = iIsBlack;
		else
			next_detectBlack[3] = detectBlack[3];
		if(iX_Cont==400&&iY_Cont==300)	// (2,2)
			next_detectBlack[4] = iIsBlack;
		else
			next_detectBlack[4] = detectBlack[4];
		if(iX_Cont==400&&iY_Cont==450)	// (2,3)
			next_detectBlack[5] = iIsBlack;
		else
			next_detectBlack[5] = detectBlack[5];
		if(iX_Cont==600&&iY_Cont==150)	// (3,1)
			next_detectBlack[6] = iIsBlack;
		else
			next_detectBlack[6] = detectBlack[6];
		if(iX_Cont==600&&iY_Cont==300)	// (3,2)
			next_detectBlack[7] = iIsBlack;
		else
			next_detectBlack[7] = detectBlack[7];
		if(iX_Cont==600&&iY_Cont==450)	// (3,3)
			next_detectBlack[8] = iIsBlack;
		else
			next_detectBlack[8] = detectBlack[8];
		
end






always @(posedge iCLK or negedge iRST_n) begin
	if (!iRST_n) begin	
		detectSkin	<=	0;
		detectBlack <= 0;
		loose_detectSkin1 <= 0;
		tmp_skincount1 <= 0;
		loose_detectSkin3 <= 0;
		tmp_skincount3 <= 0;
		loose_detectSkin5 <= 0;
		tmp_skincount5 <= 0;
		loose_detectSkin7 <= 0;
		tmp_skincount7 <= 0;
	end
	else begin
		detectSkin	<=	next_detectSkin;
		detectBlack <=  next_detectBlack;
		loose_detectSkin1 <= next_loose_detectSkin1;
		tmp_skincount1 <= next_tmp_skincount1;
		loose_detectSkin3 <= next_loose_detectSkin3;
		tmp_skincount3 <= next_tmp_skincount3;
		loose_detectSkin5 <= next_loose_detectSkin5;
		tmp_skincount5 <= next_tmp_skincount5;
		loose_detectSkin7 <= next_loose_detectSkin7;
		tmp_skincount7 <= next_tmp_skincount7;
	end
end

endmodule

`endif

