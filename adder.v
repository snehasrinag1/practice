`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 12:00:51 PM
// Design Name: 
// Module Name: adder
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
//2 7-bit adder with randomized testbench

module adder(a,b,sum,cout); 

input [7:0]a,b;
output [7:0]sum;
output cout;

assign #5 sum=a^b;
assign #5 cout= ((a&b)+(b&cout));

endmodule

module test_adder;

reg [7:0] a,b;
wire [7:0]sum;
wire cout;

integer myseed;

adder ADD(.a(a),.b(b),.sum(sum),.cout(cout));

initial myseed=15;

initial
begin
repeat(5)
begin
a = $random(myseed);
b = $random(myseed);
#10 $monitor("TIME: %3d, a=%h,b=%h, sum=%h", $time,a,b,sum);
end
end
endmodule


