`timescale 1ns / 1ps

module CON_Table (
    input [5:0] round,   
    output reg [5:0] con_value  
);

always @(*) begin
    case (round)
        6'd1:  con_value = 6'h01;
        6'd2:  con_value = 6'h02;
        6'd3:  con_value = 6'h04;
        6'd4:  con_value = 6'h08;
        6'd5:  con_value = 6'h10;
        6'd6:  con_value = 6'h20;
        6'd7:  con_value = 6'h03;
        6'd8:  con_value = 6'h06;
        6'd9:  con_value = 6'h0C;
        6'd10: con_value = 6'h18;
        6'd11: con_value = 6'h30;
        6'd12: con_value = 6'h23;
        6'd13: con_value = 6'h05;
        6'd14: con_value = 6'h0A;
        6'd15: con_value = 6'h14;
        6'd16: con_value = 6'h28;
        6'd17: con_value = 6'h13;
        6'd18: con_value = 6'h26;
        6'd19: con_value = 6'h0F;
        6'd20: con_value = 6'h1E;
        6'd21: con_value = 6'h3C;
        6'd22: con_value = 6'h3B;
        6'd23: con_value = 6'h35;
        6'd24: con_value = 6'h29;
        6'd25: con_value = 6'h11;
        6'd26: con_value = 6'h22;
        6'd27: con_value = 6'h07;
        6'd28: con_value = 6'h0E;
        6'd29: con_value = 6'h1C;
        6'd30: con_value = 6'h38;
        6'd31: con_value = 6'h33;
        6'd32: con_value = 6'h25;
        6'd33: con_value = 6'h09;
        6'd34: con_value = 6'h12;
        6'd35: con_value = 6'h24;
        default: con_value = 6'h00; 
    endcase
end

endmodule