module Comparator ( in1, in2, equal );
    input       [31:0]  in1, in2;
    output reg          equal;

    initial equal = 0;

    always @ ( in1, in2 )
        if ( in1 == in2 )   equal = 1;
        else                equal = 0;
endmodule