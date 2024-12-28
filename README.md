# FPGA UART Transceiver w/ BRAM for device verification
# *THIS PROJECT IS IN PROGRESS*
The Verilog code is for the Basys 3 FPGA board with Artix-7 chip. It utilizes the UART protocol to send logic inputs to a device under test. The DUT will send outputs back to the FPGA where the FPGA will verify if the correct outputs have been produced. The goal of the project is the be able to transfer the code from the trainer board onto a more industrial FPGA device with wider pinout. 


## Modules
The device utilizes four modules: receiver, transmitter, processor and BRAM. Each of these modules will communicate with each other in half-duplex to limit complexity. 
## Receiver
The receiver module utilizes a clock divider and a shift register to receive 8 bits of data. 

## Transmitter
The transmitter module works in exactly the same way that the receiver module does.

## Processor
The processor module determines when each of the three communcation modules(receiver, transmitter, and BRAM) will communicate with each other. The processor module is designed to make the project half-duplex. 

## BRAM
BRAM can be initialized by inference or by IP. The current iteration uses infereneced BRAM with 8-bit width and 16-bit depth. Both IP and Inferenced BRAM will be experimented with.
