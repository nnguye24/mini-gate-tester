class uart_monitor extends uvm_monitor;

    virtual uart_intf intf;
    uart_transaction transaction;
    uvm_analysis_port #(uart_transaction) ap_port;
    `uvm_component_utils(uart_monitor)

    // constructor 
    function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction


    function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	    ap_port = new("ap_port",this);
	    transaction = uart_transaction::type_id::create("transaction");
	    if(!uvm_config_db #(virtual uart_intf)::get(this, "", "uart_intf", intf)) begin
		    `uvm_error("ERROR::", "UVM_CONFIG_DB FAILED in uart_monitor")
        end
	endfunction


    task run_phase(uvm_phase phase);
        while(1) begin
            @(posedge intf.clk);
            transaction = uart_transaction::type_id::create("transaction");
            transaction.tx_trigger = intf.tx_trigger;
            transaction.rx_trigger = intf.rx_trigger;
            
            transaction.tx_done = intf.tx_done;
            transaction.rx_done = intf.rx_done;
        

            transaction.rx_bit = intf.rx_bit;
            transaction.rx_buffer = intf.rx_buffer;
            
            transaction.tx_bit = intf.tx_bit;
            transaction.tx_buffer = intf.tx_buffer;
            ap_port.write(transaction);
        end
  endtask



endclass