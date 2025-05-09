`timescale 1ns / 1ps

module rv32_alu(
    input   wire    [31:0]      srcA_i      ,
    input   wire    [31:0]      srcB_i      ,
    input   wire    [2:0]       alu_ctrl_i  ,
    output  wire    [3:0]       alu_flg_o   ,
    output  reg     [31:0]      alu_rslt_o
    );

    wire    [31:0]  muxB_w;
    wire    [31:0]  sum_w;
    wire            c_out;

    wire    [31:0]  op_rslt;
    wire    [31:0]  and_rslt;
    wire    [31:0]  or_rslt;
    wire    [31:0]  slt_rslt;

    wire    flg_N, flg_Z, flg_C, flg_V;

    assign muxB_w = alu_ctrl_i[0] ? ~srcB_i : srcB_i;
    assign {c_out, op_rslt} = srcA_i + muxB_w + alu_ctrl_i[0]; // alu_ctrl_i[0] is c_in
    assign and_rslt = srcA_i & srcB_i;
    assign or_rslt = srcA_i | srcB_i;
    assign slt_rslt = {{31{1'b0}}, (flg_V ^ op_rslt[31])};

    assign flg_Z = ~|alu_rslt_o;
    assign flg_N = alu_rslt_o[31];
    assign flg_C = c_out & (~alu_ctrl_i[1]);
    assign flg_V = (~(srcA_i[31] ^ srcB_i[31] ^ alu_ctrl_i[0])) & (op_rslt[31] ^ srcA_i[31]) & (~alu_ctrl_i[1]);

    assign alu_flg_o = {flg_N, flg_Z, flg_C, flg_V};

    always @(*) begin
        case (alu_ctrl_i)
            3'b000: alu_rslt_o <= op_rslt; 
            3'b001: alu_rslt_o <= op_rslt; 
            3'b010: alu_rslt_o <= and_rslt; 
            3'b011: alu_rslt_o <= or_rslt; 
            3'b101: alu_rslt_o <= slt_rslt;
            default: alu_rslt_o <= 32'bZ;
        endcase
    end
    
endmodule
