module bht #(
    parameter ENTRY_NUM = 64    // BTB条目数量
)(
    input               clk,
    input               rst,
    input       [31:0]  PCF,
    input       [31:0]  PCE,
    input       [31:0]  BrNPC,
    input               BranchE,
    input       [6:0]   OpE,
    output  reg [31:0]  PredictedPC,    // 预测结果
    output  reg         PredictedF      // 预测结果有效
);

endmodule