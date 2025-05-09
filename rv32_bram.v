`timescale 1ns/1ps

module rv32_bram #(
  parameter DEPTH_WORDS = 4096,   // 4 KiB
  parameter INIT_FILE   = ""      // HEX/COE 파일 경로 (옵션)
)(
  input  wire         clk,
  input  wire         rst_n,
  input  wire  [3:0]  we,       // byte write-enable
  input  wire [31:0]  addr,     // byte address
  input  wire [31:0]  wd,       // write data
  output reg  [31:0]  rd        // read  data
);

  /* ----- 메모리 배열 ----- */
  localparam ADDR_W = $clog2(DEPTH_WORDS);        // 워드 주소 폭
  reg [31:0] mem [0:DEPTH_WORDS-1];

  /* ----- 초기화 (시뮬 / FPGA 비트스트림) ----- */
`ifndef SYNTHESIS
  initial begin
    if (INIT_FILE != "") begin
      $display("DMEM init from %s", INIT_FILE);
      $readmemh(INIT_FILE, mem);
    end
  end
`endif

  /* ----- 메모리 접근 ----- */
  wire [ADDR_W-1:0] waddr = addr[ADDR_W+1:2];     // 워드 인덱스

  always @(posedge clk) begin
    /* Write : 바이트 인에이블 */
    if (we[0]) mem[waddr][ 7: 0] <= wd[ 7: 0];
    if (we[1]) mem[waddr][15: 8] <= wd[15: 8];
    if (we[2]) mem[waddr][23:16] <= wd[23:16];
    if (we[3]) mem[waddr][31:24] <= wd[31:24];

    /* Read (동기 1-cycle) */
    rd <= mem[waddr];

    /* 선택적 동기 리셋 : RD만 0으로 */
    if (!rst_n)
      rd <= 32'b0;
  end

endmodule
