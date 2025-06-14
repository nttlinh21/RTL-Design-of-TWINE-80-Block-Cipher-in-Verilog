`timescale 1ns / 1ps

module gen_key_36_to_1(
    input  [79:0] key,   
    output reg [79:0] kreg,
    output reg [5:0]  round,
    input         load,   
    input         clk
);

wire [79:0] kreg_en;
wire [5:0] round_en;
gen_key_1_to_36 generate_key (.key(key), .kreg(kreg_en), .round(round_en), .load(load), .clk(clk));

reg [79:0] kreg_array [0:36];
reg [5:0] round_en_reg;

always @(posedge clk) begin
    round_en_reg <= round_en;
end

always @(posedge clk) begin
    kreg_array[round_en] <= kreg_en;
end

always @(posedge clk) begin
    if (load) begin
        round <= 0;
        kreg <= 0;
    end else if (round_en == 0 && round_en_reg == 36) begin
        kreg <= kreg_array[36];
        round <= 36;
    end else if (round > 1) begin
        kreg <= kreg_array[round - 1];
        round <= round - 1;
    end else if (round == 1) begin
        kreg <= kreg_array[0];
        round <= 0;
    end
end
endmodule