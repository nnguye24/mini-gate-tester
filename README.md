# FPGA UART Transceiver w/ BRAM for device verification
# *THIS PROJECT IS IN PROGRESS*
The Verilog code is for the Basys 3 FPGA board with Artix-7 chip. It utilizes the UART protocol to send logic inputs to a device under test. The DUT will send outputs back to the FPGA where the FPGA will verify if the correct outputs have been produced.


## Modules
The device utilizes three modules: receiver, transmitter, and BRAM. Each of these modules will communicate with each other in half-duplex to limit complexity. 

## BRAM
This can be initialized by inference or by IP. Both will be experimented with.
