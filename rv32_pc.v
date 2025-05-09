`timescale 1ns / 1ps

module rv32_pc(
    input   wire           clk_i       ,
    input   wire           rst_n       ,
    input   wire   [31:0]  pc_next_i   ,
    output  reg    [31:0]  pc_o        
    );

    always @(posedge clk_i) begin
        if (!rst_n) begin
            pc_o <= 32'h0000_1000;
        end    
        else begin
            pc_o <= pc_next_i;
        end
    end
endmodule
