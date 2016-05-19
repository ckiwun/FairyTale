module icon_transfer(	//host input
						number,
						address,
						rom_address,
						//host output
						rom_data,
						oRed,
						oGreen,
						oBlue
					);
	//host input
	input 	[3:0]	number;
	input	[12:0]	address;
	output	[15:0]	rom_address;
	
	//host output
	input	[47:0]	rom_data;
	output	[7:0]	oRed;
	output	[7:0]	oGreen;
	output	[7:0]	oBlue;
	
	reg	[15:0]	rom_address;
	reg	[7:0]	oRed;
	reg	[7:0]	oGreen;
	reg	[7:0]	oBlue;
	
	wire	[23:0]	pixel1;
	wire	[23:0]	pixel2;
	
	assign	pixel1 = rom_data[47:24];
	assign	pixel2 = rom_data[23:0];
// host input
always@(*) begin
	rom_address = number*3200+address[12:1];
end
	
// host output
always@(*) begin
	case(address[0])
		0: 	begin
				oRed = pixel1[23:16];
				oGreen = pixel1[15:8];
				oBlue = pixel1[7:0];
			end
		1:	begin
				oRed = pixel2[23:16];
				oGreen = pixel2[15:8];
				oBlue = pixel2[7:0];
			end
	endcase
end
endmodule
