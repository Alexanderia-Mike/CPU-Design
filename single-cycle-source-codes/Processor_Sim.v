`include "Single_Cycle_Processor.v"

module Processor_Sim (  );
    parameter   half_period = 50;
    parameter   run_time = 3000;
    integer     i;

    reg             clock;
    reg     [7:0]   clockNum; // 128 cycles for maximum
    wire    [31:0]  PCValue, Instr;

    Single_Cycle_Processor  processor ( clock, PCValue, Instr );

    initial     
    begin
        #0      clock = 1; clockNum = 0;
                $display( "Time: %3d, CLK = %d, PC = %h, Instr = %h", $time, clockNum, PCValue, processor.Instr );
                $display( "Instr = %b", processor.Instr );
                $display( "PCInput = %b, PCOutput = %b, PCPlus4 = %b, adderInput1 = %b, adderInput2 = %b, adderResult = %b", processor.PCInput, processor.PCOutput, processor.PCPlus4, processor.adder1.Operand1, processor.adder1.Operand2, processor.adder1.Result );
                $display( "JumpAddr = %b, JumpPreAddr1 = %b, JumpPreAddr2 = %b", processor.JumpAddr, processor.JumpPreAddr1, processor.JumpPreAddr2 );
                $display( "SignExtImm = %b, RelativeAddr = %b, BranchAddr = %b, NonJumpAddr = %b", processor.SignExtImm, processor.RelativeAddr, processor.BranchAddr, processor.NonJumpAddr );
        $display( "InstrRs = %b, InstrRt = %b, InstrRd = %b", processor.InstrRs, processor.InstrRt, processor.InstrRd );
        // $monitor( "time: %d", $time );
        $display( "Opcode = %b, Branch = %b", processor.Opcode, processor.Branch );
        $display( "DMReadData = %h, MemtoReg = %b", processor.DMReadData, processor.MemtoReg );
        $display( "DMReadData = %h, MemRead = %b, MemWrite = %b", processor.DMReadData, processor.MemRead, processor.MemWrite );
        $display( "ALUOperand2 = %h, ALUOperation = %b, ALUResult = %b", processor.ALUOperand2, processor.ALUOperation, processor.ALUResult );
        $display( 
            "RFReadData1 = %h, RFReadData2 = %h, RegWrite = %b, InstrRs = %b, InstrRt = %b, RFWriteReg = %b, RFWriteData = %h", 
            processor.RFReadData1, processor.RFReadData2, processor.RegWrite, processor.InstrRs, processor.InstrRt, processor.RFWriteReg, processor.RFWriteData
        );
    end

    always
        #half_period
    begin
        clock = ~clock;
        $display( "Time: %4d, CLKCount = %2d, clock = %b, PC = %h, Instr = %h", $time, clockNum, clock, PCValue, processor.Instr );
        $display( "Instr = %b", processor.Instr );
        $display( "PCInput = %b, PCOutput = %b, PCPlus4 = %b, adderInput1 = %b, adderInput2 = %b, adderResult = %b", processor.PCInput, processor.PCOutput, processor.PCPlus4, processor.adder1.Operand1, processor.adder1.Operand2, processor.adder1.Result );
        $display( "JumpAddr = %b, JumpPreAddr1 = %b, JumpPreAddr2 = %b", processor.JumpAddr, processor.JumpPreAddr1, processor.JumpPreAddr2 );
        $display( "SignExtImm = %b, RelativeAddr = %b, BranchAddr = %b, NonJumpAddr = %b", processor.SignExtImm, processor.RelativeAddr, processor.BranchAddr, processor.NonJumpAddr );
        $display( "InstrRs = %b, InstrRt = %b, InstrRd = %b", processor.InstrRs, processor.InstrRt, processor.InstrRd );
        // $monitor( "time: %d", $time );
        $display( "Opcode = %b, Branch = %b, Jump = %b", processor.Opcode, processor.Branch, processor.Jump );
        $display( "DMReadData = %h, MemtoReg = %b", processor.DMReadData, processor.MemtoReg );
        $display( "DMReadData = %h, MemRead = %b, MemWrite = %b", processor.DMReadData, processor.MemRead, processor.MemWrite );
        $display( "ALUOperand2 = %h, ALUOperation = %b, ALUResult = %h", processor.ALUOperand2, processor.ALUOperation, processor.ALUResult );
        $display( 
            "RFReadData1 = %h, RFReadData2 = %h, RegWrite = %b, InstrRs = %b, InstrRt = %b, RFWriteReg = %b, RFWriteData = %h", 
            processor.RFReadData1, processor.RFReadData2, processor.RegWrite, processor.InstrRs, processor.InstrRt, processor.RFWriteReg, processor.RFWriteData
        );
        $display( "===============================================" );
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

    always @ ( posedge clock )
            clockNum = clockNum + 1;

    initial     #run_time       $finish;
endmodule