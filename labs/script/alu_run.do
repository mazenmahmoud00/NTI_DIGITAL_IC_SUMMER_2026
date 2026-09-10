vlib work
vmap work work
vlog ../rtl/alu/alu.v ../tb/tb_alu.v
vsim -voptargs="+acc" work.tb_alu
add wave -r /*
run -all