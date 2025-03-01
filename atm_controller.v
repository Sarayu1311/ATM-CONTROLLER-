`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.03.2025 22:24:46
// Design Name: 
// Module Name: atm_controller
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
module atm_controller(
    input card_in,
    input [3:0] pin,
    input [1:0] menu_select,
    input [20:0] amount_withdraw,
    input another_txn,
    input clk,
    input reset,
    output reg error_msg,
    output reg txn_success,
    output reg [20:0] balance_amount
);
    // Initializing States
    parameter idle = 4'b0000;
    parameter pin_verify = 4'b0001;
    parameter mainmenu = 4'b0010;
    parameter txn_complete = 4'b0011;
    parameter error = 4'b0100;
    parameter check_balance = 4'b0101;
    parameter cashwithdrawl = 4'b0110;

    reg [3:0] state, next_state;
    reg [1:0] count;
    reg [20:0] balance [2:0];  // Balance for 3 users
    reg [3:0] pins [2:0];      // PINs for 3 users

    // Initializing balance and PINs
    initial begin
        balance[0] = 21'd10000;
        pins[0] = 4'b1001; // PIN: 9
        balance[1] = 21'd15000;
        pins[1] = 4'b1000; // PIN: 8
        balance[2] = 21'd20000;
        pins[2] = 4'b1010; // PIN: 10
        count = 0;
    end

    // State Transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= idle;
            count <= 0;
            txn_success <= 0;
            error_msg <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        case (state)
            idle: 
                next_state = (card_in) ? pin_verify : idle;

            pin_verify: begin
                if ((pin == pins[0]) || (pin == pins[1]) || (pin == pins[2])) begin
                    next_state = mainmenu;
                    count = 0;
                end else if (count < 3) begin
                    next_state = pin_verify;
                end else begin
                    next_state = error;
                end
            end

            mainmenu: begin
                case (menu_select)
                    2'b00: next_state = check_balance;
                    2'b01: next_state = cashwithdrawl;
                    default: next_state = idle;
                endcase
            end

            cashwithdrawl: 
                next_state = txn_complete;

            check_balance: 
                next_state = txn_complete;

            txn_complete: 
                next_state = (another_txn) ? mainmenu : idle;

            error: 
                next_state = idle;

            default: 
                next_state = idle;
        endcase
    end

    // Output Logic
    always @(posedge clk) begin
        case (state)
            idle: begin
                txn_success <= 0;
                error_msg <= 0;
            end

            pin_verify: begin
                if ((pin == pins[0]) || (pin == pins[1]) || (pin == pins[2])) begin
                    txn_success <= 0;
                    error_msg <= 0;
                end else begin
                    txn_success <= 0;
                    error_msg <= 1;
                    count <= count + 1;
                end
            end

            mainmenu: begin
                txn_success <= 0;
                error_msg <= 0;
            end

            check_balance: begin
                txn_success <= 1;
                error_msg <= 0;
                if (pin == pins[0]) balance_amount <= balance[0];
                else if (pin == pins[1]) balance_amount <= balance[1];
                else if (pin == pins[2]) balance_amount <= balance[2];
            end

            cashwithdrawl: begin
                txn_success <= 1;
                error_msg <= 0;
                if (pin == pins[0] && balance[0] >= amount_withdraw) 
                    balance[0] <= balance[0] - amount_withdraw;
                else if (pin == pins[1] && balance[1] >= amount_withdraw) 
                    balance[1] <= balance[1] - amount_withdraw;
                else if (pin == pins[2] && balance[2] >= amount_withdraw) 
                    balance[2] <= balance[2] - amount_withdraw;
                else 
                    error_msg <= 1;  // Insufficient funds error
                
                if (pin == pins[0]) balance_amount <= balance[0];
                else if (pin == pins[1]) balance_amount <= balance[1];
                else if (pin == pins[2]) balance_amount <= balance[2];
            end

            txn_complete: begin
                txn_success <= 0;
                error_msg <= 0;
            end

            error: begin
                txn_success <= 0;
                error_msg <= 1;
            end

            default: begin
                txn_success <= 0;
                error_msg <= 0;
            end
        endcase
    end
endmodule

