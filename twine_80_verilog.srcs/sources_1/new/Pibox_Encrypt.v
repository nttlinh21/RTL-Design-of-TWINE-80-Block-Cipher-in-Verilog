`timescale 1ns/1ps

module Pibox_Encrypt(
   output [63:0] odat,
   input  [63:0] plaintext
);

assign odat[43:40] = plaintext [63:60] ; // pi[0] = 5
assign odat[63:60] = plaintext[59:56] ; // pi[1] = 0
assign odat[59:56] = plaintext[55:52]; // pi[2] = 1
assign odat[47:44] = plaintext[51:48]; // pi[3] = 4
assign odat[35:32] = plaintext[47:44];   // pi[4] = 7
assign odat[15:12] = plaintext[43:40]; // pi[5] = 12
assign odat[51:48] = plaintext[39:36]; // pi[6] = 3
assign odat[31:28] = plaintext[35:32]; // pi[7] = 8
assign odat[11:8] = plaintext[31:28]; // pi[8] = 13
assign odat[39:36] = plaintext[27:24];   // pi[9] = 6
assign odat[27:24] = plaintext[23:20]; // pi[10] = 9
assign odat[55:52] = plaintext[19:16]; // pi[11] = 2
assign odat[3:0] = plaintext[15:12]; // pi[12] = 15
assign odat[23:20] = plaintext[11:8]; // pi[13] = 10
assign odat[19:16] = plaintext[7:4];  // pi[14] = 11
assign odat[7:4] = plaintext[3:0]; // pi[15] = 14

endmodule