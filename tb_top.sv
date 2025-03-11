module tb_top;

    parameter BAUDRATE_DIVISOR = 100_000_000/9600
    bit clk;
    uart_intf intf();
   
    uart #(BAUDRATE_DIVISOR) dut(
        .CLK(vif.clk),
        .UART_RX(vif.rx_bit),
        .TX_BUFFER(vif.tx_buffer),
        .TX_TRIGGER(vif.tx_trigger),
        .RX_TRIGGER(vif.rx_trigger),

        .UART_TX(vif.tx_bit),
        .TX_DONE(vif.tx_done),
        .RX_DONE(vif.rx_done),
        .RX_BUFFER(vif.rx_buffer)
    );
    initial begin
        intf.clk = 0;
        forever #5 intf.clk = ~intf.clk;

    end
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

    end


endmodule