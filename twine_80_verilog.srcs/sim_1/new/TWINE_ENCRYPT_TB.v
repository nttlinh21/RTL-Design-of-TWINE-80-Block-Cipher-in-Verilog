`timescale 1ns/1ps

`define PLAINTEXT1 64'h0123456789ABCDEF
`define KEY1 80'h00112233445566778899
`define CIPHERTEXT1 64'h7C1F0F80b1DF9C28

module TWINE_ENCRYPT_TB;

wire        load_encrypt;
wire [63:0] ciphertext;
reg [63:0] plaintext;
reg [79:0] key;
reg load;
reg clk;

// Initialize signals
initial begin
    plaintext = 64'h0;
    key = 80'h0;
    load = 1'b0;
    clk = 1'b0;
end

TWINE_ENCRYPT dut (.load_encrypt(load_encrypt), .ciphertext(ciphertext), 
                   .plaintext(plaintext), .key(key), .load(load), .clk(clk));

always #5 clk = ~clk;

initial begin

    @(posedge clk);

    #1; 
    load = 1'b1;
    plaintext = `PLAINTEXT1;
    key = `KEY1;
  
    @(posedge clk);
    #1;
    load = 1'b0;

    wait(load_encrypt);

    #20;
 
    if (ciphertext == `CIPHERTEXT1) begin
        $display("Test 1 PASSED: ciphertext = %h, expected = %h", ciphertext, `CIPHERTEXT1);
    end else begin
        $display("Test 1 FAILED: ciphertext = %h, expected = %h", ciphertext, `CIPHERTEXT1);
    end

    #20 $finish;
end

always @(posedge clk) begin
    if (dut.round >= 1 && dut.round <= 36) begin
        $display("Time=%0t, Round=%d, RK^i=%h, kreg=%h, dreg=%h",
                 $time, dut.round, dut.rk, dut.generate_key.kreg, dut.dreg );
    end
end

endmodule