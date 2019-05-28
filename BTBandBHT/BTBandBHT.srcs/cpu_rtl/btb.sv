module btb #(
    parameter ENTRY_NUM = 64    // BTB条目数量
)(
    input               clk,
    input               rst,
    input       [31:0]  PCF,
    input       [31:0]  PCE,
    input       [31:0]  BrNPC,
    input               BranchE,
    input       [6:0]   OpE,
    output  reg [31:0]  PredictedPC,        // 预测结果
    output  reg         PredictedPCValid    // BTB Buffer命中
);
// 分支指令操作码
localparam BR_OP    = 7'b110_0011;
// Buffer
reg [31:0]  BranchInstrAddress[ ENTRY_NUM - 1 : 0 ];
reg [31:0]  BranchTargeAddress[ ENTRY_NUM - 1 : 0 ];

reg [15:0]  Tail;   // 采用FIFO的替换策略

// 组合逻辑产生预测跳转地址
always @(*) begin
    if( rst ) begin
        PredictedPCValid <= 1'b0;
        PredictedPC      <= 32'b0;
    end else begin
        PredictedPCValid <= 1'b0;
        PredictedPC      <= 32'b0;
        for(integer i = 0; i < ENTRY_NUM; i++) begin
            if( PCF == BranchInstrAddress[i] ) begin
                PredictedPCValid <= 1'b1;
                PredictedPC      <= BranchTargeAddress[i];
            end
        end
    end
end
// Buffer更新
always @(posedge clk or posedge rst) begin
    if( rst ) begin
        for(integer i = 0; i < ENTRY_NUM; i++) begin
            BranchInstrAddress[i]   <= 32'd0;
            BranchTargeAddress[i]   <= 32'd0;
        end
        Tail <= 16'd0;
    end else begin
        // EX段更新Buffer
        if( OpE == BR_OP && BranchE ) begin
            integer i;
            for( i = 0; i < ENTRY_NUM; i++) begin
                if(PCE == BranchInstrAddress[i]) begin
                    break;
                end
            end
            if( i == ENTRY_NUM ) begin
            // 如果队列中没有这一项
                BranchTargeAddress[Tail]    <= BrNPC;
                BranchInstrAddress[Tail]    <= PCE;
                Tail                        <= Tail + 1;
            end
        end
    end
end

endmodule