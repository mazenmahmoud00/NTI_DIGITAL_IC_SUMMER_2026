###################################################################

# Created by write_sdc on Fri Sep 11 01:37:23 2026

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA
set_max_transition 0.5 [current_design]
set_max_capacitance 50 [current_design]
set_max_fanout 10 [current_design]
