`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.03.2025 22:28:18
// Design Name: 
// Module Name: tb
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
module tb;
    // Inputs
    reg card_in;
    reg [3:0] pin;
    reg [1:0] menu_select;
    reg [20:0] amount_withdraw;
    reg another_txn;
    reg clk;
    reg reset;

    // Outputs
    wire error_msg;
    wire txn_success;
    wire [20:0] balance_amount;

    // Instantiating Unit Under Test (UUT)
    atm_controller uut (
        .card_in(card_in),
        .pin(pin),
        .menu_select(menu_select),
        .amount_withdraw(amount_withdraw),
        .another_txn(another_txn),
        .clk(clk),
        .reset(reset),
        .error_msg(error_msg),
        .txn_success(txn_success),
        .balance_amount(balance_amount)
    );

    // Clock Generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1; 
        card_in = 0;
        pin = 4'b0000;
        menu_select = 2'b10;
        amount_withdraw = 0;
        another_txn = 0;

        // Reset Phase
        #10 reset = 0;

        // Test Case 1: Insert card and verify PIN (valid case)
        #10 card_in = 1;  
        pin = 4'b1001;  // Enter correct PIN
        #20 menu_select = 2'b00;  // Select "Check Balance"
        #20;  // Allow balance to display
        $display("Balance after checking: %d", balance_amount);

        // Test Case 2: Withdraw money
        #10 menu_select = 2'b01;  // Select "Withdraw"
        amount_withdraw = 21'd500;  // Withdraw 500 units
        #60;  // Allow transaction to complete);

        // Test Case 3: Testing incorrect PIN attempts (3 wrong entries)
        #10 card_in = 0;  // Remove card
        #10 card_in = 1;  // Insert card again
        pin = 4'b0001;  // Wrong PIN attempt 1
        #20 pin = 4'b0010;  // Wrong PIN attempt 2
        #20 pin = 4'b0100;  // Wrong PIN attempt 3
        #20;  // Check error message
        if (error_msg) 
            $display("Error: Incorrect PIN entered 3 times");

        // Test Case 4: Performing multiple transactions
        #10 card_in = 1;  // Insert card again
        pin = 4'b1001;  // Enter correct PIN
        #20 menu_select = 2'b01;  // Withdraw money
        amount_withdraw = 21'd200;  // Withdraw 200 units
        another_txn = 1;  // Indicate another transaction
        #20 menu_select = 2'b00;  // Check Balance
        another_txn = 0;  // End transaction
        #60;
        
        $display("Final Balance: %d", balance_amount);
        
        // End Simulation
        $stop;
    end
endmodule
