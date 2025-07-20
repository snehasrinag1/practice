`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2025 12:14:31 PM
// Design Name: 
// Module Name: xor_bitwise
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


module xor_bitwise(a,b,f);

parameter N=16;
input [N-1:0]a,b;
output [N-1:0]f;
integer xorlp[N-1:0];
genvar p;

generate 
for(p=0;p<N;p=p+1)
begin 
 xor XG(f[p],a[p],b[p]);
 end 
 endgenerate
endmodule

//testbench
module tb;

reg [15:0]a,b;
wire [15:0]f;

xor_bitwise G(.a(a),.b(b),.f(f));

initial
begin
$monitor ("a= %b, b= %b, f=%b",a,b,f);

a=16'haaaa; b=16'h0fff;
#10 a=16'h0f0f; b=16'h3333;
#20 $finish;
end
endmodule

