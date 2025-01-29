`timescale 1ns / 1ps
// Memory Management State Machine

    module processor(
    input wire clk,
    input wire [7:0] bram_byte_read,
    input wire [7:0] rx_byte,
    input wire tx_done,
    input wire rx_done,
    
    input wire dut_start_address,   // address will come from verification.v 
    input wire dut_end_address, // DUT address is the address for DUT ouputs
    input wire input_start_address, // input address is the address for the DUT inputs. 
    input wire input_end_address,
    input wire [7:0] command, // command to determine read/write will be received from verification.
    
    output reg bram_mode,
    output reg [15:0] bram_address,
    output reg [7:0] bram_byte_write,
    output reg [7:0] tx_byte,
    output reg tx_trigger,
    output reg rx_trigger
    );
    

    localparam STATE_PROCESSING_COMMAND = 1;
    localparam STATE_READ = 2;
    localparam STATE_WRITE_WAITING_FOR_DATA = 3;
    localparam STATE_WRITE = 4;
    
   
    reg [2:0] command_byte_counter;
    reg [2:0] state;
    reg [15:0] start_address;
    reg [15:0] end_address;
    reg bram_ready;
    reg tx_ready;
    
    initial begin
        bram_mode <= 0;
        bram_address <= 0;
        bram_byte_write <= 0;
        tx_byte <= 0;
        tx_trigger <= 0;
        rx_trigger <= 0;
        

        command_byte_counter <= 0;

        start_address <= 0;
        end_address <= 0;
        bram_ready <= 0;
        tx_ready <= 0;
    end
    
    always @(posedge clk) begin
        case (state)

            STATE_PROCESSING_COMMAND: begin
                if (!rx_done) begin
                    rx_trigger <= 0;
                    if (command == 8'h00) state <= STATE_READ;  // command will be received from verification.v!
                    else if (command == 8'h01) state <= STATE_WRITE_WAITING_FOR_DATA;
                    else state <= STATE_PROCESSING_COMMAND;
                end
                else rx_trigger <= 1;
            end
            STATE_READ: begin   // reads from memory location and transmit to computer through UART
                start_address <= dut_start_address;
                end_address <= dut_end_address;
                if (tx_trigger) begin   //
                    tx_trigger <= 0;
                    if (start_address > end_address) begin // done transmitting, send back to WAITING FOR COMMAND
                        bram_ready <= 0;
                        start_address <= 0; // resets addresses
                        end_address <= 0;
                        state <= STATE_PROCESSING_COMMAND;  // send back to 
                    end
                end
                else if (tx_ready) begin // tx_ready indicates we are ready to transmit our byte, 
                    tx_byte <= bram_byte_read; // bram_byte_read is received from bram block
                    tx_trigger <= 1;    // sees if we are done with transmission, 
                    tx_ready <= 0; 
                    if (start_address <= end_address) start_address <= start_address + 1;
                end
                else if (bram_ready) begin  // bram ready tells us that we can transmit byte
                    tx_ready <= 1;
                    bram_ready <= 0;
                end
                else if (tx_done) begin // initially 1 from the transmitter block after transmission, tell bram is ready move onto next state
                    bram_mode <= 0;
                    bram_address <= start_address;
                    bram_ready <= 1;
                end
            end
            STATE_WRITE_WAITING_FOR_DATA: begin // extra layer of security so that we could make sure we are receiving
                if (rx_done) begin
                    state <= STATE_WRITE;
                end
            end
            // the write is very similar to the transmit logic flow, almost the same actually
            // logic flows backwards, we wait for stuff to finish!
            // all of this works because the fpga clock is much faster than the baud rate. Therefore, timing does not need to be considered
            // we are cycling through these states right as we receive the bits at a low speed. Since we cycle fast, we don't need to care
            // about missing timing. WE ARE SIGNIFICANTLY FASTER THAN THE BAUD RATE
            STATE_WRITE: begin
                start_address <= input_start_address;
                end_address <= input_end_address;
                if (rx_trigger) begin
                    if (start_address > end_address) begin
                        bram_mode <= 0; // extra precaution
                        bram_ready <= 0;
                        rx_trigger <= 1;
                        start_address <= 0;
                        end_address <= 0;
                        state <= STATE_PROCESSING_COMMAND;  // send back to check if read/write
                    end
                    else rx_trigger <= 0;
                end
                else if (bram_ready) begin
                    bram_mode <= 1;
                    rx_trigger <= 1;
                    bram_ready <= 0;
                    if (start_address <= end_address) start_address <= start_address + 1;
                end
                else if (rx_done) begin
                    bram_byte_write <= rx_byte;
                    bram_address <= start_address;
                    bram_ready <= 1;
                end
            end
            
            default: begin
                bram_ready <= 0;
                bram_mode <= 0;
                rx_trigger <= 1;
                tx_trigger <= 0;
                start_address <= 0;
                end_address <= 0;
                state <= STATE_PROCESSING_COMMAND;  
            end
        endcase
    end
    
    
    
endmodule