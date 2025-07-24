`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2025 01:20:03 PM
// Design Name: 
// Module Name: gcd_datapath
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


module gcd_datapath(gt,lt,eq,ldA,ldB,sel1,sel2,sel_in,data_in,clk);

input ldA,ldB,sel1,sel2,sel_in,clk;
input [15:0]data_in;
output gt,lt,eq;

wire[15:0] Aout,Bout,X,Y,Bus,Subout;

PIPO A(Aout,Bus,ldA,clk);
PIPO B(Bout,Bus,ldB,clk);
Mux mux1(X,Aout,Bout,sel1);
Mux mux2(Y,Aout,Bout,sel2);
Mux mux3(Bus,Subout,data_in,sel_in);
Sub sb(Subout,X,Y);
Comp c(lt,gt,eq,Aout,Bout);

endmodule

module PIPO(dout,din,ldA,clk);

input [15:0]din; output reg[15:0]dout;
input clk; input ldA;

always @(posedge clk)
if(ldA) dout<=din;
else dout<=0;
endmodule

module Mux(out,in1,in2,sel);

input [15:0]in1,in2; input sel;
output [15:0]out;

assign out=sel?in2:in1;
endmodule

module Sub(out,in1,in2);
input[15:0]in1,in2; output reg[15:0]out;

always@(*)
out=in1-in2;
endmodule

module Comp(lt,gt,eq,in1,in2);

input[15:0]in1,in2;
output lt,gt,eq;

assign lt= in1<in2;
assign gt= in1>in2;
assign eq= in1==in2;

endmodule

module controller(ldA,ldB,sel1,sel2,sel_in,done,clk,lt,gt,eq,start);

input clk,lt,gt,eq,start;
output reg ldA,ldB,sel1,sel2,sel_in,done;

reg[2:0]state;
parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100,S5=3'b101;

always@(posedge clk)
begin
 case(state)
 S0: if(start) state<=S1; 
 S1: state<=S2;
 S2: #2 if(eq) state<=S5;
  else if(lt) state<=S3;
  else if(gt)state<=S4;
 S3: #2  if(eq) state<=S5;
  else if(lt) state<=S3;
  else if(gt)state<=S4;
 S4: #2  if(eq) state<=S5;
  else if(lt) state<=S3;
  else if(gt)state<=S4;
 S5: state<=S5;
 default: state<=S0;
 endcase
 end   
 
 
 always@(state)
begin
  case(state)
  S0: begin sel_in=1; ldA=1; ldB=0; done=0; end
  S1: begin sel_in=1; ldA=0; ldB=1; done=0; end
  S2: if(eq) done=1;
    else if(lt) begin sel1=1; sel2=0; sel_in=0; ldA=0; ldB=1; end   
    else if(gt) begin sel1=0; sel2=1; sel_in=0; ldA=1; ldB=0; end
  S3: if(eq) done=1;
    else if(lt) begin sel1=1; sel2=0; sel_in=0; ldA=0; ldB=1; end   
    else if(gt) begin sel1=0; sel2=1; sel_in=0; ldA=1; ldB=0; end  
  S4: if(eq) done=1;
    else if(lt) begin sel1=1; sel2=0; sel_in=0; ldA=0; ldB=1; end   
    else if(gt) begin sel1=0; sel2=1; sel_in=0; ldA=1; ldB=0; end  
  S5: begin done=1; sel1=0; sel2=0;ldA=0;ldB=0; end  
  default: begin ldA=0; ldB=0; end
  endcase
  end 
  
  endmodule
  
  module gcd_test;
  reg[15:0]data_in;
  reg clk,start;
  wire done;
  
  reg [15:0]A,B;
  
  gcd_datapath DP(gt,lt,eq,ldA,ldB,sel1,sel2,sel_in,data_in,clk);
  controller C(ldA,ldB,sel1,sel2,sel_in,done,clk,lt,gt,eq,start);
  
 initial
 begin
 clk=1'b0;
 #3 start=1'b1;
 #2000 $finish;
 end
 
 always #5 clk=~clk;
 
 initial
 begin 
 #12 data_in=143;
 #10 data_in=78;
 end 
 
 initial 
 begin 
 $monitor($time, " %d %b",DP.Aout,done);
 end
 endmodule 


