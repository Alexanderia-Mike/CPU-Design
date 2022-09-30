`include "Data_Memory.v"

module MEMStage ( 
    EXMEMDst, EXMEMMemWrite, EXMEMMemRead, EXMEMRegWrite, EXMEMMemtoReg, EXMEMWriteData, 
    EXMEMALUResult, EXMEMMemReadOut, EXMEMRegWriteOut, EXMEMDstOut, MEMWBRegWrite, MEMWBMemtoReg,
    MEMWBReadData, MEMWBALUResult, MEMWBDst, EXMEMALUResultOut, clock
);
    input               EXMEMMemWrite, EXMEMMemRead, EXMEMRegWrite, EXMEMMemtoReg, clock;
    input       [31:0]  EXMEMWriteData, EXMEMALUResult;
    input       [4:0]   EXMEMDst;
    
    output              EXMEMMemReadOut, EXMEMRegWriteOut;
    output      [4:0]   EXMEMDstOut;
    output  reg         MEMWBRegWrite, MEMWBMemtoReg;
    output  reg [31:0]  MEMWBReadData, MEMWBALUResult;
    output  reg [4:0]   MEMWBDst;
    output      [31:0]  EXMEMALUResultOut;

    wire        [31:0]  MEMReadData;

    assign  EXMEMMemReadOut     = EXMEMMemRead;
    assign  EXMEMRegWriteOut    = EXMEMRegWrite;
    assign  EXMEMDstOut         = EXMEMDst; // wrong
    assign  EXMEMALUResultOut   = EXMEMALUResult;

    initial
    begin
        MEMWBRegWrite = 0; MEMWBMemtoReg = 0; MEMWBReadData = 0; MEMWBALUResult = 0; MEMWBDst = 0;
    end

    Data_Memory     dm  ( EXMEMALUResult, EXMEMWriteData, EXMEMMemWrite, EXMEMMemRead, MEMReadData, clock );

    always @ ( posedge clock )
    begin
        MEMWBRegWrite <= EXMEMRegWrite; MEMWBMemtoReg <= EXMEMMemtoReg; MEMWBReadData <= MEMReadData;
        MEMWBALUResult <= EXMEMALUResult; MEMWBDst <= EXMEMDst;
    end
endmodule