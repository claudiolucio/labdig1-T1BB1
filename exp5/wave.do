onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 /circuito_exp5_tb/rodada
add wave -noupdate -height 30 /circuito_exp5_tb/clock
add wave -noupdate -divider Entradas
add wave -noupdate -height 30 /circuito_exp5_tb/chaves
add wave -noupdate -height 30 /circuito_exp5_tb/iniciar
add wave -noupdate -height 30 /circuito_exp5_tb/reset
add wave -noupdate -divider {Detecao da jogada}
add wave -noupdate -height 30 /circuito_exp5_tb/db_tem_jogada
add wave -noupdate -divider Resultado
add wave -noupdate -height 30 /circuito_exp5_tb/pronto
add wave -noupdate -height 30 /circuito_exp5_tb/acertou
add wave -noupdate -height 30 /circuito_exp5_tb/errou
add wave -noupdate -height 30 /circuito_exp5_tb/db_timeout
add wave -noupdate -divider Saidas
add wave -noupdate -height 30 /circuito_exp5_tb/leds
add wave -noupdate -divider Depuracao
add wave -noupdate -height 30 /circuito_exp5_tb/db_igual
add wave -noupdate -height 30 -radix unsigned /circuito_exp5_tb/dut/db_contagem_fio
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp5_tb/dut/db_estado_fio
add wave -noupdate -height 30 -radix binary /circuito_exp5_tb/dut/db_jogada_fio
add wave -noupdate -height 30 -radix unsigned /circuito_exp5_tb/dut/db_limite_fio
add wave -noupdate -height 30 -radix unsigned /circuito_exp5_tb/dut/db_memoria_fio
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 247
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
WaveRestoreZoom {0 ns} {1528800 us}
