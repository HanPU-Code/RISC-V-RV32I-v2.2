`timescale 1ns / 1ps

module rv32_extend(
    input   wire    [11:0]      imm_i ,
    output  reg     [31:0]      immExt_o
    );

    always @(*) begin
        immExt_o <= { {20{imm_i[11]}}, imm_i[11:0] };
    end
endmodule
