vlib work
vmap work work

vlog ../rtl/edge_detector_counter/binary_to_hex_7segment.v \
     ../rtl/edge_detector_counter/clk_div.v \
     ../rtl/edge_detector_counter/four_bit_edge_counter.v \
     ../rtl/edge_detector_counter/rising_edge_detector_mealy.v \
     ../rtl/edge_detector_counter/edge_detector_counter_top.v \
     ../tb/tb_edge_detector_counter_top.v

vsim -voptargs="+acc" work.tb_edge_detector_counter_top

add wave -divider "Inputs"
add wave -radix binary sim:/tb_edge_detector_counter_top/clk
add wave -radix binary sim:/tb_edge_detector_counter_top/rst
add wave -radix binary sim:/tb_edge_detector_counter_top/in

add wave -divider "Top Internal Signals"
add wave -color White  -radix binary sim:/tb_edge_detector_counter_top/dut/clk_div_inst/clk_out
add wave -color Yellow -radix binary sim:/tb_edge_detector_counter_top/dut/tick_mealy
add wave -color Orange -radix unsigned sim:/tb_edge_detector_counter_top/dut/count

add wave -divider "Outputs"
add wave -color Cyan   -radix hex    sim:/tb_edge_detector_counter_top/segments

run -all