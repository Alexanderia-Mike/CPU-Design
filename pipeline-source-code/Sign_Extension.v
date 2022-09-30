module Sign_Extension ( dataIn, dataOut );
    input       [15:0]  dataIn;
    output  reg [31:0]  dataOut;
    
    initial dataOut = 0;

    always @ (dataIn)
    begin
        if ( dataIn[15] ) // a negative number
            dataOut = { 16'b1111111111111111, dataIn };
        else // a positive nubmer
            dataOut = { 16'b0000000000000000, dataIn };
    end
endmodule