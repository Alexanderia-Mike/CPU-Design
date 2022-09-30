module Mux_3_1 ( in00, in01, in10, sel, out );
    parameter   dataWidth = 32;

    input       [dataWidth - 1 : 0] in00, in01, in10;
    input       [1:0]               sel;
    output  reg [dataWidth - 1 : 0] out;

    initial                         out = 0;

    always @ ( in00, in01, in10, sel )
    begin
        if      ( sel == 2'b00 )    out = in00;
        else if ( sel == 2'b01 )    out = in01;
        else                        out = in10;
    end
endmodule