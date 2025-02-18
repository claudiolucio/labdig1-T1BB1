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
module exp3_unidade_controle_desafio (
    input      clock,
    input      reset,
    input      iniciar,
    input      fimC,
    input chavesIgualMemoria,
    output reg zeraC,
    output reg contaC,
    output reg zeraR,
    output reg registraR,
    output reg pronto,
    output reg acertou_out,
    output reg errou_out,
    output reg [3:0] db_estado
);

    // Define estados
    parameter inicial    = 4'b0000;  // 0
    parameter preparacao = 4'b0001;  // 1
    parameter registra   = 4'b0100;  // 4
    parameter comparacao = 4'b0101;  // 5
    parameter proximo    = 4'b0110;  // 6

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
            preparacao:  Eprox = registra;
            registra:    Eprox = comparacao;    
            comparacao:  Eprox = (fimC && chavesIgualMemoria) ? acertou : (~chavesIgualMemoria) ? errou : proximo;
            proximo:     Eprox = registra;
            errou:       Eprox = inicial;
            acertou:     Eprox = inicial;
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraC     = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraR     = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraR = (Eatual == registra) ? 1'b1 : 1'b0;
        contaC    = (Eatual == proximo) ? 1'b1 : 1'b0;
        pronto    = (Eatual == acertou || Eatual == errou) ? 1'b1 : 1'b0;
        acertou_out = (Eatual == acertou) ? 1'b1 : 1'b0;
        errou_out = (Eatual == errou) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:     db_estado = 4'b0000;  // 0
            preparacao:  db_estado = 4'b0001;  // 1
            registra:    db_estado = 4'b0100;  // 4
            comparacao:  db_estado = 4'b0101;  // 5
            proximo:     db_estado = 4'b0110;  // 6
            errou:       db_estado = 4'b1101;  // D
            acertou:     db_estado = 4'b1111;  // F
            default:     db_estado = 4'b1110;  // E (erro)
        endcase
    end

endmodule