`include "IDStage.v"

module IDStage_Sim;
    parameter       half_period = 50;
    parameter       finish_time = 700;

    reg             clock, Hazard, MEMWBRegWrite, forward1, forward2;
    reg     [31:0]  MEMWBWriteData, EXMEMALUResultOut, IFIDInstr, IFIDPCPlus4, IFPCPlus4Out;
    reg     [4:0]   MEMWBDst;

    wire            IDEXRegWrite, IDEXMemtoReg, IDEXALUSrc, IDEXMemWrite, IDEXRegDst, 
                    IDEXMemRead;
    wire    [1:0]   IDEXALUOp;
    wire    [31:0]  IDEXReadData1, IDEXReadData2;
    wire    [31:0]  IDJumpTarget, IDNonJumpTarget;
    wire            IDBranch, IDJump, IFIDFlush;
    wire    [31:0]  IDEXImm;
    wire    [4:0]   IDEXRs, IDEXRt, IDEXRd;

    wire    [4:0]   IDRtOut, IDRsOut;

    IDStage     ID  ( IDJump, IDNonJumpTarget, IFIDFlush, IDJumpTarget, MEMWBRegWrite, IDBranch, 
                      IDEXRegWrite, IDEXMemtoReg, IDEXMemRead, IDEXMemWrite, IDEXALUSrc, IDEXALUOp, 
                      IDEXRegDst, IDEXReadData1, IDEXReadData2, IDEXRt, IDEXRs, IDEXRd, IDEXImm, 
                      IDRtOut, IDRsOut, MEMWBDst, MEMWBWriteData, EXMEMALUResultOut, Hazard, IFIDInstr, 
                      IFIDPCPlus4, clock, forward1, forward2, IFPCPlus4Out );

    initial
    begin
        # 0     clock = 1; Hazard = 0; MEMWBRegWrite = 1; forward1 = 0; forward2 = 0; 
                MEMWBWriteData = 32'h12345678; EXMEMALUResultOut = 32'h87654321; 
                IFIDInstr = 32'h20080020; IFIDPCPlus4 = 12; MEMWBDst = 8; IFPCPlus4Out = 12;
        # 40    Hazard = 1;
        # 100   Hazard = 0; forward1 = 1; forward2 = 1;
        # 100   IFIDInstr = 32'b00010010001100100000000000010010;
        # 100   IFIDInstr = 32'b00001000000000000000000000010111;
    end

    always  # half_period       clock = ~ clock;

    integer         i;
    initial         i = 0;

    always  @ ( posedge clock ) 
    begin
        i = i + 1;
        # ( half_period + 10 )
        $display( 
            "between %d and %d clock, IDEXRegWrite = %b, IDEXMemtoReg = %b, IDEXALUSrc = %b, IDEXMemWrite = %b, IDEXRegDst = %b, IDEXMemRead = %b, IDEXALUOp = %b, IDEXReadData1 = %h, IDEXReadData2 = %h, IDJumpTarget = %h, IDNonJumpTarget = %h, IDBranch = %b, IDJump = %b, IFIDFlush = %b, IDEXImm = %h, IDEXRs = %b, IDEXRt = %b, IDEXRd = %b, IDRtOut = %b, IDRsOut = %b, Instr in ID = %h, IDRs in ID = %b, IDRt in ID = %b, IDEXRs in ID = %b, IDEXRt in ID = %b, IDEXReadData2 in ID = %h", 
            i - 1, i, IDEXRegWrite, IDEXMemtoReg, IDEXALUSrc, IDEXMemWrite, IDEXRegDst,
            IDEXMemRead, IDEXALUOp, IDEXReadData1, IDEXReadData2, IDJumpTarget, IDNonJumpTarget,
            IDBranch, IDJump, IFIDFlush, IDEXImm, IDEXRs, IDEXRt, IDEXRd, IDRtOut, IDRsOut,
            ID.IFIDInstr, ID.IDRs, ID.IDRt, ID.IDEXRs, ID.IDEXRt, ID.IDEXReadData2
        );
    end

    initial # finish_time       $finish;
endmodule