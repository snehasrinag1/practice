`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2025 12:11:47 PM
// Design Name: Multiply 2 16-bit numbers
// Module Name: mul_datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mul_datapath(eqz,ldA,ldB,ldP,clrP,decB,clk,data_in);

input ldA,ldB,ldP,clrP,decB,clk;
input [15:0]data_in;
output eqz;
wire [15:0] X,Y,Z,Bus,Bout;

PIPO1 A(X,Bus,ldA,clk);
PIPO2 P(Y,Z,ldP,clrP,clk);
ADD AD(Z,X,Y);
CNTR B(Bout,Bus,ldB,decB,clk);
EQZ Comp(eqz,Bout); 
endmodule

module PIPO1(dout,din,ld,clk);

input[15:0]din; output reg [15:0]dout;
input ld,clk;

always@(posedge clk)
if (ld) dout<=din;
endmodule


module PIPO2(dout,din,ld,clr,clk);

input [15:0]din; output reg[15:0]dout; 
input ld,clr,clk;

always@(posedge clk)
if(clr) dout<=16'b0;
else if(ld) dout<=din;

endmodule

module ADD(dout, din1,din2);

input [15:0]din1,din2;
output reg [15:0]dout;

always@(*)
dout<=din1+din2;

endmodule 

module CNTR(dout,din,ld,dec,clk);

input [15:0]din; input ld,dec,clk;
output reg[15:0] dout;

always@(posedge clk)

if (ld)
dout<=din;
else if(dec)
dout<=dout-1;
endmodule

module EQZ (eq,din);


input [15:0]din; output eq;

  assign eq=(din==0);
  
endmodule 

module controller(ldA,ldB,ldP,clrP,decB,done,clk,eqz,start);

input clk,eqz,start;
output reg ldA,ldB,ldP,clrP,decB,done;

reg[2:0] state;
parameter S0=3'b000, S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100;

always@(posedge clk)
begin
case(state)
S0: if(start) state<=S1;
S1: state<=S2;
S2: state<=S3;
S3: if(eqz) state<=S4;
 else state<=S3;
S4: state<=S4; 
default: state<=S0;
endcase
end 

always@(state)
begin
case(state)
S0: begin #1 ldA=0; ldB=0; ldP=0; clrP=0;decB=0;done=0; end 
S1: begin #1 ldA=1; end
S2: begin #1 ldA=0; ldB=1;clrP=1; end
S3: begin #1 ldB=0; clrP=0; ldP=1; decB=1; end 
S4: begin #1 done=1; ldP=0; decB=0; end 
default:  begin #1 ldA=0; ldB=0; ldP=0; clrP=0;decB=0; end 
endcase
end
endmodule 


module mul_test;

reg[15:0]data_in;
reg clk,start;
wire done;

mul_datapath DP(eqz,ldA,ldB,ldP,clrP,decB,clk,data_in);
controller con(ldA,ldB,ldP,clrP,decB,done,clk,eqz,start);

initial
begin 
clk=1'b0;
#3 start =1'b1;
#1000 $finish;
end

always #5 clk=~clk;

initial
begin 
#17 data_in=17;
#20 data_in=5;
end 

initial
begin
$monitor($time, "%d %d",DP.Y,done);
//$dumpfile ("mul.vcd");
//$dumpvars(0,mul_test);
end
endmodule











