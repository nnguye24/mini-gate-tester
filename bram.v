`timescale 1ns / 1ps
// This is a module of block ram (36kb = 36864 bits for one).
// Byte Addressable (Width=8bits)
// Depth: 65536 (16-bit addressable: 0x0000 to 0xffff)

module bram (
    input wire clk,
    input wire mode, // 0 for read, 1 for write
    input wire [15:0] address,
    input wire [7:0] byte_in,
    output reg [7:0] byte_out
    );
    
    localparam READ = 0;
    localparam WRITE = 1;
    
    (* ram_style = "block" *) reg [7:0] memory [65535:0];
    
    integer i;
    initial begin // Reset for simulation
        i = 0;
        byte_out <= 0;
        for (i = 0; i <= 65535; i = i + 1) begin
            memory[i] <= 16'b0;
        end
    end
    
    always @(posedge clk) begin
        if (mode == READ) byte_out <= memory[address];
        else if (mode == WRITE) memory[address] <= byte_in;
    end

endmodule
