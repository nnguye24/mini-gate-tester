class uart_agent extends uvm_agent;

    `uvm_component_utils(uart_agent)

    uart_sequencer sequencer;
    uart_driver driver;
    uart_monitor monitor;
    uart_subscriber subscriber;


    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        sequencer = uart_sequencer::type_id::create("sequencer", this);
        driver = uart_driver::type_id::create("driver", this);
        monitor = uart_monitor::type_id::create("monitor", this);
        subscriber = uart_subsriber::type_id::create("subscriber", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect( sequencer.seq_item_export);
        monitor.ap_port.connect(subscriber.analysis_export);
    endfunction



endclass