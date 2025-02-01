onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /circuito_exp3_tb/caso
add wave -noupdate /circuito_exp3_tb/clockPeriod
add wave -noupdate /circuito_exp3_tb/clock_in
add wave -noupdate /circuito_exp3_tb/reset_in
add wave -noupdate /circuito_exp3_tb/iniciar_in
add wave -noupdate /circuito_exp3_tb/chaves_in
add wave -noupdate /circuito_exp3_tb/pronto_out
add wave -noupdate /circuito_exp3_tb/db_igual_out
add wave -noupdate /circuito_exp3_tb/db_iniciar_out
add wave -noupdate /circuito_exp3_tb/dut/db_contagem
add wave -noupdate /circuito_exp3_tb/dut/db_memoria
add wave -noupdate /circuito_exp3_tb/dut/db_chaves
add wave -noupdate /circuito_exp3_tb/dut/db_estado
add wave -noupdate /circuito_exp3_tb/dut/db_chaves_fio
add wave -noupdate /circuito_exp3_tb/dut/db_contagem_fio
add wave -noupdate /circuito_exp3_tb/dut/db_memoria_fio
add wave -noupdate /circuito_exp3_tb/dut/db_estado_fio
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 318
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {410 ns} {1274 ns}
