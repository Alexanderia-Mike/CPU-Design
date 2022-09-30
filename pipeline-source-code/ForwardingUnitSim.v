`include "forwarding_Unit.v"

module ForwardingUnitSim;
    reg     [4:0]   ExMemDst, MemWbDst, IdExRs, IdExRt;
    reg             ExMemRegWrite, MemWbRegWrite;
    wire    [1:0]   ForwardA, ForwardB;

    Forwarding_Unit forward ( ExMemRegWrite, MemWbRegWrite, ExMemDst, MemWbDst, IdExRs, IdExRt, ForwardA, ForwardB );
    
    initial 
    begin
        #0  ExMemDst = 0; MemWbDst = 0; IdExRs = 0; IdExRt = 0; ExMemRegWrite = 0; MemWbRegWrite = 0;
        //  forwardA = forwardB = 0
        #25 $display( "ForwardA = %b, ForwardB = %b, they should be 00, 00", ForwardA, ForwardB );
        #25 MemWbDst = 1; IdExRs = 1; ExMemRegWrite = 1; MemWbRegWrite = 1;
        #25 $display( "ForwardA = %b, ForwardB = %b, they should be 01, 00", ForwardA, ForwardB );
        #25 ExMemDst = 1;
        #25 $display( "ForwardA = %b, ForwardB = %b, they should be 10, 00", ForwardA, ForwardB );
        #25 ExMemDst = 2; IdExRt = 2;
        #25 $display( "ForwardA = %b, ForwardB = %b, they should be 01, 10", ForwardA, ForwardB );
    end

    initial #200   $finish;
endmodule