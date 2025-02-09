module circuito_exp6 (
 input clock,
 input reset,
 input jogar,
 input [3:0] chaves,
 output pronto,
 output db_igual,
 output acertou,
 output errou,
 output [3:0] leds,
 output [6:0] db_timeout,
 output [6:0] db_contagem,
 output [6:0] db_memoria,
 output [6:0] db_estado,
 output [6:0] db_jogadafeita,
 output [6:0] db_limite,
 output db_tem_jogada,
 output db_endmenorquelimite,
 output db_clock
);

wire zeraR, zeraE, contaE, contaL, zeraL, registraR, igual, fimE, jogada_feita, fim_timer_fio, zera_timer_fio, conta_timer_fio, fim_sequencia, ultima_sequencia;
wire fim_timer_leds_fio, zera_timer_leds_fio, conta_timer_leds_fio, registraM_fio, limpaM_fio; 
wire [3:0] db_jogada_fio, db_contagem_fio, db_memoria_fio, db_limite_fio; 
wire [6:0] db_timeout_fio;
wire [4:0] db_estado_fio;

fluxo_dados fd (
    .clock( clock ),
    .chaves( chaves ),
    .zeraR( zeraR ),
    .registraR( registraR ),
    .contaE( contaE ), 
    .zeraE( zeraE ),
    .fim_timer( fim_timer_fio ),
    .zera_timer ( zera_timer_fio ),
    .conta_timer( conta_timer_fio ),
    .contaL ( contaL ),
    .zeraL ( zeraL ),
    .igual( igual ),
    .fimE ( fimE ),
    .jogada_feita( jogada_feita ),
    .db_tem_jogada ( db_tem_jogada ),
    .fim_sequencia( fim_sequencia ),
    .ultima_sequencia( ultima_sequencia ),
    .db_endmenorquelimite( db_endmenorquelimite ),
    .db_limite( db_limite_fio ),
    .db_contagem( db_contagem_fio ),
    .db_memoria( db_memoria_fio ),
    .limpaM( limpaM_fio ),
    .registraM( registraM_fio ),
    .zera_timer_leds( zera_timer_leds_fio ),
    .conta_timer_leds( conta_timer_leds_fio ),
    .fim_timer_leds( fim_timer_leds_fio )
);

unidade_controle uc(
    .clock( clock ),
    .reset( reset ),
    .jogar( jogar ), 
    .igual ( igual ),
    .fim( fimE ),
    .fim_timer ( fim_timer_fio ),
    .zera_timer ( zera_timer_fio ),
    .fim_sequencia( fim_sequencia ),
    .ultima_sequencia( ultima_sequencia ),
    .conta_timer(conta_timer_fio),
    .zeraE( zeraE ),
    .contaE( contaE ),
    .zeraR( zeraR ),
    .jogada (jogada_feita),
    .registraR( registraR ),
    .pronto( pronto ),
    .contaL ( contaL ),
    .zeraL ( zeraL ),
    .acertou_out ( acertou ),
    .errou_out ( errou ),
    .db_estado( db_estado_fio ),
	.db_timeout_uc( db_timeout_fio ),
    .limpaM( limpaM_fio ),
    .registraM( registraM_fio ),
    .zera_timer_leds( zera_timer_leds_fio ),
    .conta_timer_leds( conta_timer_leds_fio ),
    .fim_timer_leds( fim_timer_leds_fio )
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

hexa7seg HEX4(
    .hexa( db_limite_fio ),
    .display( db_limite )
);

estado7seg HEX(
    .estado( db_estado_fio ),
    .display( db_estado )
);

assign db_timeout = db_timeout_fio;
assign db_igual = igual;
assign db_clock = clock;

endmodule