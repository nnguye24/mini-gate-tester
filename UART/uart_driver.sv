`timescale 1 ps/ 1 ps

`include "uvm_macros.svh"

// driver written kind of like a scoreboard as well
class uart_driver extends uvm_driver #(uart_transaction)
    `uart_component_utils(uart_driver)

    // Hz / BAUD
    

    localparam BAUDRATE_DIVISOR = 100_000_000/9600;
    virtual uart_intf vif;
    reg [7:0] data;
    int no_transactions;   


    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        if( !uvm_config_db #(virtual uart_intf)::get(this, "", "uart_intf", vif) )
        `uvm_error("", "uvm_config_db::get failed")
    endfunction

    task run_phase(uvm_phase phase)
        forever begin
            seq_item_port.get_next_item(req);

            `uvm_info("","---------------------------------------------",UVM_MEDIUM) 
            `uvm_info("", $sformatf("\t Transaction No. = %0d",no_transactions),UVM_MEDIUM) 
            // TX
            vif.tx_trigger <= 1;
            vif.tx_bit <= 1;
            @(posedge vif.clk);
                vif.tx_buffer <= req.tx_buffer;
            @(posedge vif.clk);
                wait(vif.tx_done == 1);
                vif.tx_trigger <= 1;

                if(vif.tx_done == 1) begin
                    `uvm_info("", $sformatf("\t tx_trigger = %0b, \t tx_buffer = %0h,\t tx_done = %0b",vif.tx_trigger,req.tx_buffer,vif.tx_done),UVM_MEDIUM)  
                    `uvm_info("","[TRANSACTION]::TX PASS",UVM_MEDIUM)  
                end
                else begin
                    `uvm_info("", $sformatf("\t tx_trigger = %0b, \t tx_buffer = %0h,\t tx_done = %0b",vif.tx_trigger,req.tx_buffer,vif.tx_done),UVM_MEDIUM)  
                    `uvm_info("","[TRANSACTION]::TX FAIL",UVM_MEDIUM)  
                end 
                repeat(100) @(posedge vif.clk);
            // RX
            @(posedge vif.clk)
                data = $random;
                vif.rx_bit <= 1'b0;
                repeat(BAUDRATE_DIVISOR) @(posedge vif.clk);
                for (int i = 0; i < 8; i++) begin
                    vif.rx_bit <= data[i];  // fill in rx_bit, 8 times, to fill up rx_buffer
                    repeat(BAUDRATE_DIVISOR) @(posedge vif.clk);
                end

                wait(vif.rx_done == 1);
                vif.rx_bit <= 1'b1; //   resets
                vif.rx_trigger <= 1;   

                repeat(BAUDRATE_DIVISOR) @(posedge vif.clk);
                repeat(100) @(posedge vif.clk); 
                `uvm_info("", $sformatf("\t Expected data = %0h, \t Obtained data = %0h", data,vif.rx_buffer),UVM_MEDIUM)  
                begin
                    if(vif.rx_buffer == data) begin
                    `uvm_info("","[TRANSACTION]::RX PASS",UVM_MEDIUM)  
                    `uvm_info("","---------------------------------------------",UVM_MEDIUM)  
                    end
                    else begin
                        `uvm_info("","[TRANSACTION]::RX FAIL",UVM_MEDIUM)  
                        `uvm_info("","---------------------------------------------",UVM_MEDIUM)  
                    end
                end
            seq_item_port.item_done();
            no_transactions++;
        end
    endtask
endclass