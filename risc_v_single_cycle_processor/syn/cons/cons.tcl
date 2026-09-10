#set_operating_conditions -max_library saed90nm_max_hvt -max WORST

create_clock -name fun_clk -period 10 -waveform {0 5} [get_ports fun_clk]

set_clock_uncertainty -hold 0.3 [get_clocks fun_clk]
set_clock_uncertainty -setup 0.3 [get_clocks fun_clk]

set_ideal_network [get_clocks fun_clk]
set_ideal_network [get_clocks scan_clk] 
set_ideal_network [get_ports fun_reset] 
set_ideal_network [get_ports scan_reset] 
set_ideal_network [get_ports test_mode]

set_case_analysis 0 [get_ports test_mode] 

set_max_fanout 10 $design
set_max_capacitance 50.0000 [current_design]
set_max_transition 0.5 [current_design]

set_input_delay -clock fun_clk -max 1.0 [remove_from_collection [all_inputs][get_ports {fun_clk fun_clk fun_reset scan_reset}]]
set_output_delay -clock fun_clk -max 1.0 [all_outputs]

set_driving_cell -lib_cell NBUFFX2 -pin Z [remove_from_collection [all_inputs][get_ports {fun_clk}]]
set_load  3.697506 [all_outputs] ; #buffer x16

#set_wire_load_model -library saed90nm_max -name 16000

set_dont_use [get_lib_cells */*AND3*]