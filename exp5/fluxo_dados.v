module fluxo_dados (
    input         clock,
    input  [3:0]  chaves,
    input         zeraR,
    input         registraR,
    input         contaE,
    input         zeraE,
    input         zera_timer,
    input         conta_timer,
    input         contaL,
    input         zeraL,
	 input			sel_nivel,
    output        igual,
    output        fimE,
    output        fim_timer,
    output        jogada_feita,
    output        fim_sequencia,
    output        ultima_sequencia,
    output        db_endmenorquelimite,
    output        db_tem_jogada,
    output [3:0]  db_limite, // sinal de depuracao para identificar o limite atual
    output [3:0]  db_jogada,
    output [3:0]  db_contagem,
    output [3:0]  db_memoria
);

    wire   [3:0] s_endereco;  // sinal interno para interligacao dos componentes
	  wire   [3:0] s_limite;
    wire   [3:0] s_dado;
    wire   [3:0] s_chaves;
	 wire fim, meio;
	 
    

    // contador_163
    contador_163 contador_endereco ( 
      .clock( clock ),
      .clr  ( ~zeraE ),
      .ld   ( 1'b1 ),
      .ent  ( 1'b1 ),
      .enp  ( contaE ),
      .D    ( 4'b0 ),
      .Q    ( s_endereco ),
      .rco  ( fimE )
    );

    // comparador_85 jogada
    comparador_85 comparadorjogada (
      .A   ( s_dado ),
      .B   ( s_chaves ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( menor ),
      .AGBo( maior ),
      .AEBo( igual )
    );

    // contador_m limite
    contador_m #(.M(16), .N(4)) contador_limite  (
      .clock( clock ),
      .zera_s  ( zeraL ),
		.zera_as(1'b0),
		.conta(contaL),
      .Q    ( s_limite ),
      .fim  ( fim ),
		.meio ( meio )
    );
	 
	 mux2x1 seletor_nivel(
		.D0( meio ),
		.D1( fim ),
		.SEL(sel_nivel),
		.OUT(ultima_sequencia)
	);


    //comparador_85 limite
    comparador_85 comparadorlimite(
      .A   ( s_limite ),
      .B   ( s_endereco ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( db_endmenorquelimite ), // sinal de depuracao pra colocar no analog display
      .AGBo( maiorquelim ),
      .AEBo( fim_sequencia )
    );
	 
    //Reg
    registrador_4 registrador(
    .clock( clock ),
    .clear( zeraR ),
    .enable( registraR ),
    .Q( s_chaves ),
    .D( chaves )
   );

    //Memória
    sync_rom_16x4 memoria(
     .clock( clock ),
     .address( s_endereco ),
     .data_out( s_dado )
    );

    // Edge detector
    edge_detector detector( 
      .clock( clock ),
      .reset( ~chaves[3] & ~chaves[2] & ~chaves[1] & ~chaves[0] ),
      .sinal( chaves[3] | chaves[2] | chaves[1] | chaves[0] ),
      .pulso( s_jogada )
    );

    //contador timeout
    contador_m #(.M(5000), .N(13)) contador_timeout (
        .clock(clock),
        .zera_as(1'b0),
        .zera_s(zera_timer),
        .fim(fim_timer),
        .conta(conta_timer),
        .Q(),
        .meio()
    );

    assign db_memoria = s_dado;
    assign db_jogada = s_chaves;
    assign db_limite = s_limite;
    assign db_contagem = s_endereco;
    assign db_tem_jogada = chaves[3] | chaves[2] | chaves[1] | chaves[0];
    assign jogada_feita = s_jogada;
 endmodule