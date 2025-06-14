`timescale 1ns/1ps

module Pibox_Decrypt(
   output [63:0] odat,
   input  [63:0] ciphertext
);

assign odat[59:56] = ciphertext[63:60]; // pi^-1[0] = 1
assign odat[55:52] = ciphertext[59:56]; // pi^-1[1] = 2
assign odat[19:16] = ciphertext[55:52]; // pi^-1[2] = 11
assign odat[39:36] = ciphertext[51:48]; // pi^-1[3] = 6
assign odat[51:48] = ciphertext[47:44]; // pi^-1[4] = 3
assign odat[63:60] = ciphertext[43:40]; // pi^-1[5] = 0
assign odat[27:24] = ciphertext[39:36]; // pi^-1[6] = 9
assign odat[47:44] = ciphertext[35:32]; // pi^-1[7] = 4
assign odat[35:32] = ciphertext[31:28]; // pi^-1[8] = 7
assign odat[23:20] = ciphertext[27:24];  // pi^-1[9] = 10
assign odat[11:8] = ciphertext[23:20]; // pi^-1[10] = 13
assign odat[7:4] = ciphertext[19:16];   // pi^-1[11] = 14
assign odat[43:40] = ciphertext[15:12]; // pi^-1[12] = 5
assign odat[31:28] = ciphertext[11:8];   // pi^-1[13] = 8
assign odat[3:0] = ciphertext[7:4]; // pi^-1[14] = 15
assign odat[15:12] = ciphertext[3:0]; // pi^-1[15] = 12

endmodule