`timescale 1 ps/ 1 ps

interface uart_intf;
  
    logic clk;
    logic rx_bit;
    logic [7:0] tx_buffer;
    logic tx_trigger;
    logic tx_bit;
    logic [7:0] rx_buffer;
    logic tx_done; 
    logic rx_done;


endinterface