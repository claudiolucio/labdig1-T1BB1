//------------------------------------------------------------------
// Arquivo   : exp3_unidade_controle.v
// Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle
//------------------------------------------------------------------
// Descricao : Unidade de controle
//
// usar este codigo como template (modelo) para codificar 
// máquinas de estado de unidades de controle            
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/01/2024  1.0     Edson Midorikawa  versao inicial
//     12/01/2025  1.1     Edson Midorikawa  revisao
//------------------------------------------------------------------
//
module unidade_controle (
    input      clock,
    input      reset,
    input      jogar,
    input      fim,
    input      jogada,
    input      igual,
    input      fim_timer,
    input      fim_timer_leds,
    input      fim_sequencia,
    input      ultima_sequencia,
    output reg zeraE,
    output reg contaE,
    output reg zeraR,
    output reg zera_timer,
    output reg conta_timer,
    output reg conta_timer_leds,
    output reg zera_timer_leds,
    output reg registraM,
    output reg limpaM,
    output reg registraR,
    output reg acertou_out,
    output reg errou_out,
    output reg pronto,
    output reg contaL,
    output reg zeraL,
    output reg [6:0] db_timeout_uc,
    output reg [4:0] db_estado
);

    // Define estados     
    parameter inicial    = 5'b00000; // 0
    parameter preparacao = 5'b00001; // 1

    parameter inicia_sequencia = 5'b00010; // 2
	 
	 parameter carrega_dados = 5'b00011; // 3
	 parameter mostra_dado = 5'b00100; // 4
	 parameter zera_leds = 5'b00101; // 5
	 parameter mostra_apagado = 5'b00110; // 6
	 parameter proxima_posicao = 5'b00111; // 7
	 
    parameter espera     = 5'b01000;  // 8
    parameter registra   = 5'b01001;  // 9
    parameter comparacao = 5'b10000;  // 10
    parameter proxima_jogada = 5'b01011;  // B

    parameter avalia_sequencia = 5'b01100;  // C
    parameter proxima_sequencia = 5'b01101;  // D

    parameter timeout   = 5'b01111; // F
    parameter errou      = 5'b01110;  // E
    parameter acertou    = 5'b01010;  // A

    // Variaveis de estado
    reg [4:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial:                Eprox = jogar ? preparacao : inicial;
            preparacao:             Eprox = inicia_sequencia;

            inicia_sequencia:       Eprox = carrega_dados;
            
            carrega_dados:           Eprox = mostra_dado;
            mostra_dado:            Eprox = fim_timer_leds? zera_leds : mostra_dado;
            zera_leds:              Eprox = mostra_apagado;
            mostra_apagado:         Eprox = (~fim_timer_leds) ? mostra_apagado : (fim_timer_leds && fim_sequencia) ? espera : proxima_posicao; 
            proxima_posicao:        Eprox = carrega_dados;

            espera:                 Eprox = (~fim_timer && ~jogada) ? espera : (fim_timer) ? timeout : registra; 
            registra:               Eprox = comparacao;    
            comparacao:             Eprox = (fim_sequencia && igual) ? avalia_sequencia : (~igual) ? errou : proxima_jogada;
            proxima_jogada:         Eprox = espera;
            
            avalia_sequencia:       Eprox = ultima_sequencia ? acertou : proxima_sequencia;
            proxima_sequencia:      Eprox = inicia_sequencia;

            timeout:                Eprox = jogar ? preparacao : timeout;
            errou:                  Eprox = jogar ? preparacao : errou;
            acertou:                Eprox = jogar ? preparacao : acertou;
            default:                Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraE               = (Eatual == inicial || Eatual == inicia_sequencia) ? 1'b1 : 1'b0;
        zeraR               = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraL               = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zera_timer          = (Eatual == inicia_sequencia || Eatual == proxima_jogada) ? 1'b1 : 1'b0;
        conta_timer         = (Eatual == espera) ? 1'b1 : 1'b0;
        registraR           = (Eatual == registra) ? 1'b1 : 1'b0;
        contaE              = (Eatual == proxima_posicao) ? 1'b1 : 1'b0;
        contaL              = (Eatual == proxima_sequencia ) ? 1'b1 : 1'b0;
        pronto              = (Eatual == acertou || Eatual == errou || Eatual == timeout) ? 1'b1 : 1'b0;
        db_timeout_uc       = (Eatual == timeout) ? 7'b0000111 : 7'b1111111;
        acertou_out         = (Eatual == acertou) ? 1'b1 : 1'b0;
        errou_out           = (Eatual == errou) ? 1'b1 : 1'b0;
        zera_timer_leds     = (Eatual == carrega_dados || Eatual == zera_leds )? 1'b1 : 1'b0;
        conta_timer_leds    = (Eatual == mostra_dado || Eatual == mostra_apagado ) ? 1'b1 : 1'b0;
        registraM           = (Eatual == carrega_dados ) ? 1'b1 : 1'b0;
        limpaM              = (Eatual == zera_leds ) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:            db_estado = 5'b00000;  // 0
            preparacao:         db_estado = 5'b00001;  // 1
            inicia_sequencia:   db_estado = 5'b00010;  // 2
            carrega_dados:      db_estado = 5'b00011; // 3
	        mostra_dado:        db_estado = 5'b00100; // 4
	        zera_leds:          db_estado = 5'b00101; // 5
	        mostra_apagado:     db_estado = 5'b00110; // 6
	        proxima_posicao:    db_estado = 5'b00111; // 7
            espera:             db_estado = 5'b01000;  // 8
            registra:           db_estado = 5'b01001;  // 9
            comparacao:         db_estado = 5'b10000;  // 10
            proxima_jogada:     db_estado = 5'b01011;  // B
            avalia_sequencia:   db_estado = 5'b01100;  // C    
            proxima_sequencia:  db_estado = 5'b01101;  // D
            acertou:            db_estado = 5'b01010;  // A
            timeout:            db_estado = 5'b01111; // F           
            errou:              db_estado = 5'b01110;  // E
            default:            db_estado = 5'b11111;  // 1F
        endcase
    end

endmodule