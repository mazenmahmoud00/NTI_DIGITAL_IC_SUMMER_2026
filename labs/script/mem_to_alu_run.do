vlib work
vmap work work

vlog ../rtl/mem_to_alu/alu.v \
     ../rtl/mem_to_alu/sipo.v \
     ../rtl/mem_to_alu/piso.v \
     ../rtl/mem_to_alu/ram.v \
     ../rtl/mem_to_alu/mem_to_alu.v \
     ../tb/tb_mem_to_alu.v

vsim -voptargs="+acc" work.tb_mem_to_alu
add wave -r /*
run -all