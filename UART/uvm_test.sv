`timescale 1 ps/ 1 ps

class uart_test extends uvm_test;
    `uvm_component_utils(uart_test);

    uart_environment env;

    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction

    // top down, instantiate environment...
    function void build_phase(uvm_phase phase);
        env = uart_environment::type_id::create("env", this);
    endfunction

    function void end_of_elaboration(uvm_phase phase)
        uvm_info("", this.sprint(), UVM_NONE)
    endfunction

    task run_phase(uvm_phase phase);
        uart_sequence sequencer;
        sequencer = uart_sequence::type_id::create("sequencer");
        if( !sequencer.randomize() ) 
            `uvm_error("", "Randomize failed")
        sequencer.starting_phase = phase;
        sequencer.start( env.agent.sequencer );
    endtask


endclass