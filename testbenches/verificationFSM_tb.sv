`timescale 1ns / 1ps




// shortened version of verification.v with just FSM
module dut(input clk, input dut_in, output dut_pinout )
reg clk;
reg [2:0] state;
reg TX_DUT_READY;
reg RX_DUT_READY;
reg [2:0] num_outputs;
reg [2:0] num_pairs;    // to count pairs of inputs, 4 pairs in total for 2 input device

localparam TX_DUT = 0;
localparam RX_DUT = 1;
localparam RX_INPUT = 2;

initial begin
    dut_in <= 8'h00;    // probably not needed as the processor reads from memory and does it
    state <= 3'b01; // starts in the RX_INPUT state
    num_pairs <= 0;
    num_outputs <= 0;
    TX_DUT_READY = 0;
    RX_DUT_READY = 0;

end

always_ff @(posedge clk)begin
    case (state) 
            TX_DUT: begin   
                TX_DUT_READY <= 0; 


                if(RX_DUT_READY) begin
                    state <= RX_DUT;
                end
                else if (dut_in != 8'h00) begin  // if dut_in has been filled, we can go to RX_DUT
                    dut_pinout <= dut_in[num_pairs+1,num_pairs];    // takes 2 inputs from dut_in and puts into pinout
                    RX_DUT_READY <= 1;    // when inputs filled, go to 
                end
                if (num_outputs > 0) begin
                    num_outputs<=num_outputs+1;
                end
                
            end

            RX_DUT: begin
                RX_DUT_READY <= 0;

                if (num_outputs != 4) begin
                    dut_output_reg[num_outputs] <= dut_out; // shift DUT outputs into a register
                    num_pairs <= num_pairs + 2;
                    TX_DUT_READY <= 1;
                end else begin
                    // go to RX_INPUT because we got 4 outputs
                    state <= RX_INPUT;
                end
                if (TX_DUT_READY) begin
                    state<=TX_DUT;
                end

            end

            RX_INPUT: begin
                // wait for inputs to be filled. or else stay in this RX_INPUT state. 
                if (rx_done) begin  // inputs have been filled if rx_done = 1, 
                    state <= TX_DUT;
                end
            end
        endcase
end
endmodule

module verificationFSM_tb();
    logic clk;
    reg [7:0] dut_in;
    reg [1:0] dut_pinout

    dut_in = 8'b11001111;   // example input

    always #10 clk = ~clk;   // generate clock
    // Instantiate DUT
    dut vFSMdut(clk, dut_in, dut_pinout);  
    // Check to see if pinout is equal to the last two inputs (11)
    assert (dut_pinout == 2b'11); 

    




endmodule