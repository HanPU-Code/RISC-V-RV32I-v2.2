`timescale 1ns/1ps

module rv32_inst_mem #(
    parameter DEPTH = 1024,               // # of WORD
    parameter HEX_FILE = "code.hex"
)(
    input  [31:0]       A,               // Byte addr
    input               EN,
    output [31:0]       RD
);
    // 32 × DEPTH memonry
    reg [31:0] rom [0:DEPTH-1];
    reg [31:0] rd_q;

    assign RD = rd_q;

    always @(*)
        if (EN)
            rd_q <= rom[A[31:2]];        // 4-byte 

    // initialization (HEX file)
    initial $readmemh(HEX_FILE, rom);
endmodule
