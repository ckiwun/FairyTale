module U_Buffer(//40*30 sampling
				clk,//40M for 800*600
				rst,
				DVAL,
				iSkin,
				oSkinFrame,
				oSkin,
				//debug
				coorX,
				coorY,
				patchX,
				patchY,
				counter
				);
				
input	clk;
input 	rst;//change frame
input	DVAL;
input	iSkin;
output [1199:0]oSkinFrame;
output	oSkin;
//debug
output	[9:0]	coorX,coorY;
output	[5:0]	patchX,patchY;
output	[22:0] counter;

reg 	[19:0] 	counter/*,next_counter*/;
reg		pre_rst;
reg		[1199:0]oSkinFrame;
reg		[1199:0]next_oSkinFrame;
reg		[9:0]	coorX,coorY;
reg		[5:0]	patchX,patchY;
reg				oSkin;
reg				reset;
integer	i;

always @(*) begin
	reset = /*pre_rst^rst*/(pre_rst == 1'b0)&(rst == 1'b1);
	if((coorX%20==0)&&(coorY%20==0)) begin
		for(i=0;i<1200;i=i+1) begin
			if(i!=(patchY*40+patchX))
				next_oSkinFrame[i] = oSkinFrame[i];
			else
				next_oSkinFrame[i] = iSkin;
		end
	end
	else begin
		for(i=0;i<1200;i=i+1)
			next_oSkinFrame[i] = oSkinFrame[i];
	end
	coorX = counter % 800;
	coorY = counter / 800;
	patchX = coorX / 20;
	patchY = coorY / 20;
	oSkin = oSkinFrame[patchY*40+patchX];
	
end

always @(posedge clk or posedge reset) begin
	if(reset) begin
		for(i=0;i<1200;i=i+1)
			oSkinFrame[i] <= next_oSkinFrame[i];
		/*counter <= 0;*/
		pre_rst <= rst;
		counter <= 0;
	end
	else begin
		for(i=0;i<1200;i=i+1)
			oSkinFrame[i] <= next_oSkinFrame[i];
		/*counter <= next_counter;*/
		pre_rst <= rst;
		if(DVAL/*&&(counter < 20'd880001)*/) begin
			counter <= counter + 1;
		end
		else begin
			counter <= counter;
		end
	end
end

endmodule
