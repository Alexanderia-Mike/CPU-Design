// `include "Mux_2_1.v"

module WBStage ( 
    MEMWBRegWriteOut, MEMWBWriteData, MEMWBDstOut, MEMWBDst, 
    MEMWBALUResult, MEMWBReadData, MEMWBMemtoReg, MEMWBRegWrite, clock
);
    output          MEMWBRegWriteOut;
    output  [31:0]  MEMWBWriteData;
    output  [4:0]   MEMWBDstOut;

    input   [4:0]   MEMWBDst;
    input   [31:0]  MEMWBALUResult, MEMWBReadData;
    input           MEMWBMemtoReg, MEMWBRegWrite, clock;

    assign  MEMWBRegWriteOut    = MEMWBRegWrite;
    assign  MEMWBDstOut         = MEMWBDst;

    Mux_2_1     mux ( MEMWBALUResult, MEMWBReadData, MEMWBMemtoReg, MEMWBWriteData );
endmodule