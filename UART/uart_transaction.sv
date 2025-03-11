`timescale 1 ps/ 1 ps

`include "uvm_macros.svh"
import uvm_pkg::*;

// transaction class
class uart_transaction extends uvm_sequence_item;
  `uvm_object_utils(uart_trans)

  bit tx_bit;  
  bit rx_bit;

  bit tx_trigger;
  bit rx_trigger;

  rand bit [7:0] tx_buffer;
	bit [7:0] rx_buffer;
  
	bit tx_done;
  bit rx_done;
  
   
  function new (string name = "");
    super.new(name);
    endfunction

endclass