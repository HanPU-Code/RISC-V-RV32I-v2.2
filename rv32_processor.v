`timescale 1ns / 1ps

module rv32_processor(
    input   wire        clk_i,
    input   wire        rst_n
    );
    
    wire    [31:0]      pc_next_w;
    wire    [31:0]      pc_w;
    wire    [31:0]      instr_w;

    wire    [31:0]      data_a_w;

    wire    [31:0]      immExt_w;

    wire    [31:0]      alu_rslt_w;

    wire    [31:0]      rd_dmem_w;

    rv32_pc rv32_pc(
        .clk_i       (clk_i),
        .rst_n       (rst_n),
        .pc_next_i   (pc_next_w),
        .pc_o        (pc_w)
    );

    PC_plus4 PC_plus4(
        .pc_i       (pc_w),
        .pc_plus4_o (pc_next_w)
    );

    rv32_inst_mem #(
        .DEPTH      (4096),
        .HEX_FILE   ("C:/Users/hanyu/Desktop/code.hex")
    ) rv32_inst_mem (
        .A      (pc_w),               // Byte addr
        .EN     (1'b1),
        .RD     (instr_w)
    );

    rv32_regfile #(
        .XLEN       (32),       // WORD length
        .NR         (32),       // # of Register
        .ADDR_W     (5)     // address bit width, log2(32) = 5
    ) rv32_regfile (
        .clk_i       (clk_i),
        .rst_n       (rst_n),

    // write port
        .we_i        (1'b0),   // write enable
        .waddr_i     (instr_w[11:7]),   // write address
        .wdata_i     (rd_dmem_w),   // data for write

    // read port A
        .raddr_a_i   (instr_w[19:15]),   // read A address
        .rdata_a_o   (data_a_w),   // data A

        .raddr_b_i   (),   // read B address
        .rdata_b_o   ()   // data B
    );

    rv32_extend rv32_extend(
        .imm_i          (instr_w[31:20]),
        .immExt_o       (immExt_w)
    );

    rv32_alu rv32_alu(
        .srcA_i      (data_a_w),
        .srcB_i      (immExt_w),
        .alu_ctrl_i  (3'b000),
        .alu_flg_o   (),
        .alu_rslt_o  (alu_rslt_w)   
    );

    rv32_bram #(
        .INIT_FILE("C:/Users/hanyu/Desktop/dmem_init.hex")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
    ) rv32_bram (
        .clk        (clk_i),
        .rst_n      (rst_n),
        .we         (),       // byte write-enable
        .addr       (alu_rslt_w),     // byte address
        .wd         (),       // write data
        .rd         (rd_dmem_w)        // read  data
    );
endmodule
