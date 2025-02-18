module circuito_exp3_desafio (
 input clock,
 input reset,
 input iniciar,
 input [3:0] chaves,
 output pronto,
 output db_igual,
 output db_iniciar,
 output acertou,
 output errou,
 output [6:0] db_contagem,
 output [6:0] db_memoria,
 output [6:0] db_chaves,
 output [6:0] db_estado
);

wire zeraR, zeraC, contaC, registraR, chavesIgualMemoria, fimC; 
wire [3:0] db_chaves_fio, db_contagem_fio, db_memoria_fio, db_estado_fio;


exp3_fluxo_dados fd (
    .clock( clock ),
    .chaves( chaves ),
    .zeraR( zeraR ),
    .registraR( registraR ),
    .contaC( contaC ), 
    .zeraC( zeraC ),
    .chavesIgualMemoria( chavesIgualMemoria ),
    .fimC( fimC ),
    .db_contagem( db_contagem_fio ),
    .db_chaves( db_chaves_fio ),
    .db_memoria( db_memoria_fio )
);

exp3_unidade_controle_desafio uc(
    .clock( clock ),
    .reset( reset ),
    .iniciar( iniciar ), 
    .chavesIgualMemoria ( chavesIgualMemoria ),
    .fimC( fimC ),
    .zeraC( zeraC ),
    .contaC( contaC ),
    .zeraR( zeraR ),
    .registraR( registraR ),
    .pronto( pronto ),
    .acertou_out( acertou ),
    .errou_out( errou ),
    .db_estado( db_estado_fio )
);

hexa7seg HEX2(
    .hexa( db_chaves_fio ),
    .display( db_chaves )
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

assign db_igual = chavesIgualMemoria;
assign db_iniciar = iniciar;


endmodule