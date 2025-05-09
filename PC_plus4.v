`timescale 1ns / 1ps

module PC_plus4(
    input   wire    [31:0]      pc_i    ,
    output  reg     [31:0]      pc_plus4_o
    );

    always @(*) begin
        pc_plus4_o <= pc_i + 32'h0000_0004;
    end
endmodule
