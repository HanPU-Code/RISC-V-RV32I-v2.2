`timescale 1ns / 1ps

module rv32_regfile #(
    parameter XLEN  = 32,       // WORD length
    parameter NR    = 32,       // # of Register
    parameter ADDR_W    = 5     // address bit width, log2(32) = 5
)(
    input                   clk_i       ,
    input                   rst_n       ,

    // write port
    input                   we_i        ,   // write enable
    input   [ADDR_W-1:0]    waddr_i     ,   // write address
    input   [XLEN-1:0]      wdata_i     ,   // data for write

    // read port A
    input   [ADDR_W-1:0]    raddr_a_i   ,   // read A address
    output  [XLEN-1:0]      rdata_a_o   ,   // data A

    input   [ADDR_W-1:0]    raddr_b_i   ,   // read B address
    output  [XLEN-1:0]      rdata_b_o       // data B
    );

    // 32x32 reg array
    reg [XLEN-1:0]  reg_file [0:NR-1];

    integer i;
    always @(posedge clk_i) begin
        if (!rst_n) begin
            for (i = 0; i < NR; i = i + 1) begin
                reg_file[i] <= {XLEN{1'b0}};
            end
        end
        else if (we_i && waddr_i != 0) begin
            reg_file[waddr_i] <= wdata_i;
        end
    end

    assign rdata_a_o = (we_i && (waddr_i == raddr_a_i) && (waddr_i != 0)) ? wdata_i :
                        (raddr_a_i == 0) ? {XLEN{1'b0}} : reg_file[raddr_a_i];

    assign rdata_b_o = (we_i && (waddr_i == raddr_b_i) && (waddr_i != 0)) ? wdata_i :
                        (raddr_b_i == 0) ? {XLEN{1'b0}} : reg_file[raddr_b_i];


endmodule
