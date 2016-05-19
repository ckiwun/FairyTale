module Complexion_Detection(	
							clk,
							rst,
							//luminance & saturation
							add_lum,
							sub_lum,
							add_sat,
							sub_sat,
							// Control side
							oRequest,
							iRed,
							iGreen,
							iBlue,
							iIsSkin,
							iIsGreen,
							// VGA side
							iRequest,
							oRed,
							oGreen,
							oBlue,
							oIsSkin,
							oIsGreen,
							// Control
							iSwitch,
							luminance,
							saturation
							);
									
	input			clk;
	input			rst;
	input			add_lum;
	input			sub_lum;
	input			add_sat;
	input			sub_sat;	
	input	[9:0]	iRed  ;
	input	[9:0]	iGreen;
	input	[9:0]	iBlue ;
	input			iRequest;
	input			iIsSkin;
	input			iIsGreen;
	input	[1:0]	iSwitch;
	
	output	reg	[9:0]	oRed;
	output	reg	[9:0]	oGreen;
	output	reg	[9:0]	oBlue;
	output			oIsSkin;
	output			oIsGreen;
	output			oRequest;
	//====parameter declaration===============//
	parameter lum_scale = 50;
	parameter sat_scale = 20;
	//====reg/write declaration===============//
	output reg		[3:0]	luminance;
	reg 	[3:0]	next_luminance;
	output reg		[3:0]	saturation;
	reg	[3:0]	next_saturation;	
	reg		[9:0]	pRed;		
	reg		[9:0]	pGreen;	
	reg		[9:0]	pBlue;	
	reg		[10:0]	del_pRed;
	reg		[10:0]	del_pBlue;
	reg				pre_add_lum;
	reg				pre_sub_lum;
	reg				pre_add_sat;
	reg             pre_sub_sat;
	reg				event_add_lum;
	reg				event_sub_lum;
	reg				event_add_sat;
	reg				event_sub_sat;	
	reg		[19:0]	next_counter;
	reg				pre_rst_frame;

	assign oIsGreen = iIsGreen;
	//====combinational declaration===========//
	always @(*) begin	
		del_pRed 	= luminance*lum_scale;
		del_pBlue 	= luminance*lum_scale + saturation*sat_scale;
		pRed = 		(11'd1023 - iRed) >= del_pRed ? iRed + del_pRed : 10'd1023;
		pGreen = 	((11'd1023 - iGreen + saturation*sat_scale) <= luminance*lum_scale)	? 10'd1023 : ((iGreen + luminance*lum_scale) >=  saturation*sat_scale) ? iGreen + luminance*lum_scale - saturation*sat_scale : 10'd0;
		pBlue = 	(11'd1023 - iBlue) >= del_pBlue ? iBlue + del_pBlue : 10'd1023;

		//lumines
		event_add_lum = ({pre_add_lum,add_lum}==2'b10);
		event_sub_lum = ({pre_sub_lum,sub_lum}==2'b10);
		casex({event_add_lum,event_sub_lum,(luminance>0),(luminance==4'b1111)})
			4'b1xx0: next_luminance = luminance + 1;
			4'b011x: next_luminance = luminance - 1;
			default:next_luminance = luminance;
		endcase
		
		//saturation
		event_add_sat = ({pre_add_sat,add_sat}==2'b10);
		event_sub_sat = ({pre_sub_sat,sub_sat}==2'b10);		
		casex({event_add_sat,event_sub_sat,(saturation>0),(saturation==4'b1111)})
			4'b1xx0: next_saturation = saturation + 1;
			4'b011x: next_saturation = saturation - 1;
			default:next_saturation = saturation;
		endcase		
		
		case(iSwitch[1:0])  //complexion detection
			2'b10: 	begin
						if (iIsSkin) begin
							oRed 	= 10'h3FF;
							oGreen 	= 10'h3FF;
							oBlue 	= 10'h3FF;
						end
						else begin
							oRed 	= 10'h0;
							oGreen 	= 10'h0;
							oBlue 	= 10'h0;
						end
					end
			2'b01: 	begin //gray scale: brightness
						oRed 	= (pRed + 2*pGreen + pBlue)/4;
						oGreen 	= (pRed + 2*pGreen + pBlue)/4;
						oBlue 	= (pRed + 2*pGreen + pBlue)/4;
					end
			2'b11: 	begin //infrared
						if(iIsGreen) begin
							oRed 	= 10'h3FF;
							oGreen 	= 10'h3FF;
							oBlue 	= 10'h3FF;
						end
						else begin
							oRed 	= 10'h0;
							oGreen 	= 10'h0;
							oBlue 	= 10'h0;
						end
					end	
			2'b00: 	begin //raw RGB
						oRed 	= pRed;
						oGreen 	= pGreen;
						oBlue 	= pBlue;
					end
		endcase
	end
	//====sequential declaration==============//
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			luminance 	<= 0;
			saturation 	<= 0;
			pre_add_lum <= 0;
			pre_sub_lum <= 0;
			pre_add_sat <= 0;
			pre_sub_sat <= 0;
		end
		else begin
			luminance <= next_luminance;
			saturation  <= next_saturation;
			pre_add_lum <= add_lum;
			pre_sub_lum <= sub_lum;
			pre_add_sat <= add_sat;
			pre_sub_sat <= sub_sat;
		end
	end
	//====continuous assignment===============//
	assign	oRequest	=	iRequest;
	assign	oIsSkin		=	iIsSkin;
endmodule
