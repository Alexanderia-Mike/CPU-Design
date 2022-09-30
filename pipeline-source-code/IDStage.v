`include "Sign_Extension.v"
`include "Shifter.v"
`include "Control.v"
`include "Register_File.v"
// `include "Mux_2_1.v"
`include "Comparator.v"
// `include "ALU_Adder.v"

module IDStage (
    IDJump, IDNonJumpTarget, IFIDFlush, IDJumpTarget, MEMWBRegWrite, IDBranch, 
    IDEXRegWrite, IDEXMemtoReg, IDEXMemRead, IDEXMemWrite, IDEXALUSrc, IDEXALUOp, 
    IDEXRegDst, IDEXReadData1, IDEXReadData2, IDEXRt, IDEXRs, IDEXRd, IDEXImm, 
    IDRtOut, IDRsOut, MEMWBDst, MEMWBWriteData, EXMEMALUResultOut, Hazard, IFIDInstr, 
    IFIDPCPlus4, clock, forward1, forward2, IFPCPlus4Out, RegFile_Address, RegOutOut
);
    input               clock, Hazard, MEMWBRegWrite, forward1, forward2;
    input       [31:0]  MEMWBWriteData, EXMEMALUResultOut, IFIDInstr, IFIDPCPlus4, IFPCPlus4Out;
    input       [4:0]   MEMWBDst, RegFile_Address;

    output  reg         IDEXRegWrite, IDEXMemtoReg, IDEXALUSrc, IDEXMemWrite, IDEXRegDst, 
                        IDEXMemRead;
    output  reg [1:0]   IDEXALUOp;
    output  reg [31:0]  IDEXReadData1, IDEXReadData2;
    output      [31:0]  IDJumpTarget, IDNonJumpTarget, RegOutOut;
    output              IDBranch, IDJump, IFIDFlush;
    output  reg [31:0]  IDEXImm; 
    output  reg [4:0]   IDEXRs, IDEXRt, IDEXRd;

    output      [4:0]   IDRtOut, IDRsOut;
 
    reg         [4:0]   IDRs, IDRt, IDRd;
    wire                IDRegWrite, IDMemtoReg, IDALUSrc, IDMemWrite, IDRegDst, IDMemRead,
                        Equal, BranchOrNot;
    wire        [1:0]   IDALUOp;
    wire        [31:0]  IDSignedImm, IDReaddata1, IDReaddata2, RFReadData1, RFReadData2,
                        BranchTarget, ImmTimes4, RegOutOutOut;
    wire        [27:0]  PreJump1, PreJump2;
    wire        [5:0]   IDOpcode;

    initial begin
        IDEXRegWrite = 1'b0; IDEXMemtoReg = 1'b0; IDEXALUSrc = 1'b0; IDEXMemWrite = 1'b0; 
        IDEXRegDst = 1'b0; IDEXMemRead = 1'b0; IDEXALUOp = 2'b0; IDEXRs = 5'b0; IDEXRt = 5'b0; 
        IDEXRd = 5'b0; IDEXReadData1 = 32'b0; IDEXReadData2 = 32'b0; IDEXImm = 32'b0;
        IDRs = 5'b0; IDRt = 5'b0; IDRd = 5'b0; 
    end

    // possibly used in connecting
    assign PreJump1     = { 2'b00, IFIDInstr[25:0] };
    assign IDJumpTarget = { IFIDPCPlus4[31:28], PreJump2 };
    assign IDOpcode     = IFIDInstr[31:26];
    assign IFIDFlush    = BranchOrNot | IDJump;
    assign IDRsOut      = IDRs;
    assign IDRtOut      = IDRt;
    assign RegOutOut    = RegOutOutOut;

    Sign_Extension      ext     (IFIDInstr[15:0], IDSignedImm);
    Shifter # ( 28 )    shftr1  ( PreJump1, PreJump2 );
    Control             cntrl   ( IDOpcode, IDRegDst, IDBranch, BranchOrNot, IDMemRead, IDMemtoReg, 
                                  IDALUOp, IDMemWrite, IDALUSrc, IDRegWrite, IDJump, Equal );
    Register_File       rf      ( clock, MEMWBRegWrite, IDRs, IDRt, MEMWBDst, MEMWBWriteData, RFReadData1, RFReadData2, 
                                RegFile_Address, RegOutOutOut );
    Mux_2_1             mux1    ( RFReadData1, EXMEMALUResultOut, forward1, IDReaddata1 );
    Mux_2_1             mux2    ( RFReadData2, EXMEMALUResultOut, forward2, IDReaddata2 );
    Comparator          cmp     ( IDReaddata1, IDReaddata2, Equal );
    Shifter # ( 32 )    shftr2  ( IDSignedImm, ImmTimes4 );
    ALU_Adder           adder   ( IFIDPCPlus4, ImmTimes4, BranchTarget );
    Mux_2_1             mux3    ( IFPCPlus4Out, BranchTarget, BranchOrNot, IDNonJumpTarget );

    always @ ( IFIDInstr )
    begin
        IDRs = IFIDInstr[25:21];
        IDRt = IFIDInstr[20:16];
        IDRd = IFIDInstr[15:11];
    end

    always @ ( posedge clock )
    begin
        if ( ~Hazard )
        begin
            IDEXRegWrite <= IDRegWrite; IDEXMemtoReg <= IDMemtoReg; IDEXALUSrc <= IDALUSrc;
            IDEXMemWrite <= IDMemWrite; IDEXRegDst <= IDRegDst; IDEXMemRead <= IDMemRead;
            IDEXALUOp <= IDALUOp;
        end
        else // hazard detected
        begin
            IDEXRegWrite <= 0; IDEXMemtoReg <= 0; IDEXALUSrc <= 0; IDEXMemWrite <= 0; 
            IDEXRegDst <= 0; IDEXMemRead <= 0; IDEXALUOp <= 0;
        end
        IDEXReadData2 = IDReaddata2; IDEXReadData1 = IDReaddata1; IDEXImm = IDSignedImm;
        IDEXRs = IDRs; IDEXRt = IDRt; IDEXRd = IDRd;
    end
endmodule