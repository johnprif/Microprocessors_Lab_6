onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /Shifts_tb/opcode
add wave -noupdate -radix unsigned /Shifts_tb/r1
add wave -noupdate -radix unsigned /Shifts_tb/r2
add wave -noupdate -radix unsigned /Shifts_tb/out
add wave -noupdate -radix unsigned /Shifts_tb/result
add wave -noupdate -radix unsigned /Shifts_tb/iscorrect
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1740 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1688 ps} {1912 ps}
