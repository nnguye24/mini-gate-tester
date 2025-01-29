`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2025 04:22:30 PM
// Design Name: 
// Module Name: verification
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


module verification(
    input clk,
    input wire tx_done,
    input wire rx_done,
    
    output reg [15:0] dut_start_address,
    output reg [15:0] dut_end_address,
    output reg [15:0] input_start_address,
    output reg [15:0] input_end_address,
    output reg [7:0] command,   // to send to processor to determine if write/read from memory location
    output reg [7:0] dut_in // logic inputs sent out to DUT
    
    );
    
    localparam TX_DUT = 0;
    localparam RX_DUT = 1;
    localparam RX_INPUT = 2;
    
//    localparam WAIT_IN = 0;
//    localparam WRITE_IN = 1;
//    localparam READ_IN = 2;
//    localparam TX_IN= 3;
//    localparam WAIT_OUT = 4;
//    localparam RX_OUT = 5;
//    localparam WRITE_OUT = 6;
    
    reg [2:0] state;
    // read: 8h00 , write 8h01 
    always @(posedge clk) begin
    
        case (state) 
        TX_DUT: begin
            
            state <= RX_DUT;
            end
        RX_DUT: begin
        
            state <= RX_INPUT;
            end
        RX_INPUT: begin
        
        
            // wait for inputs to be filled. or else stay in this RX_INPUT state. 
            if (rx_done) begin  // inputs have been filled if rx_done = 1,
                state <= TX_DUT;
            end
            end
        
    end
endmodule
