`timescale 1ns / 1ps

module TWINE_ENCRYPT (
    output        load_encrypt,
    output reg [63:0] ciphertext = 64'h0,
    input  [63:0] plaintext,
    input  [79:0] key,
    input         load,
    input         clk
);

wire [79:0] kreg;
reg  [63:0] dreg;
wire [5:0]  round;
wire [63:0] dat1, dat2, dat3;
reg load_encrypt_reg;
wire [63:0] odat;

gen_key_1_to_36 generate_key (.key(key), .kreg(kreg), .round(round), .load(load), .clk(clk));

assign load_encrypt = (round == 0) ? 1 : 0;
always @(posedge clk) begin
   load_encrypt_reg <= load_encrypt;
end

wire [31:0] rk;
assign rk = {kreg[75:72], kreg[67:64], kreg[63:60], kreg[55:52],
             kreg[27:24], kreg[23:20], kreg[19:16], kreg[15:12]}; // RK^i

wire [3:0] sbox_out [0:7];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin: sbox_loop
        Sbox_Encrypt SBOX (.odat(sbox_out[i]), .plaintext((dreg[63-2*i*4 -: 4] ^ rk[31-i*4 -: 4])));
        assign dat1[63-(2*i+1)*4 -: 4] = sbox_out[i] ^ dreg[63-(2*i+1)*4 -: 4]; 
        assign dat1[63-2*i*4 -: 4] = dreg[63-2*i*4 -: 4]; 
    end
endgenerate

Pibox_Encrypt UPBOX (.odat(dat3), .plaintext(dat1));
assign odat = (round == 36) ? dat1 : dat3; 

always @(posedge clk) begin
   if (load)
      dreg <= plaintext;
   else
      dreg <= odat;
end

always @(posedge clk) begin
   if (round == 0 && load_encrypt && !load_encrypt_reg)
      ciphertext <= dreg;
end
endmodule