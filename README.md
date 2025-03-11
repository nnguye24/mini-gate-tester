# mini logic analyzer
The Verilog code is for the Basys 3 FPGA board with Artix-7 chip. It utilizes the UART protocol to send logic inputs to a device under test. The DUT will send outputs back to the FPGA where the FPGA will verify if the correct outputs have been produced. It's basically a mini logic analyzer on FPGA. The goal of the project is the be able to transfer the code from the trainer board onto a more industrial FPGA device with wider pinout.

# verification
UVM Verification of UART module is included. The BRAM module doesn't require UVM. Testbenches are ran through Cadence Xcelium.

