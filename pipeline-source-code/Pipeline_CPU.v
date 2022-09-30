`include "IFStage.v"
`include "IDStage.v"
`include "EXStage.v"
`include "MEMStage.v"
`include "WBStage.v"
`include "Hazard_Detection.v"
`include "Forwarding_Unit.v"

module Pipeline_CPU ( clock, RegFile_Address, RegOut, PCOut );
    input           clock;
    input   [4:0]   RegFile_Address;

    output  [31:0]  RegOut, PCOut;

    assign  RegOut  = RegOutOut;
    assign  PCOut   = PCOutOut;

    wire    [31:0]  IDJumpTarget, IDNonJumpTarget, IFIDPCPlus4, IFIDInstr, IFPCPlus4Out,
                    MEMWBWriteData, EXMEMALUResultOut, IDEXReadData1, IDEXReadData2, IDEXImm,
                    EXMEMReadAddress, EXMEMWriteData, EXMEMALUResult, MEMWBReadData, MEMWBALUResult,
                    RegOutOut, PCOutOut;

    wire            IFIDFlush, IFIDWrite, IFPCWrite, IDJump, Hazard, MEMWBRegWrite, 
                    IDEXRegWrite, IDEXMemtoReg, IDEXALUSrc, IDEXMemWrite, 
                    IDEXRegDst, IDEXMemRead, IDBranch, IDEXMemReadOut, IDEXRegWriteOut,
                    EXMEMRegWrite, EXMEMMemtoReg, EXMEMMemRead, EXMEMMemWrite, EXMEMMemReadOut, 
                    EXMEMRegWriteOut, MEMWBMemtoReg, MEMWBRegWriteOut, forward1, forward2;

    wire    [4:0]   MEMWBDst, IDEXRs, IDEXRt, IDEXRd, IDRtOut, IDRsOut, EXDst, IDEXRsOut, 
                    IDEXRtOut, EXMEMDst, EXMEMDstOut, MEMWBDstOut;

    wire    [1:0]   IDEXALUOp, ForwardA, ForwardB;

    // modules
    IFStage     IF  ( IDJumpTarget, IFIDFlush, IDNonJumpTarget, IDJump, IFPCPlus4Out, IFIDPCPlus4, 
                    IFIDInstr, IFIDWrite, IFPCWrite, clock, PCOutOut );
    IDStage     ID  ( IDJump, IDNonJumpTarget, IFIDFlush, IDJumpTarget, MEMWBRegWriteOut, IDBranch, 
                    IDEXRegWrite, IDEXMemtoReg, IDEXMemRead, IDEXMemWrite, IDEXALUSrc, IDEXALUOp, 
                    IDEXRegDst, IDEXReadData1, IDEXReadData2, IDEXRt, IDEXRs, IDEXRd, IDEXImm, 
                    IDRtOut, IDRsOut, MEMWBDst, MEMWBWriteData, EXMEMALUResultOut, Hazard, IFIDInstr, 
                    IFIDPCPlus4, clock, forward1, forward2, IFPCPlus4Out, RegFile_Address, RegOutOut );
    EXStage     EX  ( IDEXMemReadOut, IDEXRegWriteOut, EXDst, EXMEMRegWrite, EXMEMMemtoReg, EXMEMMemRead, 
                    EXMEMMemWrite, EXMEMALUResult, EXMEMWriteData, EXMEMDst, ForwardA, ForwardB, 
                    IDEXRsOut, MEMWBWriteData, EXMEMALUResult, IDEXRtOut, IDEXImm, IDEXRd, IDEXRs, IDEXRt, 
                    IDEXReadData2, IDEXReadData1, IDEXALUOp, IDEXRegDst, IDEXALUSrc, IDEXRegWrite, 
                    IDEXMemtoReg, IDEXMemRead, IDEXMemWrite, clock );
    MEMStage    MEM ( EXMEMDst, EXMEMMemWrite, EXMEMMemRead, EXMEMRegWrite, EXMEMMemtoReg, EXMEMWriteData, 
                    EXMEMALUResult, EXMEMMemReadOut, EXMEMRegWriteOut, EXMEMDstOut, MEMWBRegWrite, 
                    MEMWBMemtoReg, MEMWBReadData, MEMWBALUResult, MEMWBDst, EXMEMALUResultOut, clock );
    WBStage     WB  ( MEMWBRegWriteOut, MEMWBWriteData, MEMWBDstOut, MEMWBDst, 
                    MEMWBALUResult, MEMWBReadData, MEMWBMemtoReg, MEMWBRegWrite, clock );
    Hazard_Detection
                HD  ( IDBranch, IDEXRegWrite, EXMEMRegWrite, EXDst, EXMEMDst, IDEXMemRead, IDEXRt, 
                    IDRsOut, IDRtOut, IFPCWrite, IFIDWrite, Hazard, EXMEMMemRead, forward1, forward2 );
    Forwarding_Unit
                FU  ( EXMEMRegWrite, MEMWBRegWrite, EXMEMDst, MEMWBDst, IDEXRs, IDEXRt, ForwardA, ForwardB );
endmodule