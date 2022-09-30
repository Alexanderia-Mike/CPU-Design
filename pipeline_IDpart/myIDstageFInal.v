module IDfinal(
    clock, IDEXFlush, IDRegWrite, IDEXRegWrite, IDMemtoReg, MemtoReg_EX,
    ALUSrc_ID,ALUSrc_EX,ALUOp_ID, ALUOp_EX, MemRead_ID, MemRead_EX,
    MemWrite_ID, MemWrite_EX, RegDst_ID, RegDst_EX,
    Readdata1_ID, Readdata2_ID, Readdata1_EX, Readdata2_EX,
    Signextend_ID, Signextend_EX, 
    Rs_ID, Rs_EX, Rt_ID, Rt_EX,Rd_ID, Rd_EX
);

input clock, IDEXFlush;
input IDRegWrite, IDMemtoReg, ALUSrc_ID, MemWrite_ID, RegDst_ID, MemRead_ID;
output reg IDEXRegWrite, MemtoReg_EX, ALUSrc_EX, MemWrite_EX, RegDst_EX, MemRead_EX;
input [1:0] ALUOp_ID;
output reg [1:0] ALUOp_EX;
input [31:0] Readdata1_ID, Readdata2_ID;
output reg [31:0] Readdata1_EX, Readdata2_EX;
input [31:0] Signextend_ID;
output reg [31:0] Signextend_EX;
input [4:0] Rs_ID, Rt_ID, Rd_ID;
output reg [4:0] Rs_EX, Rt_EX,Rd_EX;

// possibly used in connecting

// wire [31:0] instruction32;
// assign Rs_ID = instruction32_ID[25:21];
// assign Rt_ID = instruction32_ID[20:16];
// assign Rd_ID = instruction32_ID[15:11];

// Signextend sextend(instruction32[15:0], signExtended);
// assign JumpAddr={pcPlus4_ID[31:28], instruction32_ID[25:0], 2'b00};
// assign branch_judge=(((Branch_Beq == 1)&&(CompareData1==CompareData2))||((Branch_Bne == 1)&&(CompareData1 != CompareData2)));
// assign beqAddr=pcPlus4_ID+(signExtended<<2);

initial begin
    IDEXRegWrite = 1'b0;
    MemtoReg_EX = 1'b0; 
    ALUSrc_EX = 1'b0; 
    MemWrite_EX = 1'b0; 
    RegDst_EX = 1'b0; 
    MemRead_EX= 1'b0;
    ALUOp_EX = 2'b0;
    Rs_EX = 5'b0;
    Rt_EX = 5'b0;
    Rd_EX = 5'b0;
    Readdata1_EX = 32'b0;
    Readdata2_EX = 32'b0;
    Signextend_EX= 32'b0;
end

always @(posedge clock)
begin
    IDEXRegWrite <= (IDEXFlush == 1)? 0:IDRegWrite;
    MemtoReg_EX <= (IDEXFlush == 1)? 0:IDMemtoReg;
    ALUSrc_EX <= (IDEXFlush == 1)? 0:ALUSrc_ID;
    MemWrite_EX <= (IDEXFlush == 1)? 0:MemWrite_ID;
    RegDst_EX <= (IDEXFlush == 1)? 0:RegDst_ID;
    MemRead_EX <= (IDEXFlush == 1)? 0:MemRead_ID;
    ALUOp_EX <= (IDEXFlush == 1)? 2'b0: ALUOp_ID;
    Readdata2_EX <= (IDEXFlush == 1)? 32'b0: Readdata2_ID;
    Readdata1_EX <= (IDEXFlush == 1)? 32'b0: Readdata1_ID;
    Signextend_EX <= (IDEXFlush == 1)? 32'b0: Signextend_ID;
    Rs_EX <= (IDEXFlush == 1)? 5'b0 : Rs_ID;
    Rt_EX <= (IDEXFlush == 1)? 5'b0 : Rt_ID;
    Rd_EX <= (IDEXFlush == 1)? 5'b0 : Rd_ID;
end

endmodule