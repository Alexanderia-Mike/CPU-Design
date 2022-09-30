//`include "Single_Cycle_Processor.v"

module new_processor_sim (  );
    parameter   half_period = 50;
    parameter   run_time = 3700;
    integer     i;

    reg             clock;
//    reg     [7:0]   clockNum; // 128 cycles for maximum
//    wire    [31:0]  PCValue, Instr;

    Single_Cycle_Processor  processor ( clock );

    initial     
    begin
        #0      clock = 1; 
//                clockNum = 0;
    end

    always # half_period
        clock = ~clock;
        
    always @ ( posedge clock )        
    begin
        # 10
        $display( "===============================================" );
        $display ( "Time: %3d, CLK = %b, PC = %h", $time, clock, processor.PCOutput );
        for ( i = 16; i <= 23; i = i + 1 )
        begin
            $write ( "[$s%1d] = %h  ", i - 16, processor.rf.registerMem[i] );
            if  ( i == 18 || i == 21 )
                $display( "" );
        end
        for ( i = 8; i <= 15; i = i + 1 )
        begin
            $write ( "[$t%1d] = %h  ", i - 8, processor.rf.registerMem[i] );
            if  ( i == 8 || i == 11 || i == 14 )
                $display( "" );
        end
        $write ( "[$t8] = %h  ", processor.rf.registerMem[24] );
        $write ( "[$t9] = %h  ", processor.rf.registerMem[25] );
        $display( "" );
        $display( "" );
    end
    
    always @ ( negedge clock )
    begin
        #10
        $display ( "Time: %3d, CLK = %b, PC = %h", $time, clock, processor.PCOutput );
        for ( i = 16; i <= 23; i = i + 1 )
        begin
            $write ( "[$s%1d] = %h  ", i - 16, processor.rf.registerMem[i] );
            if  ( i == 18 || i == 21 )
                $display( "" );
        end
        for ( i = 8; i <= 15; i = i + 1 )
        begin
            $write ( "[$t%1d] = %h  ", i - 8, processor.rf.registerMem[i] );
            if  ( i == 8 || i == 11 || i == 14 )
                $display( "" );
        end
        $write ( "[$t8] = %h  ", processor.rf.registerMem[24] );
        $write ( "[$t9] = %h  ", processor.rf.registerMem[25] );
        $display( "" );
        $display( "===============================================" );
        $display( "" );
    end

//    always @ ( posedge clock )
//            clockNum = clockNum + 1;

    initial     #run_time       $finish;
endmodule