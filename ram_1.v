`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2025 08:51:37 PM
// Design Name: 
// Module Name: ram_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Single-port RAM with synchronous read and write
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ram_1(addr,data,clk,rd,wr,cs);

input[9:0]addr; input clk,rd,wr,cs; inout [7:0]data;

reg[7:0] mem[1023:0];
reg [7:0]dout;

assign data= (cs &&rd)?dout :8'bz;

always @(posedge clk)
if(cs && wr &&!rd)
mem[addr]=data;
always @(posedge clk)
if(cs && !wr && rd)
dout =mem[addr];
endmodule
