vlib work
vmap work work

vlog ../rtl/g2b_bcd/binary_to_hex_7segment.v \
     ../rtl/g2b_bcd/g2b.v \
     ../rtl/g2b_bcd/top.v \
     ../tb/tb_top.v

vsim -voptargs="+acc" work.tb_top

add wave -r /*
run -all