`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 11:50:40 AM
// Design Name: 
// Module Name: shift_reg
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


module shift_reg(clk, clear, E,A);

input clk,clear,A;
output reg E;
reg B,C,D;

always @(posedge clk,negedge clear)
begin
if (!clear) 
begin 
B=0; C=0;D=0;
end 
else 
begin 
 E<=D;
 D<=C;
 C<=B;
 B<=A;
 end 
 end
 endmodule

module shift_tb; 

reg clk,clear,A; 
wire E; 

integer i;

shift_reg SR(.clk(clk),.clear(clear),.A(A),.E(E)); 

initial
begin 
clk=1'b0; #2 clear=0; #5 clear=1; 
end

always #5 clk=~clk;

initial 
begin
repeat(2)
begin
#10 A=0; #10 A=0; #10 A=1; #10 A=1;
end
end

initial 
begin
$dumpfile("shift_tb.vcd");
$dumpvars (0,shift_tb);
end
endmodule
