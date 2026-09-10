vlib work
vmap work work

vlog ../rtl/light_chaser/light_chaser.v \
     ../rtl/light_chaser/clk_div.v \
     ../tb/tb_light_chaser.v

vsim -voptargs="+acc" work.tb_light_chaser
add wave -r /*
run -all