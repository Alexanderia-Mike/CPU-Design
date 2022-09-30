module Mux_2_1 ( dataIn0, dataIn1, Sel, dataOut );
    parameter   dataWidth = 32;

    input       [dataWidth - 1 : 0] dataIn0, dataIn1;
    input                           Sel;
    output  reg [dataWidth - 1 : 0] dataOut;

    initial                         dataOut = 0;

    // assign  dataOut = Sel ? dataIn1 : dataIn0;
    always  @ ( Sel, dataIn0, dataIn1 )
    begin
        if ( Sel )      dataOut = dataIn1;
        else            dataOut = dataIn0;
    end
endmodule