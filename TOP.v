`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2024 09:10:54 PM
// Design Name: 
// Module Name: TOP
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


module TOP(
    input wire CLK,
    input wire UART_RX,
    output wire UART_TX
    );
    
    parameter BAUDRATE_DIVISOR = 100_000_000/9600;
    
    wire RX_TRIGGER, TX_TRIGGER, RX_DONE, TX_DONE;
    wire [7:0] RX_BUFFER, TX_BUFFER;
    
    wire BRAM_MODE;
    wire [15:0] BRAM_ADDRESS;
    wire [7:0] BRAM_BYTE_IN;
    wire [7:0] BRAM_BYTE_OUT;
    
    uart_rx #(BAUDRATE_DIVISOR) uart_rx0(
    .clk(CLK),
    .rx_trigger(RX_TRIGGER),
    .rx_bit(UART_RX),
    
    .rx_buffer(RX_BUFFER),
    .rx_done(RX_DONE)
    );
    
    uart_tx #(BAUDRATE_DIVISOR) uart_tx0(
    .clk(CLK),
    .tx_trigger(TX_TRIGGER),
    .tx_buffer(TX_BUFFER),
    
    .tx_bit(UART_TX),
    .tx_done(TX_DONE)
    );
    
    bram bram0(
    .clk(CLK),
    .mode(BRAM_MODE),
    .address(BRAM_ADDRESS),
    .byte_in(BRAM_BYTE_IN),
    
    .byte_out(BRAM_BYTE_OUT)
    );
    
    processor processor0(
    .clk(CLK),
    .bram_byte_read(BRAM_BYTE_OUT),
    .rx_byte(RX_BUFFER),
    .tx_done(TX_DONE),
    .rx_done(RX_DONE),
    
    .bram_mode(BRAM_MODE),
    .bram_address(BRAM_ADDRESS),
    .bram_byte_write(BRAM_BYTE_IN),
    .tx_byte(TX_BUFFER),
    .tx_trigger(TX_TRIGGER),
    .rx_trigger(RX_TRIGGER)
    );
    
    
endmodule
