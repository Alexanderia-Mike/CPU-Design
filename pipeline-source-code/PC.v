module PC ( nextInstrAddr, clock, currentInstrAddr, IFPCWrite );
    input       [31:0]  nextInstrAddr;
    input               clock, IFPCWrite;
    output reg  [31:0]  currentInstrAddr;

    initial
        currentInstrAddr = -4;

    always @ (posedge clock)
        if  ( IFPCWrite )
            currentInstrAddr = nextInstrAddr;
        else
            ;
endmodule