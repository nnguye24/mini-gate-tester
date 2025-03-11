`timescale 1ns / 1ps

parameter BAUDRATE_DIVISOR = 100_000_000/9600;

module uart_top(
    input  CLK,
    input  UART_RX,
    input [7:0] TX_BUFFER,
    input TX_TRIGGER,
    input RX_TRIGGER,

    output  UART_TX,
    output TX_DONE,
    output RX_DONE,
    output [7:0] RX_BUFFER
    );


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


endmodule