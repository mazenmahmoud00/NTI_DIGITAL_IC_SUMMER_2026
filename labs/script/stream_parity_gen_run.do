vlib work
vmap work work

vlog ../rtl/stream_parity_gen/stream_parity_gen.v \
     ../tb/tb_stream_parity_gen.v

vsim -voptargs="+acc" work.tb_stream_parity_gen

add wave -r /*
run -all