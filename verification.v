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
    output reg [7:0] dut_in, // logic inputs sent out to DUT
    output reg [7:0] dut_out // DUT outputs to be displayed as LED
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
    initial begin
        dut_start_address <= 16'h0000;  //0 - 7 (8 bits)
        dut_end_address <= 16'h0007;

        
        command <= 8'h00;
        dut_in <= 8'h00;    // probably not needed as the processor reads from memory and does it
        state <= 3'b01; // starts in the RX_INPUT state
    end
    
    always @(posedge clk) begin
    
        case (state) 
        TX_DUT: begin
            // read and transmit 2 inputs, then go to RX_DUT
            //* COME BACK HERE * and write code that reads and transmit 2 inputs. 1/29
            
            
            //
            state <= RX_DUT;
            
        end
        RX_DUT: begin
        
            state <= TX_DUT;
            state <= RX_INPUT;
        end
        RX_INPUT: begin
            // have to initialize input addresses, these will be changed later for reading *2* at a time. 
            input_start_address <= 16'h0008;    // 8 - 15 (8 bits)
            input_end_address <= 16'h000F;
            command <= 8'h01;   // sends processor.v write command
            
            // wait for inputs to be filled. or else stay in this RX_INPUT state. 
            if (rx_done) begin  // inputs have been filled if rx_done = 1, 
                state <= TX_DUT;
            end
        end
    end
endmodule
