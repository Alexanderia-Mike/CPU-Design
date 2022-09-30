module Shifter ( dataIn, rdataOut );
    parameter                   dataWidth = 32;
//    parameter                   shiftBit = 2; // required to be larger than 0
    
    input       [dataWidth - 1 : 0] dataIn;
//    input                           complement;
    output  reg [dataWidth - 1 : 0] rdataOut;
    
    initial rdataOut = 0;
    
//    wire    [dataWidth - 1 : 0] dataOut;

//    assign dataOut[dataWidth - 1 : shiftBit] = dataIn[dataWidth - 1 - shiftBit : 0];
//    assign dataOut[shiftBit - 1 : 0] = complement;
    
    always @ ( dataIn )
        rdataOut = 4 * dataIn;
endmodule