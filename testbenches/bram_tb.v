`timescale 1ns / 1ps
module bram_tb;

reg clk;
reg mode;   // 0 for read, 1 for write
reg [16:0]address;
reg [7:0]byte_in;
wire [7:0]byte_out;


bram uut(clk, mode, address, byte_in, byte_out);

initial begin
    clk = 0;
end

always #10 clk = ~clk;  //Creates clock of period 20 ns

initial begin
    #200
    mode = 1;   // write mode 
    address = 4'h0;
    byte_in = 8'h60;
    #200
    mode = 0;    //Reads from address 0
    #200
    $finish();
end



endmodule