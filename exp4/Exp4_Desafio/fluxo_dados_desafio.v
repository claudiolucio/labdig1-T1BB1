module fluxo_dados (
    input         clock,
    input  [3:0]  chaves,
    input         zeraR,
    input         registraR,
    input         contaC,
    input         zeraC,
    input         zera_timer,
    input         conta_timer,
    output        igual,
    output        fimC,
    output        fim_timer,
    output        jogada_feita,
    output        db_tem_jogada,
    output [3:0]  db_jogada,
    output [3:0]  db_contagem,
    output [3:0]  db_memoria
);

    wire   [3:0] s_endereco;  // sinal interno para interligacao dos componentes
	wire   [3:0] s_dado;
    wire   [3:0] s_chaves;
    

    // contador_m
    contador_163 contador ( 
      .clock( clock ),
      .clr  ( ~zeraC ),
      .ld   ( 1'b1 ),
      .ent  ( 1'b1 ),
      .enp  ( contaC ),
      .D    ( 4'b0 ),
      .Q    ( s_endereco ),
      .rco  ( fimC )
    );

    // comparador_85
    comparador_85 comparador (
      .A   ( s_dado ),
      .B   ( s_chaves ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( menor ),
      .AGBo( maior ),
      .AEBo( igual )
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
    contador_m #(.M(3000), .N(12)) contador_timeout (
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
    assign db_contagem = s_endereco;
    assign db_tem_jogada = chaves[3] | chaves[2] | chaves[1] | chaves[0];
    assign jogada_feita = s_jogada;
 endmodule