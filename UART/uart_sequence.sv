`timescale 1 ps/ 1 ps

typedef uvm_sequencer #(uart_transaction) uart_sequencer;

// sequencer class

class uvm_sequence extends uvm_sequence #(uart_transaction);
    `uvm_object_utils(uart_sequence)

    int count;

    function new (string == "")
        super.new(name)
    endfunction: 

endclass