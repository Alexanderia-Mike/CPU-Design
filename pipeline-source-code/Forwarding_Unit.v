module Forwarding_Unit 
( ExMemRegWrite, MemWbRegWrite, ExMemDst, MemWbDst, IdExRs, IdExRt, ForwardA, ForwardB );
    input       [4:0]   ExMemDst, MemWbDst, IdExRs, IdExRt;
    input               ExMemRegWrite, MemWbRegWrite;
    output  reg [1:0]   ForwardA, ForwardB;

    initial
    begin
        ForwardA = 0;
        ForwardB = 0;
    end

    always @ ( ExMemRegWrite, MemWbRegWrite, ExMemDst, MemWbDst, IdExRs, IdExRt )
    begin
        if      ( ExMemRegWrite && ExMemDst != 0 && ExMemDst == IdExRs ) // 1 & 2 rs hazard
            ForwardA = 2'b10;
        else if ( MemWbRegWrite && MemWbDst != 0 && MemWbDst == IdExRs ) // 1 & 3 rs hazard
            ForwardA = 2'b01;
        else
            ForwardA = 2'b00;

        if      ( ExMemRegWrite && ExMemDst != 0 && ExMemDst == IdExRt ) // 1 & 2 rs hazard
            ForwardB = 2'b10;
        else if ( MemWbRegWrite && MemWbDst != 0 && MemWbDst == IdExRt ) // 1 & 3 rt hazard
            ForwardB = 2'b01;
        else
            ForwardB = 2'b00;
    end
endmodule