module btb(
    parameter ENTRY_NUM = 64    // BTB条目数量
)(
    input           clk,
    input   [31:0]  PCF,
    input   [31:0]  PCE,
    input   [31:0]  BrNPC,
    input           BranchE,
    output  [31:0]  PredictedPC,    // 预测结果
    output          PredictedE      // 预测结果有效
);
// 分支指令操作码
localparam BR_OP    = 7'b110_0011;

reg [31:0]  BranchInstrAddress[ ENTRY_NUM : 0 ];
reg [31:0]  BranchTargeAddress[ ENTRY_NUM : 0 ];
reg         Valid[ ENTRY_NUM : 0 ];
wire        Equal[ ENTRY_NUM : 0 ];



endmodule