class uart_subscriber extends uvm_subscriber;

    `uvm_component_utils(uart_subscriber)
    uart_transaction transaction;

    covergroup cg;
        RX: coverpoint transaction.rx_bit {option.auto_bin_max = 1;}
        TX_BUF: coverpoint transaction.tx_buffer {option.auto_bin_max = 8;}
        TX_TRIGGER: coverpoint transaction.tx_trigger {option.auto_bin_max = 1;}
        TX: coverpoint transaction.tx_bit{option.auto_bin_max = 1;}
        RX_BUF: coverpoint transaction.rx_buffer{option.auto_bin_max = 8;}
        DONE: coverpoint transaction.tx_done{option.auto_bin_max = 1;}

        RX_BxRX_BUF: cross RX,RX_BUF;
        TXxTX_BUFxDONE: cross TX,TX_BUF,DONE;
        TX_TRIGGERxTX_BUF: cross TX_TRIGGER,TX_BUF;


    endgroup

    function new(string name="", uvm_component parent);
        super.new(name, parent);
        cg_inst = new();
	endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual function void write(uart_transaction t)
        $cast(trans,t);

        cg_inst.sample();

    endfunction



endclass