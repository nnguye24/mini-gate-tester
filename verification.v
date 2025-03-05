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

// STATES
/* 
TX_DUT--------------------------------
State where FPGA sends out our inputs to the DUT

RX_DUT--------------------------------
State where FPGA receives the outputs from the DUT

RX_INPUT------------------------------
State where FPGA receives DUT inputs from the PC
*/
module verification(
    input clk,
    input wire tx_done,
    input wire rx_done,
    input wire tx_byte,
    input wire dut_out,     // input from the DUT itself through PMOD port

    output reg [1:0] dut_pinout,    // 2 pin inputs to the DUT
    output reg [15:0] start_address,
    output reg [15:0] end_address,
    output reg [7:0] command,   // to send to processor to determine if write/read from memory location

    output reg [7:0] dut_output_reg // DUT outputs to be displayed as LED, 
    );
    
    localparam TX_DUT = 0;
    localparam RX_DUT = 1;
    localparam RX_INPUT = 2;
    
    // ready flags
    reg TX_DUT_READY;
    reg RX_DUT_READY;
    reg [7:0] dut_in, // logic inputs sent out to DUT
    reg [2:0] state;
    reg [2:0] num_outputs;
    reg [2:0] num_pairs;    // to count pairs of inputs, 4 pairs in total for 2 input device
    // read: 8h00 , write 8h01 
    initial begin
        // only need 1 address location for a 2 input gate input as we have 8 bit width per location
        // For example, the inputs of any 2 input gate would be 00 01 10 11,

        // * start and end addresses should be the same * for 2 input gate (which we are doing currently)
        command <= 8'h00;
        dut_in <= 8'h00;    // probably not needed as the processor reads from memory and does it
        state <= 3'b01; // starts in the RX_INPUT state
        num_pairs <= 0;
        num_outputs <= 0;

        TX_DUT_READY <= 0;
        RX_DUT_READY <= 0;

    end

    always @(posedge clk) begin
    
        case (state) 
            TX_DUT: begin   
                TX_DUT_READY <= 0; 
                // This is the transmit-to-dut address
                start_address <= 16'h0008;    // 8 - 15 (8 bits)
                end_address <= 16'h0008;
                // reads from 16'h0008, the 8-bit input address
                // stores these inputs in a register, to be sent through PMOD outputs
                dut_in <= tx_byte; // tx_byte received from processor.v read operation, stored in DUT input register
                if(RX_DUT_READY) begin
                    state <= RX_DUT;
                end
                else if (dut_in != 8'h00) begin  // if dut_in has been filled, we can go to RX_DUT
                // think about this.... maybe we dont even need dut_pinout
                // we can just assign outputs to two indexes of dut_in and pmod that way
                // ie. outA = dut_in[numpairs+1]
                // outB = dut_in[numpairs]
                    dut_pinout <= dut_in[num_pairs+1,num_pairs];    // takes 2 inputs from dut_in and puts into pinout
                    RX_DUT_READY <= 1;    // when inputs filled, go to 
                end
                if (num_outputs > 0) begin
                    num_outputs<=num_outputs+1;
                end
                
            end

            RX_DUT: begin
                RX_DUT_READY <= 0;
                // this is receive from dut address
                start_address <= 16'h0000;  //0 - 7 (8 bits)
                end_address <= 16'h0000;
                if (num_outputs != 4) begin
                    dut_output_reg[num_outputs] <= dut_out; // shift DUT outputs into a register
                    num_pairs <= num_pairs + 2;
                    TX_DUT_READY <= 1;
                end else begin
                    // go to RX_INPUT because we got 4 outputs
                    state <= RX_INPUT;
                end
                if (TX_DUT_READY) begin
                    state<=TX_DUT;
                end

            end

            RX_INPUT: begin
                // have to initialize input addresses, these will be changed later for reading *2* at a time. 
                command <= 8'h02;   // sends processor.v write command
                // wait for inputs to be filled. or else stay in this RX_INPUT state. 
                if (rx_done) begin  // inputs have been filled if rx_done = 1, 
                    command <= 8'h01;   // sends processor.v a read command as we just to TX_DUT
                    state <= TX_DUT;
                end
            end
        endcase
    end
endmodule
