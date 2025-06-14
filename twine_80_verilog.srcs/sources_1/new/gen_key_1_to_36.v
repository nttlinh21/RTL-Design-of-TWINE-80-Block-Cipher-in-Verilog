`timescale 1ns / 1ps

module gen_key_1_to_36(
    input  [79:0] key,   
    output reg [79:0] kreg,
    output reg [5:0]  round,
    input         load,   
    input         clk
);
    
    wire [79:0] kdat_pre, kdat_post;
    wire [3:0] sbox_out0, sbox_out1;
    wire [5:0] con_value;

    CON_Table con_table (.round(round), .con_value(con_value));

    Sbox_Encrypt S_box_0 (.odat(sbox_out0), .plaintext(kreg[79:76])); // S(WK_0)
    Sbox_Encrypt S_box_1 (.odat(sbox_out1), .plaintext(kreg[15:12])); // S(WK_16)

    // Pre-rotation key update
    assign kdat_pre[79:76] = kreg[79:76]; // WK_0
    assign kdat_pre[75:72] = kreg[75:72] ^ sbox_out0; // WK_1 ^= S(WK_0)
    assign kdat_pre[71:64] = kreg[71:64]; 
    assign kdat_pre[63:60] = kreg[63:60] ^ sbox_out1; // WK_4 ^= S(WK_16) 
    assign kdat_pre[59:56] = kreg[59:56]; 
    assign kdat_pre[55:52] = kreg[55:52];
    assign kdat_pre[51:48] = kreg[51:48] ^ {1'b0, con_value[5:3]}; // WK_7 ^= (0 || CON_H^r)
    assign kdat_pre[47:4]  = kreg[47:4]; 
    assign kdat_pre[3:0]   = kreg[3:0] ^ {1'b0, con_value[2:0]};   // WK_19 ^= (0 || CON_L^r)

   
    wire [15:0] wk0_to_wk3_rotated;
    assign wk0_to_wk3_rotated[15:12] = kdat_pre[75:72]; // WK_0 = WK_1 (after XOR)
    assign wk0_to_wk3_rotated[11:8]  = kdat_pre[71:68]; // WK_1 = WK_2
    assign wk0_to_wk3_rotated[7:4]   = kdat_pre[67:64]; // WK_2 = WK_3
    assign wk0_to_wk3_rotated[3:0]   = kdat_pre[79:76]; // WK_3 = WK_0

 
    wire [79:0] kdat_after_wk0_wk3_rotation;
    assign kdat_after_wk0_wk3_rotation[79:64] = wk0_to_wk3_rotated; 
    assign kdat_after_wk0_wk3_rotation[63:0]  = kdat_pre[63:0];     


    wire [79:0] rot4 = {kdat_after_wk0_wk3_rotation[63:0], kdat_after_wk0_wk3_rotation[79:64]};

   
    wire [79:0] rot16;
    assign rot16[79:16] = rot4[79:16];   
    assign rot16[15:0]  = rot4[15:0];     

    assign kdat_post[79:0] = rot16[79:0]; 

    always @(posedge clk) begin
       if (load)
          kreg <= key;
       else if (round >= 1 && round < 36) 
          kreg <= kdat_post;
       else
          kreg <= kreg; 
    end

    always @(posedge clk) begin
       if (load)
          round <= 1;
       else if (round >= 1 && round < 36)
          round <= round + 1;
       else
          round <= 0;
    end
endmodule