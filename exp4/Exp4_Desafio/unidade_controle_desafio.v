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
    input      iniciar,
    input      fim,
    input      jogada,
    input      igual,
    input      fim_timer,
    output reg zeraC,
    output reg contaC,
    output reg zeraR,
    output reg zera_timer,
    output reg registraR,
    output reg acertou_out,
    output reg errou_out,
    output reg pronto,
    output reg [6:0] db_timeout,
    output reg [3:0] db_estado
);

    // Define estados
    parameter inicial    = 4'b0000;  // 0
    parameter preparacao = 4'b0001;  // 1

    parameter espera     = 4'b0011;  // 3
    parameter registra   = 4'b0100;  // 4
    parameter comparacao = 4'b0101;  // 5
    parameter proximo    = 4'b0110;  // 6

    parameter timeout   = 4'b0111;  // 7
    parameter errou      = 4'b1101;  // D
    parameter acertou    = 4'b1111;  // F

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

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
            inicial:     Eprox = iniciar ? preparacao : inicial;
            preparacao:  Eprox = espera;
            espera:      Eprox = (~fim_timer && ~jogada) ? espera : (fim_timer) ? timeout : registra; //jogada ? registra : espera;
            registra:    Eprox = comparacao;    
            comparacao:  Eprox = (fim && igual) ? acertou : (~igual) ? errou : proximo;
            proximo:     Eprox = espera;
            timeout:    Eprox = iniciar ? preparacao : timeout;
            errou:       Eprox = iniciar ? preparacao : errou;
            acertou:     Eprox = iniciar ? preparacao : acertou;
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraC     = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraR     = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zera_timer = (Eatual == preparacao || Eatual == proximo) ? 1'b1 : 1'b0;
        registraR = (Eatual == registra) ? 1'b1 : 1'b0;
        contaC    = (Eatual == proximo) ? 1'b1 : 1'b0;
        pronto    = (Eatual == acertou || Eatual == errou || Eatual == timeout) ? 1'b1 : 1'b0;
        db_timeout = (Eatual == timeout) ? 7'b0001111 : 8'b0;
        acertou_out = (Eatual == acertou) ? 1'b1 : 1'b0;
        errou_out = (Eatual == errou) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:     db_estado = 4'b0000;  // 0
            preparacao:  db_estado = 4'b0001;  // 1
            espera:      db_estado = 4'b0011;  // 3
            registra:    db_estado = 4'b0100;  // 4
            comparacao:  db_estado = 4'b0101;  // 5
            proximo:     db_estado = 4'b0110;  // 6
            time_out:    db_estado = 4'b0111;  // 7
            errou:       db_estado = 4'b1110;  // E
            acertou:     db_estado = 4'b1010;  // A
            default:     db_estado = 4'b1111;  // F
        endcase
    end

endmodule