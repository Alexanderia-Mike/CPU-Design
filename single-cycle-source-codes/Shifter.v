module Shifter ( dataIn, rdataOut );
    parameter                   dataWidth = 32;
    
    input       [dataWidth - 1 : 0] dataIn;
    
    output  reg [dataWidth - 1 : 0] rdataOut;
    
    initial rdataOut = 0;
    
    always @ ( dataIn )
        rdataOut = 4 * dataIn;
endmodule