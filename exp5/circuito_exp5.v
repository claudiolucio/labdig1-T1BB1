module circuito_exp4_desafio (
 input clock,
 input reset,
 input iniciar,
 input [3:0] chaves,
 output pronto,
 output db_igual,
 output acertou,
 output errou,
 output [3:0] leds,
 output [6:0] db_timeout
 output [6:0] db_contagem,
 output [6:0] db_memoria,
 output [6:0] db_estado,
 output [6:0] db_jogadafeita,
 output db_tem_jogada,
 output db_clock
);

wire zeraR, zeraC, contaC, registraR, igual, fimC, jogada_feita, fim_timer_fio, zera_timer_fio; 
wire [3:0] db_jogada_fio, db_contagem_fio, db_memoria_fio, db_estado_fio;


fluxo_dados fd (
    .clock( clock ),
    .chaves( chaves ),
    .zeraR( zeraR ),
    .registraR( registraR ),
    .contaC( contaC ), 
    .zeraC( zeraC ),
    .fim_timer( fim_timer_fio ),
    .zera_timer ( zera_timer_fio ),
    .igual( igual ),
    .fimC( fimC ),
    .jogada_feita( jogada_feita ),
    .db_tem_jogada ( db_tem_jogada ),
    .db_contagem( db_contagem_fio ),
    .db_jogada ( db_jogada_fio ),
    .db_memoria( db_memoria_fio )
);

unidade_controle uc(
    .clock( clock ),
    .reset( reset ),
    .iniciar( iniciar ), 
    .igual ( igual ),
    .fim( fimC ),
    .fim_timer ( fim_timer_fio ),
    .zera_timer ( zera_timer_fio ),
    .zeraC( zeraC ),
    .contaC( contaC ),
    .zeraR( zeraR ),
    .jogada (jogada_feita),
    .registraR( registraR ),
    .pronto( pronto ),
    .acertou_out ( acertou ),
    .errou_out ( errou ),
    .db_estado( db_estado_fio )
);

hexa7seg HEX2(
    .hexa( db_jogada_fio ),
    .display( db_jogadafeita )
);

hexa7seg HEX0(
    .hexa( db_contagem_fio ),
    .display( db_contagem )
);

hexa7seg HEX1(
    .hexa( db_memoria_fio ),
    .display( db_memoria )
);


hexa7seg HEX5(
    .hexa( db_estado_fio ),
    .display( db_estado )
);

assign db_igual = igual;
assign db_clock = clock;
assign leds = db_jogada_fio;

endmodule