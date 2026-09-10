set worst_case   "saed90nm_max.db"
set corner       "worst"

set_app_var search_path "/home/ICer/Downloads/Lib/synopsys/models"
set_app_var target_library "$worst_case"
set_app_var link_library "* $target_library"

sh rm -rf work
sh mkdir -p work
define_design_lib work -path ./work

set design riscv_single
set_svf ${design}.svf

analyze -library work -f verilog ../rtl/riscv_single.v
analyze -library work -f verilog ../rtl/control.v
analyze -library work -f verilog ../rtl/main_decoder.v
analyze -library work -f verilog ../rtl/alu_decoder.v
analyze -library work -f verilog ../rtl/alu.v
analyze -library work -f verilog ../rtl/reg_file.v
analyze -library work -f verilog ../rtl/data_mem.v
analyze -library work -f verilog ../rtl/instruction_mem.v
analyze -library work -f verilog ../rtl/extend.v
analyze -library work -f verilog ../rtl/adder.v
analyze -library work -f verilog ../rtl/program_counter.v

elaborate $design -lib work;

current_design $design
check_design

source -e -v ../cons/cons.tcl

set_critical_range 1.00 $design

set compile_prefer_mux true
set hdlin_infer_mux all

set_fix_multiple_port_nets -all -buffer_constants

compile -map_effort high -incremental_mapping
compile -map_effort high -incremental_mapping

sh rm -rf   ../results/$corner
sh mkdir -p ../results/$corner
sh mkdir -p ../results/$corner/reports
sh mkdir -p ../results/$corner/outputs

report_area  -hierarchy                                                            > ../results/$corner/reports/syn_area.rpt
report_cell                                                                        > ../results/$corner/reports/syn_cell.rpt
report_qor                                                                         > ../results/$corner/reports/syn_qor.rpt
report_power -hierarchy                                                            > ../results/$corner/reports/syn_power.rpt
report_timing -delay_type max -max_paths 10  -transition_time -capacitance -slack_lesser_than 0.0  > ../results/$corner/reports/syn_setup_violations.rpt
report_timing -delay_type max -max_paths 10  -transition_time -capacitance                                 > ../results/$corner/reports/syn_setup.rpt
report_timing -delay_type min -max_paths 10  -transition_time -capacitance -slack_lesser_than 0.0  > ../results/$corner/reports/syn_hold_violations.rpt
report_timing -delay_type min -max_paths 10  -transition_time -capacitance                                 > ../results/$corner/reports/syn_hold.rpt
report_constraints -all_violators                                                  > ../results/$corner/reports/syn_constraints.rpt 
report_clock -attributes                                                           > ../results/$corner/reports/syn_clock.rpt

set verilogout_no_tri true
set verilogout_equation false
change_names -rule verilog 

write  -f ddc     -hierarchy -output ../results/$corner/outputs/${design}.ddc
write  -f verilog -hierarchy -output ../results/$corner/outputs/${design}.v

write_sdc ../results/$corner/outputs/${design}.sdc
write_sdf ../results/$corner/outputs/${design}.sdf