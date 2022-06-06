#Setup.tcl
# Setup pin setting for EP2C5 board
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

set_location_assignment PIN_23 -to clk
set_location_assignment PIN_52 -to BUT[8]
set_location_assignment PIN_50 -to BUT[7]
set_location_assignment PIN_46 -to BUT[6]
set_location_assignment PIN_43 -to BUT[5]
set_location_assignment PIN_39 -to BUT[4]
set_location_assignment PIN_34 -to BUT[3]
set_location_assignment PIN_32 -to BUT[2]
set_location_assignment PIN_30 -to BUT[1]


set_location_assignment PIN_51 -to led[7]
set_location_assignment PIN_49 -to led[6]
set_location_assignment PIN_44 -to led[5]
set_location_assignment PIN_42 -to led[4]
set_location_assignment PIN_38 -to led[3]
set_location_assignment PIN_33 -to led[2]
set_location_assignment PIN_31 -to led[1]
set_location_assignment PIN_28 -to led[0]



set_location_assignment PIN_144 -to seg_led[7]
set_location_assignment PIN_143 -to seg_led[6]
set_location_assignment PIN_142 -to seg_led[5]
set_location_assignment PIN_141 -to seg_led[4]
set_location_assignment PIN_138 -to seg_led[3]
set_location_assignment PIN_137 -to seg_led[2]
set_location_assignment PIN_136 -to seg_led[1]
set_location_assignment PIN_135 -to seg_led[0]

set_location_assignment PIN_133 -to seg_sel[5]
set_location_assignment PIN_132 -to seg_sel[4]
set_location_assignment PIN_129 -to seg_sel[3]
set_location_assignment PIN_3 -to seg_sel[2]
set_location_assignment PIN_2 -to seg_sel[1]
set_location_assignment PIN_1 -to seg_sel[0]