module tb_top;

    parameter BAUDRATE_DIVISOR = 100_000_000/9600
    bit clk;
    uart_intf vif(clk);
    uart_test t(vif);

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

    always #10 clk = ~clk;
        
    initial begin
    repeat(2) @(posedge clk);
    
    end


endmodule