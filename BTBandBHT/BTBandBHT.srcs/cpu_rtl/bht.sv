module bht #(
    parameter ENTRY_NUM = 64    // BTB条目数量
)(
    input               clk,
    input               rst,
    input       [31:0]  PCF,
    input       [31:0]  PCE,
    // input       [31:0]  BrNPC,
    input               BranchE,
    input       [6:0]   OpE,
    // output  reg [31:0]  HistoryPredictedPC,    // 预测结果
    output  reg         HistoryPredictedF      // 预测结果有效
);
// 分支指令操作码
localparam BR_OP    = 7'b110_0011;
// HistoryBuffer
reg [31:0]  BranchInstrAddress[ ENTRY_NUM - 1 : 0 ];
// reg [31:0]  BranchTargeAddress[ ENTRY_NUM - 1 : 0 ];
// 上面这两个表原则上是和BTB中的表同步的

reg [1:0]   Valid[ ENTRY_NUM - 1 : 0 ];

reg [15:0]  Tail;   // 采用FIFO的替换策略

// 组合逻辑产生预测跳转地址
always @(*) begin
    if( rst ) begin
        HistoryPredictedF  <= 1'b0;
        // HistoryPredictedPC <= 32'b0;
    end else begin
        HistoryPredictedF  <= 1'b0;
        // HistoryPredictedPC <= 32'b0;
        for(integer i = 0; i < ENTRY_NUM; i++) begin
            if( (PCF == BranchInstrAddress[i]) && Valid[i][1] ) begin
                HistoryPredictedF  <= 1'b1;
                // HistoryPredictedPC <= BranchTargeAddress[i];
            end
        end
    end
end

localparam STRONG_NT    = 2'b00;
localparam WEAKLY_NT    = 2'b01;
localparam STRONG_T     = 2'b10;
localparam WEAKLY_T     = 2'b11;

// HistoryBuffer更新
always @(posedge clk or posedge rst) begin
    if( rst ) begin
        for(integer i = 0; i < ENTRY_NUM; i++) begin
            Valid[i]                <= WEAKLY_NT;
            BranchInstrAddress[i]   <= 32'd0;
            // BranchTargeAddress[i]   <= 32'd0;
        end
        Tail <= 16'd0;
    end else begin
        // EX段更新Buffer
        if( OpE == BR_OP ) begin
            integer i;
            for( i = 0; i < ENTRY_NUM; i++) begin
                if(PCE == BranchInstrAddress[i]) begin
                // 取指阶段在BTB查询命中
                    // BranchTargeAddress[i]   <= BrNPC;
                    if(BranchE) begin   
                        Valid[i] <= ( Valid[i] == STRONG_T  ) ? STRONG_T  : Valid[i] + 2'b01;
                    end else begin
                        Valid[i] <= ( Valid[i] == STRONG_NT ) ? STRONG_NT : Valid[i] - 2'b01;
                    end
                    break;
                end
            end
            if( i == ENTRY_NUM ) begin
            // 指阶段没有在BTB查询命中
                // BranchTargeAddress[Tail]    <= BrNPC;
                BranchInstrAddress[Tail]    <= PCE;
                if(BranchE) begin   
                    Valid[Tail] <= ( Valid[Tail] == STRONG_T  ) ? STRONG_T  : Valid[Tail] + 2'b01;
                end else begin
                    Valid[Tail] <= ( Valid[Tail] == STRONG_NT ) ? STRONG_NT : Valid[Tail] - 2'b01;
                end
                Tail <= Tail + 1;
            end
        end
    end
end

endmodule