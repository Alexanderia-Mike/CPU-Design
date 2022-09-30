// `include "Mux_2_1.v"
`include "Mux_3_1.v"
`include "ALU_32.v"
`include "ALU_Control.v"

module EXStage ( 
    IDEXMemReadOut, IDEXRegWriteOut, EXDst, EXMEMRegWrite, EXMEMMemtoReg, EXMEMMemRead, EXMEMMemWrite, 
    EXMEMReadAddress, EXMEMWriteData, EXMEMDst, ForwardA, ForwardB, IDEXRsOut, WBForwarding, MEMForwarding, 
    IDEXRtOut, IDEXImm, IDEXRd, IDEXRs, IDEXRt, IDEXReadData2, IDEXReadData1, IDEXALUOp, 
    IDEXRegDst, IDEXALUSrc, IDEXRegWrite, IDEXMemtoReg, IDEXMemRead, IDEXMemWrite, clock
 );
    input               IDEXRegDst, IDEXALUSrc, IDEXRegWrite, IDEXMemtoReg, IDEXMemRead, 
                        IDEXMemWrite, clock;
    input       [1:0]   ForwardA, ForwardB, IDEXALUOp;
    input       [31:0]  WBForwarding, MEMForwarding, IDEXReadData2, IDEXReadData1, IDEXImm;
    input       [4:0]   IDEXRd, IDEXRs, IDEXRt;

    output              IDEXMemReadOut, IDEXRegWriteOut;
    output  reg         EXMEMRegWrite, EXMEMMemtoReg, EXMEMMemRead, EXMEMMemWrite;
    output      [4:0]   EXDst, IDEXRsOut, IDEXRtOut;
    output  reg [4:0]   EXMEMDst;
    output  reg [31:0]  EXMEMReadAddress, EXMEMWriteData;

    wire        [31:0]  ALUOperand1, ALUOperand2, ALUResult;
    wire        [31:0]  RtContent;
    wire        [5:0]   EXFunct;
    wire        [3:0]   ALUOperation;

    initial
    begin
        EXMEMRegWrite       = 0;
        EXMEMMemtoReg       = 0;
        EXMEMMemRead        = 0;
        EXMEMMemWrite       = 0;
        EXMEMReadAddress    = 0;
        EXMEMWriteData      = 0;
        EXMEMDst            = 0;
    end

    assign  IDEXMemReadOut  = IDEXMemRead;
    assign  IDEXRegWriteOut = IDEXRegWrite;
    assign  IDEXRsOut       = IDEXRs;
    assign  IDEXRtOut       = IDEXRt;
    assign  EXFunct         = IDEXImm[5:0];

    Mux_3_1         mux1    ( IDEXReadData1, WBForwarding, MEMForwarding, ForwardA, ALUOperand1 );
    Mux_3_1         mux2    ( IDEXReadData2, WBForwarding, MEMForwarding, ForwardB, RtContent );
    Mux_2_1         mux3    ( RtContent, IDEXImm, IDEXALUSrc, ALUOperand2 );
    ALU_32          alu     ( ALUOperand1, ALUOperand2, ALUOperation, ALUResult, ,  );
    ALU_Control     aluctrl ( EXFunct, IDEXALUOp, ALUOperation );
    Mux_2_1 # ( 5 ) mux4    ( IDEXRt, IDEXRd, IDEXRegDst, EXDst );

    always @ ( posedge clock )
    begin
        EXMEMRegWrite       <= IDEXRegWrite;
        EXMEMMemtoReg       <= IDEXMemtoReg;
        EXMEMMemRead        <= IDEXMemRead;
        EXMEMMemWrite       <= IDEXMemWrite;
        EXMEMReadAddress    <= ALUResult;
        EXMEMWriteData      <= RtContent;
        EXMEMDst            <= EXDst;
    end
endmodule