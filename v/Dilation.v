/* 
 (C) OOMusou 2008 http://oomusou.cnblogs.com
 
 Filename    : Dilation.v
 Compiler    : Quartus II 8.0
 Description : Demo how to implement Dilation in Verilog
 Release     : 09/27/2008 1.0
 */
 
 module Dilation (
   input            iCLK,
   input            iRST_N,
   input            iDVAL,
   input      [9:0] iDATA,
   output reg       oDVAL,
   output reg [9:0] oDATA
 );
 
 wire [9:0] Line0;
 wire [9:0] Line1;
 wire [9:0] Line2;
 reg  [9:0] P1, P2, P3, P4, P5, P6, P7, P8, P9;
 
 Line_Buffer b0    (
   .clken(iDVAL),
   .clock(iCLK),
   .shiftin(iDATA),
   .taps0x(Line0),
   .taps1x(Line1),
   .taps2x(Line2)
 );
 
 always@(posedge iCLK, negedge iRST_N) begin
     if(!iRST_N) begin
         P1 <=    0;
         P2 <=    0;
         P3 <=    0;
         P4 <=    0;
         P5 <=    0;
         P6 <=    0;
         P7 <=    0;
         P8 <=    0;
         P9 <=    0;
         oDVAL <= 0;
     end
     else begin
       oDVAL <= iDVAL;
         P9    <= Line0;
         P8    <= P9;
         P7    <= P8;
         P6    <= Line1;
         P5    <= P6;
         P4    <= P5;
         P3    <= Line2;
         P2    <= P3;
         P1    <= P2;
         
     if (iDVAL)
       oDATA <= P9 | P8 | P7 | P6 | P5 | P4 | P3 | P2 | P1;
     else
       oDATA <= 0;  
     end
 end
 
 endmodule