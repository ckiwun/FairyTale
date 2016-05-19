module SDRAM_Complexion_Detection(	
							// input
							iRed,
							iGreen,
							iBlue,
							// output
							oRed,
							oGreen,
							oBlue,
							oIsSkin		
							);
									
	input	[9:0]	iRed;
	input	[9:0]	iGreen;
	input	[9:0]	iBlue;
	output	[9:0]	oRed;
	output	[9:0]	oGreen;
	output	[9:0]	oBlue;
	output	reg	[1:0]		oIsSkin;
	//====combinational declaration===========//
	always @(*) begin
		// ********** Thresholding **************************************************************************** //
		if (((iRed-iGreen) > 10'd40) && ((iRed-iGreen) < 10'd280) && iGreen>iBlue && iBlue > 100 && iBlue < 400 && iRed > 100)
			oIsSkin[1] = 1;
		else
			oIsSkin[1] = 0;
		if((iGreen-iRed) > 10'd0 && ((iGreen-iRed) < 10'd100)&& iBlue < 10'd800 /*&& iGreen>10'd700*/)
			oIsSkin[0] = 1;
		else
			oIsSkin[0] = 0;
		// **************************************************************************************************** //
	end
	//====continuous assignment===============//
	assign oRed = iRed;
	assign oGreen = iGreen;
	assign oBlue = iBlue;
	
endmodule
