onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -radix unsigned /circuito_exp4_tb_erro/caso
add wave -noupdate -height 30 /circuito_exp4_tb_erro/clock_in
add wave -noupdate -divider Entradas
add wave -noupdate -height 30 /circuito_exp4_tb_erro/reset_in
add wave -noupdate -height 30 /circuito_exp4_tb_erro/iniciar_in
add wave -noupdate -height 30 /circuito_exp4_tb_erro/chaves_in
add wave -noupdate -divider {Detecao da jogada}
add wave -noupdate -height 30 /circuito_exp4_tb_erro/db_tem_jogada_out
add wave -noupdate -divider Resultado
add wave -noupdate -height 30 /circuito_exp4_tb_erro/acertou_out
add wave -noupdate -height 30 /circuito_exp4_tb_erro/errou_out
add wave -noupdate -height 30 /circuito_exp4_tb_erro/pronto_out
add wave -noupdate -divider Saidas
add wave -noupdate -height 30 /circuito_exp4_tb_erro/leds_out
add wave -noupdate -divider Depuracao
add wave -noupdate -height 30 /circuito_exp4_tb_erro/db_igual_out
add wave -noupdate -height 30 /circuito_exp4_tb_erro/dut/db_jogada_fio
add wave -noupdate -height 30 /circuito_exp4_tb_erro/dut/db_memoria_fio
add wave -noupdate -height 30 /circuito_exp4_tb_erro/dut/db_contagem_fio
add wave -noupdate -height 30 -radix unsigned /circuito_exp4_tb_erro/dut/db_estado_fio
add wave -noupdate -height 30 /circuito_exp4_tb_erro/db_iniciar_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {92121630 ns} 0}
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
WaveRestoreZoom {48475377 ns} {111865544 ns}
