vlib work
vmap work work

vlog ../rtl/fsm/rising_edge_detector_moore.v \
     ../rtl/fsm/rising_edge_detector_mealy.v \
     ../tb/tb_rising_edge_detector.v

vsim -voptargs="+acc" work.tb_edge_detectors

add wave -radix binary sim:/tb_edge_detectors/clk
add wave -radix binary sim:/tb_edge_detectors/rst
add wave -radix binary sim:/tb_edge_detectors/in
add wave -color Yellow -radix binary sim:/tb_edge_detectors/tick_mealy
add wave -color Cyan   -radix binary sim:/tb_edge_detectors/tick_moore

run -all