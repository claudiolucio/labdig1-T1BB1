`timescale 1ns/1ns

module circuito_exp3_desafio_tb;

    // Sinais para conectar com o DUT
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] chaves_in  = 4'b0000;
    wire       pronto_out;
    wire       db_igual_out;
    wire       db_iniciar_out;
    wire       acertou_out;
    wire       errou_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_chaves_out;
    wire [6:0] db_estado_out;

    // Configura��o do clock
    parameter clockPeriod = 20; // em ns, f=50MHz

    // Identifica��o do caso de teste
    reg [31:0] caso;

    // Array para armazenar valores esperados da ROM
    reg [3:0] memoria [0:15];

    // Vari�vel auxiliar para la�os
    integer i;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Instancia��o do DUT (Device Under Test)
    circuito_exp3_desafio dut (
        .clock      ( clock_in        ),
        .reset      ( reset_in        ),
        .iniciar    ( iniciar_in      ),
        .chaves     ( chaves_in       ),
        .pronto     ( pronto_out      ),
        .db_igual   ( db_igual_out    ),
        .db_iniciar ( db_iniciar_out  ),
        .acertou    ( acertou_out     ),
        .errou      ( errou_out       ),
        .db_contagem( db_contagem_out ),
        .db_memoria ( db_memoria_out  ),
        .db_chaves  ( db_chaves_out   ),
        .db_estado  ( db_estado_out   )
    );

    // Inicializa��o do array de mem�ria
    initial begin
        memoria[0] = 4'b0001; memoria[1] = 4'b0010; memoria[2] = 4'b0100; memoria[3] = 4'b1000;
        memoria[4] = 4'b0100; memoria[5] = 4'b0010; memoria[6] = 4'b0001; memoria[7] = 4'b0001;
        memoria[8] = 4'b0010; memoria[9] = 4'b0010; memoria[10] = 4'b0100; memoria[11] = 4'b0100;
        memoria[12] = 4'b1000; memoria[13] = 4'b1000; memoria[14] = 4'b0001; memoria[15] = 4'b0100;
    end

    // Gera��o dos sinais de entrada (est�mulos)
    initial begin
        $display("Inicio da simulacao");

        // Condi��es iniciais
        caso       = 0;
        clock_in   = 1;
        reset_in   = 0;
        iniciar_in = 0;
        chaves_in  = 4'b0000;
        #(2 * clockPeriod);

        // Caso 1: Reset inicial
        caso = 1;
        @(negedge clock_in);
        reset_in = 1;
        #(2 * clockPeriod);
        reset_in = 0;
        #(2 * clockPeriod);

        // Caso 2: Iniciar
        @(negedge clock_in);
        chaves_in = memoria[0];
        iniciar_in = 1; // Pulso em iniciar
        #(clockPeriod);
        iniciar_in = 0;
        #(3 * clockPeriod); // Aguardar processamento

        // Caso 2: Testar sequ�ncia completa com valores corretos
        for (i = 1; i < 16; i = i + 1) begin
            caso = i + 2;
            @(negedge clock_in);
            chaves_in = memoria[i];
            #(3 * clockPeriod); // Aguardar processamento
        end

        // Final dos casos de teste
        caso = 99;
        #(4 * clockPeriod);
        $display("Fim da simulacao");
        $stop;
    end

    // Monitor de sinais
    always @(negedge clock_in) begin
        $display("Caso %d - Time %0d ms: Estado=%h reset=%b iniciar=%b chaves=%b pronto=%b acertou=%b errou=%b",
                 caso, $time, db_estado_out[3:0], reset_in, iniciar_in, chaves_in, pronto_out, acertou_out, errou_out);
    end

endmodule

