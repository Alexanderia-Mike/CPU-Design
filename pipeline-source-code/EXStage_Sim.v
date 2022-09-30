`include "EXStage.v"

module EXStage_Sim;
    parameter       half_period = 50;
    parameter       finish_time = 700;

    reg             IDEXRegDst, IDEXALUSrc, IDEXRegWrite, IDEXMemtoReg, IDEXMemRead, 
                    IDEXMemWrite, clock;
    reg     [1:0]   ForwardA, ForwardB, IDEXALUOp;
    reg     [31:0]  WBForwarding, MEMForwarding, IDEXReadData2, IDEXReadData1, IDEXImm;
    reg     [4:0]   IDEXRd, IDEXRs, IDEXRt;

    wire            IDEXMemReadOut, IDEXRegWriteOut;
    wire            EXMEMRegWrite, EXMEMMemtoReg, EXMEMMemRead, EXMEMMemWrite;
    wire    [4:0]   EXDst, IDEXRsOut, IDEXRtOut;
    wire    [4:0]   EXMEMDst;
    wire    [31:0]  EXMEMReadAddress, EXMEMWriteData;

    EXStage     EX  ( IDEXMemReadOut, IDEXRegWriteOut, EXDst, EXMEMRegWrite, EXMEMMemtoReg, EXMEMMemRead, 
                    EXMEMMemWrite, EXMEMReadAddress, EXMEMWriteData, EXMEMDst, ForwardA, ForwardB, IDEXRsOut, 
                    WBForwarding, MEMForwarding, IDEXRtOut, IDEXImm, IDEXRd, IDEXRs, IDEXRt, IDEXReadData2, 
                    IDEXReadData1, IDEXALUOp, IDEXRegDst, IDEXALUSrc, IDEXRegWrite, IDEXMemtoReg, IDEXMemRead, 
                    IDEXMemWrite, clock );

    initial
    begin
        # 0     IDEXRegDst = 1; IDEXALUSrc = 0; IDEXRegWrite = 1; IDEXMemtoReg = 0; IDEXMemRead = 1; 
                IDEXMemWrite = 1; ForwardA = 2'b00; ForwardB = 2'b00; IDEXALUOp = 2'b10; 
                WBForwarding = 32'h12345678; MEMForwarding = 32'h13579246; IDEXReadData1 = 32'h44332211;
                IDEXReadData2 = 32'h11223344; IDEXImm = 32'h55667788; IDEXRd = 5'b00010; 
                IDEXRs = 5'b00100; IDEXRt = 5'b01000; clock = 1;
    end

    always  # half_period       clock = ~clock;

    integer         i;
    initial         i = 0;

    always  @ ( posedge clock ) 
    begin
        i = i + 1;
        # ( half_period + 10 )
        $display( 
            "between %d and %d clock, IDEXMemReadOut = %b, IDEXRegWriteOut = %b, EXMEMRegWrite = %b, EXMEMMemtoReg = %b, EXMEMMemRead = %b, EXMEMMemWrite = %b, EXDst = %b, IDEXRsOut = %b, IDEXRtOut = %b, EXMEMDst = %b, EXMEMReadAddress = %h, EXMEMWriteData = %h", 
            i - 1, i, IDEXMemReadOut, IDEXRegWriteOut, EXMEMRegWrite, EXMEMMemtoReg, EXMEMMemRead, EXMEMMemWrite, EXDst, IDEXRsOut, IDEXRtOut, EXMEMDst, EXMEMReadAddress, EXMEMWriteData
        );
    end

    initial # finish_time       $finish;
endmodule