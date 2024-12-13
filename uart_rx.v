`timescale 1ns / 1ps
// This module receives 1 bit at a time based based on the RS-232 UART (RX) protocol
// Assumed 1 start bit(0), 8 data bits, 1 stop bit (1) (and no parity) => 10 bits total

module uart_rx #(parameter BAUDRATE_DIVISOR = 100_000_000/9600) (
    input wire clk,
    input wire rx_trigger, // Force reset uart_rx so it is ready for the next byte.
    input wire rx_bit, // Last bit received
    output reg [7:0] rx_buffer,    
    output reg rx_done // Indicates whether 1 byte was fully received.
    );
    
    reg [3:0] bit_counter;
    reg [$clog2(BAUDRATE_DIVISOR)-1:0] baud_counter;
    reg baud_clk, baud_clk_flag; // Baud clock is the divided clock
    
    initial begin
        bit_counter <= 0;
        baud_counter <= 0;
        baud_clk <= 0;
        baud_clk_flag <= 0;
        rx_buffer <= 0;
        rx_done <= 0;
    end        

    always @(posedge clk) begin
    
        if (rx_trigger) begin
            rx_done <= 0;
            bit_counter <= 0;
        end
    
        // Clock divisor for baudrate synchronization
        if (baud_counter == ((BAUDRATE_DIVISOR / 2) - 1)) begin 
                baud_clk <= ~baud_clk;
                baud_counter <= 0;
                if (~baud_clk) baud_clk_flag <= 1; // Rising edge of baud_clk. baud_clock will become 1 on the next clk cycle (but is 0 currently)
        end
        else baud_counter <= baud_counter + 1;

        if (baud_clk_flag) begin
            baud_clk_flag <= 0;
            
            if (!rx_done) begin
                if (bit_counter == 0 && rx_bit == 0) begin
                    bit_counter <= bit_counter + 1; // Ignore start bit (UART RX assumed high until start bit)
                end
                
                else if (bit_counter >= 1 && bit_counter <= 8) begin
                    rx_buffer [bit_counter - 1] <= rx_bit;
                    bit_counter <= bit_counter + 1;
                end
                
                else if (bit_counter >= 9) begin
                    bit_counter <= 0;
                    rx_done <= 1;
                end
            end
        
        end
    end
endmodule
