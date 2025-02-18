`timescale 1ns / 1ns

module circuito_exp5_tb_erro_rodada4;

    // Entradas
    reg clock;
    reg reset;
    reg iniciar;
    reg [3:0] chaves;

    // Saídas
    wire pronto;
    wire db_igual;
    wire acertou;
    wire errou;
    wire [3:0] leds;
    wire [6:0] db_timeout;
    wire [6:0] db_contagem;
    wire [6:0] db_memoria;
    wire [6:0] db_estado;
    wire [6:0] db_jogadafeita;
    wire [6:0] db_limite;
    wire db_tem_jogada;
    wire db_endmenorquelimite;
    wire db_clock;

    // DUT (Device Under Test)
    circuito_exp5 dut (
        .clock(clock),
        .reset(reset),
        .iniciar(iniciar),
        .chaves(chaves),
        .pronto(pronto),
        .db_igual(db_igual),
        .acertou(acertou),
        .errou(errou),
        .leds(leds),
        .db_timeout(db_timeout),
        .db_contagem(db_contagem),
        .db_memoria(db_memoria),
        .db_estado(db_estado),
        .db_jogadafeita(db_jogadafeita),
        .db_limite(db_limite),
        .db_tem_jogada(db_tem_jogada),
        .db_endmenorquelimite(db_endmenorquelimite),
        .db_clock(db_clock)
    );

    // ROM de jogadas (usada para fornecer entradas ao DUT)
    reg [3:0] rom_jogadas [0:15];
    integer i, jogadas_na_rodada, rodada;

    // Clock com 1kHz
    parameter clockPeriod = 1_000_000; 

    // ROM com as jogadas
    initial begin
        rom_jogadas[0]  = 4'b0001; // Jogada 1
        rom_jogadas[1]  = 4'b0010; // Jogada 2
        rom_jogadas[2]  = 4'b0100; // Jogada 3
        rom_jogadas[3]  = 4'b1000; // Jogada 4
        rom_jogadas[4]  = 4'b0100; // Jogada 5
        rom_jogadas[5]  = 4'b0010; // Jogada 6
        rom_jogadas[6]  = 4'b0001; // Jogada 7
        rom_jogadas[7]  = 4'b0001; // Jogada 8
        rom_jogadas[8]  = 4'b0010; // Jogada 9
        rom_jogadas[9]  = 4'b0010; // Jogada 10
        rom_jogadas[10] = 4'b0100; // Jogada 11
        rom_jogadas[11] = 4'b0100; // Jogada 12
        rom_jogadas[12] = 4'b1000; // Jogada 13
        rom_jogadas[13] = 4'b1000; // Jogada 14
        rom_jogadas[14] = 4'b0001; // Jogada 15
        rom_jogadas[15] = 4'b0100; // Jogada 16
    end
 
     always #((clockPeriod / 2)) clock = ~clock;

    // Testbench principal
    initial begin
        // Inicializa as entradas
        clock = 0;
        reset = 1;
        iniciar = 0;
        chaves = 4'b0000;

        // Aguarda e libera o reset
        #(clockPeriod * 10);
        reset = 0;

        // Inicia o circuito
        iniciar = 1;
        #(clockPeriod);
        iniciar = 0;

        // Aplica jogadas por rodada
        
        for (rodada = 1; rodada < 4; rodada = rodada + 1) begin
            jogadas_na_rodada = rodada;
            #(5 * clockPeriod);
            // Aplica as jogadas da rodada
            for (i = 0; i < jogadas_na_rodada; i = i + 1) begin
                chaves = rom_jogadas[i]; 
                #(5 * clockPeriod);
                chaves = 4'b0000; 
                #(5 * clockPeriod);
            end
        end

        // errando a rodada 4
        chaves = 4'b0001;
        #(5 * clockPeriod);
        chaves = 4'b0000;
        #(5 * clockPeriod);

        chaves = 4'b0010;
        #(5 * clockPeriod);
        chaves = 4'b0000;
        #(5 * clockPeriod);    

        chaves = 4'b0010; //erro
        #(5 * clockPeriod);
        chaves = 4'b0000;
        #(5 * clockPeriod);


        // Reinicia o jogo
        rodada = 1;
        iniciar = 1;
        #(5 * clockPeriod);
        iniciar = 0;
        #(20 * clockPeriod);

        // Final do testbench
      $display("fim da simulacao");
      $stop;
    end
endmodule