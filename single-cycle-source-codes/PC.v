module PC ( nextInstrAddr, clock, currentInstrAddr );
    input       [31:0]  nextInstrAddr;
    input               clock;
    output reg  [31:0]  currentInstrAddr;

    initial
        currentInstrAddr = 0;

    always @ (posedge clock)
        currentInstrAddr = nextInstrAddr;
endmodule