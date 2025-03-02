`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2024 22:22:23
// Design Name: 
// Module Name: test
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
module test(); 
reg clk, reset, coin_1, coin_2;
reg [1:0]select; 
wire dispense, change; 
vendor uut (.clk(clk), .reset(reset), .coin_1(coin_1), .coin_2(coin_2
), .dispense(dispense), .change(change),.select(select)); 
always
begin
clk=~clk;#5;
end
initial
begin
coin_1=0;
coin_2=0;
select=2'b01;
clk=0;
reset=0;
reset=1;#10;
reset=0;#10;
coin_1=1;coin_2=0;#10;
coin_1=0;coin_2=0;#10;
coin_1=0;coin_2=1;#10;
coin_1=0;coin_2=0;#10;
$finish;
end
endmodule



