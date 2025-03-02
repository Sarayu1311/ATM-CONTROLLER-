`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2024 21:30:53
// Design Name: 
// Module Name: vendor
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
module vendor(clk, reset,coin_1, coin_2,dispense, change,select);
input clk, reset,coin_1, coin_2;
input [1:0]select;
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11; 
reg [1:0]state,next_state;
output reg dispense,change;
always @(posedge clk or posedge reset)
begin 
if (reset) 
state <= S0; 
else
state <= next_state; 
end 
always @(*)
begin 
case (state) 
S0: next_state = (coin_1) ? S1:((coin_2) ? S2:S0); 
S1: next_state = (coin_1) ? S2 :((coin_2) ? S3 : S1); 
S2: next_state =coin_1 ? S3:((coin_2)?S0 : S2);
S3: next_state = S0; 
default: next_state = S0; 
endcase 
end 
always @(state)
begin 
case (state) 
S0: begin dispense = 0; change = 0; end 
S1: begin dispense = 0; change = 0; end 
S2: begin dispense = 0; change =(coin_2) ? 1:0; end 
S3:begin
case(select)
2'b00: begin dispense = 1; change =(coin_1 || coin_2) ? 1 : 0;end
2'b01: begin dispense = 1; change =(coin_1 || coin_2) ? 1 : 0;end
2'b10: begin dispense = 1; change =(coin_1 || coin_2) ? 1 : 0;end
default: begin dispense = 0; change = 0; end 
endcase
end
default: begin dispense = 0; change = 0; end 
endcase 
end 
endmodule

