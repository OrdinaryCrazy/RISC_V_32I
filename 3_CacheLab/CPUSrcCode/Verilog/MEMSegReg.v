//MEMSegReg�Ƿô�׶εĶμĴ������洢��ǰһ�׶�Alu������
module MEMSegReg(
    input wire clk,
    input wire rst,
    input wire en,
    //�����ź�
    input wire [31:0] AluOutE,
    output reg [31:0] AluOutM, 
    input wire [31:0] ForwardData2,
    output reg [31:0] StoreDataM, 
    input wire [4:0] RdE,
    output reg [4:0] RdM,
    input wire [31:0] PCE,
    output reg [31:0] PCM,
    //�����ź�
    input wire [2:0] RegWriteE,
    output reg [2:0] RegWriteM,
    input wire MemToRegE,
    output reg MemToRegM,
    input wire [3:0] MemWriteE,
    output reg [3:0] MemWriteM,
    input wire LoadNpcE,
    output reg LoadNpcM
    );
    //
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            AluOutM<=32'b0;
            StoreDataM<=32'b0;
            RdM<=5'b0;
            PCM<=32'b0;
            RegWriteM<=1'b0;
            MemToRegM<=1'b0;
            MemWriteM<=1'b0;
            LoadNpcM<=1'b0;   
        end
        else if(en)
        begin
        //�����ź�
            AluOutM<=AluOutE;
            StoreDataM<=ForwardData2;
            RdM<=RdE;
            PCM<=PCE;
            RegWriteM<=RegWriteE;
            MemToRegM<=MemToRegE;
            MemWriteM<=MemWriteE;
            LoadNpcM<=LoadNpcE;
        end
    end
    
endmodule