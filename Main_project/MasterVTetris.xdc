## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clock_100]
set_property IOSTANDARD LVCMOS33 [get_ports clock_100]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clock_100]

## Switches
set_property PACKAGE_PIN V17 [get_ports {draw_tetris}]
set_property IOSTANDARD LVCMOS33 [get_ports {draw_tetris}]
set_property PACKAGE_PIN V16 [get_ports {BTN_Reset}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN_Reset}]
#set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
#set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
#set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
#set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
#set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
#set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
set_property PACKAGE_PIN V2 [get_ports {UseCounts[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UseCounts[6]}]
set_property PACKAGE_PIN T3 [get_ports {UseCounts[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UseCounts[5]}]
set_property PACKAGE_PIN T2 [get_ports {UseCounts[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UseCounts[4]}]
set_property PACKAGE_PIN R3 [get_ports {UseCounts[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UseCounts[3]}]
set_property PACKAGE_PIN W2 [get_ports {UseCounts[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UseCounts[2]}]
set_property PACKAGE_PIN U1 [get_ports {UseCounts[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UseCounts[1]}]
set_property PACKAGE_PIN T1 [get_ports {UseCounts[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UseCounts[0]}]
set_property PACKAGE_PIN R2 [get_ports start_comparison]
set_property IOSTANDARD LVCMOS33 [get_ports start_comparison]


## LEDs
set_property PACKAGE_PIN U16 [get_ports {LED_Tetris}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_Tetris}]
set_property PACKAGE_PIN E19 [get_ports {LED_TetrisReset}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_TetrisReset}]
#set_property PACKAGE_PIN U19 [get_ports {led[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
#set_property PACKAGE_PIN V19 [get_ports {led[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
#set_property PACKAGE_PIN W18 [get_ports {led[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
#set_property PACKAGE_PIN U15 [get_ports {led[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
#set_property PACKAGE_PIN U14 [get_ports {led[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
#set_property PACKAGE_PIN V14 [get_ports {led[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property PACKAGE_PIN V13 [get_ports {LED_UseCounts[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_UseCounts[6]}]
set_property PACKAGE_PIN V3 [get_ports {LED_UseCounts[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_UseCounts[5]}]
set_property PACKAGE_PIN W3 [get_ports {LED_UseCounts[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_UseCounts[4]}]
set_property PACKAGE_PIN U3 [get_ports {LED_UseCounts[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_UseCounts[3]}]
set_property PACKAGE_PIN P3 [get_ports {LED_UseCounts[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_UseCounts[2]}]
set_property PACKAGE_PIN N3 [get_ports {LED_UseCounts[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_UseCounts[1]}]
set_property PACKAGE_PIN P1 [get_ports {LED_UseCounts[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_UseCounts[0]}]
set_property PACKAGE_PIN L1 [get_ports LED_Compare]
set_property IOSTANDARD LVCMOS33 [get_ports LED_Compare]


##7 segment display
set_property PACKAGE_PIN W7 [get_ports {SSEG_CA[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[0]}]
set_property PACKAGE_PIN W6 [get_ports {SSEG_CA[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[1]}]
set_property PACKAGE_PIN U8 [get_ports {SSEG_CA[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[2]}]
set_property PACKAGE_PIN V8 [get_ports {SSEG_CA[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[3]}]
set_property PACKAGE_PIN U5 [get_ports {SSEG_CA[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[4]}]
set_property PACKAGE_PIN V5 [get_ports {SSEG_CA[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[5]}]
set_property PACKAGE_PIN U7 [get_ports {SSEG_CA[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[6]}]

set_property PACKAGE_PIN V7 [get_ports {SSEG_CA[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[7]}]

set_property PACKAGE_PIN U2 [get_ports {SSEG_AN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[0]}]
set_property PACKAGE_PIN U4 [get_ports {SSEG_AN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[1]}]
set_property PACKAGE_PIN V4 [get_ports {SSEG_AN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[2]}]
set_property PACKAGE_PIN W4 [get_ports {SSEG_AN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[3]}]


##Buttons
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property PACKAGE_PIN T18 [get_ports BTN_RotateCW]
set_property IOSTANDARD LVCMOS33 [get_ports BTN_RotateCW]
set_property PACKAGE_PIN W19 [get_ports BTN_MoveRight]
set_property IOSTANDARD LVCMOS33 [get_ports BTN_MoveRight]
set_property PACKAGE_PIN T17 [get_ports BTN_MoveLeft]
set_property IOSTANDARD LVCMOS33 [get_ports BTN_MoveLeft]
set_property PACKAGE_PIN U17 [get_ports BTN_RotateCCW]
set_property IOSTANDARD LVCMOS33 [get_ports BTN_RotateCCW]



##Pmod Header layer_3
#Sch name = layer_31
set_property PACKAGE_PIN J1 [get_ports {layer_3[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_3[0]}]
#Sch name = layer_32
set_property PACKAGE_PIN L2 [get_ports {layer_3[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_3[1]}]
#Sch name = layer_33
set_property PACKAGE_PIN J2 [get_ports {layer_3[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_3[2]}]
#Sch name = layer_34
set_property PACKAGE_PIN G2 [get_ports {layer_3[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_3[3]}]
#Sch name = layer_37
set_property PACKAGE_PIN H1 [get_ports {layer_3[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_3[4]}]
#Sch name = layer_38
set_property PACKAGE_PIN K2 [get_ports {layer_3[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_3[5]}]
#Sch name = layer_39
set_property PACKAGE_PIN H2 [get_ports {layer_3[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_3[6]}]
#Sch name = layer_310
set_property PACKAGE_PIN G3 [get_ports {layer_3[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_3[7]}]



##Pmod Header layer_2
#Sch name = layer_21
#set_property PACKAGE_PIN A14 [get_ports {layer_2[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[0]}]
##Sch name = layer_22
#set_property PACKAGE_PIN A16 [get_ports {layer_2[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[1]}]
##Sch name = layer_23
#set_property PACKAGE_PIN B15 [get_ports {layer_2[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[2]}]
##Sch name = layer_24
#set_property PACKAGE_PIN B16 [get_ports {layer_2[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[3]}]
##Sch name = layer_27
#set_property PACKAGE_PIN A15 [get_ports {layer_2[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[4]}]
##Sch name = layer_28
#set_property PACKAGE_PIN A17 [get_ports {layer_2[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[5]}]
##Sch name = layer_29
#set_property PACKAGE_PIN C15 [get_ports {layer_2[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[6]}]
##Sch name = layer_210
#set_property PACKAGE_PIN C16 [get_ports {layer_2[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[7]}]



#Pmod Header layer_1
#Sch name = layer_11
set_property PACKAGE_PIN K17 [get_ports {layer_1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_1[0]}]
#Sch name = layer_12
set_property PACKAGE_PIN M18 [get_ports {layer_1[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_1[1]}]
#Sch name = layer_13
set_property PACKAGE_PIN N17 [get_ports {layer_1[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_1[2]}]
#Sch name = layer_14
set_property PACKAGE_PIN P18 [get_ports {layer_1[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_1[3]}]
#Sch name = layer_17
set_property PACKAGE_PIN L17 [get_ports {layer_1[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_1[4]}]
#Sch name = layer_18
set_property PACKAGE_PIN M19 [get_ports {layer_1[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_1[5]}]
#Sch name = layer_19
set_property PACKAGE_PIN P17 [get_ports {layer_1[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_1[6]}]
#Sch name = layer_110
set_property PACKAGE_PIN R18 [get_ports {layer_1[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_1[7]}]


#Pmod Header JXADC
#Sch name = XA1_P
set_property PACKAGE_PIN J3 [get_ports {layer_2[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[0]}]
#Sch name = XA2_P
set_property PACKAGE_PIN L3 [get_ports {layer_2[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[1]}]
#Sch name = XA3_P
set_property PACKAGE_PIN M2 [get_ports {layer_2[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[2]}]
#Sch name = XA4_P
set_property PACKAGE_PIN N2 [get_ports {layer_2[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[3]}]
#Sch name = XA1_N
set_property PACKAGE_PIN K3 [get_ports {layer_2[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[4]}]
#Sch name = XA2_N
set_property PACKAGE_PIN M3 [get_ports {layer_2[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[5]}]
#Sch name = XA3_N
set_property PACKAGE_PIN M1 [get_ports {layer_2[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[6]}]
#Sch name = XA4_N
set_property PACKAGE_PIN N1 [get_ports {layer_2[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {layer_2[7]}]


##VGA Connector
set_property PACKAGE_PIN G19 [get_ports {r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]
set_property PACKAGE_PIN H19 [get_ports {r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]
set_property PACKAGE_PIN J19 [get_ports {r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[2]}]
set_property PACKAGE_PIN N19 [get_ports {r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[3]}]
set_property PACKAGE_PIN N18 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
set_property PACKAGE_PIN L18 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property PACKAGE_PIN K18 [get_ports {b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]
set_property PACKAGE_PIN J18 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]
set_property PACKAGE_PIN J17 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
set_property PACKAGE_PIN H17 [get_ports {g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]
set_property PACKAGE_PIN G17 [get_ports {g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[2]}]
set_property PACKAGE_PIN D17 [get_ports {g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[3]}]


set_property PACKAGE_PIN P19 [get_ports HS]
set_property IOSTANDARD LVCMOS33 [get_ports HS]
set_property PACKAGE_PIN R19 [get_ports VS]
set_property IOSTANDARD LVCMOS33 [get_ports VS]

##USB-RS232 Interface
#set_property PACKAGE_PIN B18 [get_ports RsRx]
#set_property IOSTANDARD LVCMOS33 [get_ports RsRx]
#set_property PACKAGE_PIN A18 [get_ports RsTx]
#set_property IOSTANDARD LVCMOS33 [get_ports RsTx]


##USB HID (PS/2)
#set_property PACKAGE_PIN C17 [get_ports PS2Clk]
#set_property IOSTANDARD LVCMOS33 [get_ports PS2Clk]
#set_property PULLUP true [get_ports PS2Clk]
#set_property PACKAGE_PIN B17 [get_ports PS2Data]
#set_property IOSTANDARD LVCMOS33 [get_ports PS2Data]
#set_property PULLUP true [get_ports PS2Data]


##Quad SPI Flash
##Note that CCLK_0 cannot be placed in 7 series devices. You can access it using the
##STARTUPE2 primitive.
#set_property PACKAGE_PIN D18 [get_ports {QspiDB[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[0]}]
#set_property PACKAGE_PIN D19 [get_ports {QspiDB[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[1]}]
#set_property PACKAGE_PIN G18 [get_ports {QspiDB[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[2]}]
#set_property PACKAGE_PIN F18 [get_ports {QspiDB[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[3]}]
#set_property PACKAGE_PIN K19 [get_ports QspiCSn]
#set_property IOSTANDARD LVCMOS33 [get_ports QspiCSn]


## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

