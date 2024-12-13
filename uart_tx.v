`timescale 1ns / 1ps
// This module transmits 1 bit at a time based based on the RS-232 UART (TX) protocol
// 1 start bit(0), 8 data bits, 1 stop bit (1) (and no parity) => 10 bits total

module uart_tx #(parameter BAUDRATE_DIVISOR = 100_000_000/9600) (
    input wire clk,
    input wire tx_trigger,
    input wire [7:0] tx_buffer,
    output reg tx_bit, // Last bit transmitted
    output reg tx_done
    );
    
    reg [3:0] bit_counter; // 0 to 9 including start, data, stop bits.
    reg [$clog2(BAUDRATE_DIVISOR)-1:0] baud_counter;
    reg baud_clk, baud_clk_flag; // Baud clock is the divided clock
    
    initial begin
        bit_counter <= 0;
        baud_counter <= 0;
        baud_clk <= 0;
        baud_clk_flag <= 0;
        tx_bit <= 1;
        tx_done <= 1;
    end
    
    always @(posedge clk) begin
    
        if (tx_trigger) begin
            tx_done <= 0;
            bit_counter <= 0;
            tx_bit <= 1;
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
            
            if (!tx_done) begin
                if (bit_counter == 0) begin
                    tx_bit <= 0; // start bit
                    bit_counter <= bit_counter + 1;
                end
                
                else if (bit_counter >= 1 && bit_counter <= 8) begin
                    tx_bit <= tx_buffer [bit_counter - 1];
                    bit_counter <= bit_counter + 1;
                end
                
                else if (bit_counter >= 9) begin
                    tx_bit <= 1; // stop bit
                    bit_counter <= 0;
                    tx_done <= 1;
                end
            end
       
        end
    end
endmodule
