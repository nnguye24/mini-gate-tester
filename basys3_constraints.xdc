## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## SPI configuration mode options for QSPI boot, can be used for all designs
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

## Clock signal
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports CLK]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]

set_input_delay -clock [get_clocks sys_clk_pin] -min 1 [get_ports UART_RX]
set_input_delay -clock [get_clocks sys_clk_pin] -max 3 [get_ports UART_RX]
set_output_delay -clock [get_clocks sys_clk_pin] -min 1 [get_ports UART_TX]
set_output_delay -clock [get_clocks sys_clk_pin] -max 3 [get_ports UART_TX]

##USB-RS232 Interface
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports UART_RX]
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports UART_TX]
