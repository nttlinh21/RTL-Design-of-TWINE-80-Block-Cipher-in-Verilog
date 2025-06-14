`timescale 1ns / 1ps

module TWINE_DECRYPT (
    output        load_decrypt,
    output reg [63:0] plaintext = 64'h0,
    input  [63:0] ciphertext,
    input  [79:0] key,
    input         load,
    input         clk
);

wire [79:0] kreg;
reg  [63:0] dreg;
wire [5:0]  round;
reg  [5:0]  round_reg;
wire [63:0] dat1, dat3;
wire [63:0] odat;

gen_key_36_to_1 generate_key_decrypt (.key(key), .kreg(kreg), .round(round), .load(load), .clk(clk));

assign load_decrypt = (round_reg == 1) ? 1 : 0;

wire [31:0] rk;
assign rk = {kreg[75:72], kreg[67:64], kreg[63:60], kreg[55:52],
             kreg[27:24], kreg[23:20], kreg[19:16], kreg[15:12]}; // RK^i

wire [3:0] sbox_out [0:7];

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin: sbox_loop
        Sbox_Decrypt SBOX (.odat(sbox_out[i]), .ciphertext((dreg[63-2*i*4 -: 4] ^ rk[31-i*4 -: 4])));
        assign dat1[63-(2*i+1)*4 -: 4] = sbox_out[i] ^ dreg[63-(2*i+1)*4 -: 4]; 
        assign dat1[63-2*i*4 -: 4] = dreg[63-2*i*4 -: 4]; 
    end
endgenerate

Pibox_Decrypt UPBOX (.odat(dat3), .ciphertext(dat1));
assign odat = (round == 1) ? dat1 : dat3; 

always @(posedge clk) begin
    if (load) 
        dreg <= ciphertext;
    else if (round > 0)
        dreg <= odat;
end

always @(posedge clk) begin
    if (round == 0)
        plaintext <= dreg;
end

always @(posedge clk) begin
    round_reg <= round;
end

endmodule