module bht (
    input           clk,
    input           rst,
    input   [7:0]   tag,
    input   [7:0]   tagE,
    input           BranchE,
    input   [6:0]   OpE,
    output          PredictedF  // 预测结果有效
);
// 分支指令操作码
localparam BR_OP    = 7'b110_0011;

reg [1:0] Valid[ 255 : 0 ];

assign PredictedF = Valid[tag][1];

localparam STRONG_NT    = 2'b00;
localparam WEAKLY_NT    = 2'b01;
localparam WEAKLY_T     = 2'b10;
localparam STRONG_T     = 2'b11;

always @(posedge clk or posedge rst) begin
    if( rst ) begin
        for(integer i = 0; i < 256; i++) begin
            Valid[i] <= WEAKLY_NT;
        end
    end else begin
        if( OpE == BR_OP ) begin
            if(BranchE) begin   
                Valid[tagE] <= ( Valid[tagE] == STRONG_T  ) ? STRONG_T  : Valid[tagE] + 2'b01;
            end else begin
                Valid[tagE] <= ( Valid[tagE] == STRONG_NT ) ? STRONG_NT : Valid[tagE] - 2'b01;
            end
        end
    end
end

endmodule