`include "ALU_32.v"
`include "ALU_Control.v"
`include "Control.v"
`include "Data_Memory.v"
`include "instruction_Memory.v"
`include "Mux_2_1.v"
`include "PC.v"
`include "Register_File.v"
`include "Shifter.v"
`include "Sign_Extension.v"
`include "ALU_Adder.v"

module test;
    parameter   half_period = 50;
    parameter   run_time = 5000;
    integer     i;

    reg             clock;
    reg     [31:0]  PCInput;
    wire    [31:0]  PCValue;

    wire    [31:0]  PCOutput, Instr, SignExtImm, RFReadData1, RFReadData2,
                    ALUOperand2, ALUResult, DMReadData, RFWriteData, PCPlus4, 
                    JumpAddr, RelativeAddr, BranchAddr, NonJumpAddr;
    wire    [5:0]   Opcode, funct;
    wire    [4:0]   InstrRs, InstrRt, InstrRd, RFWriteReg;
    wire    [15:0]  Immediate;
    wire            RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
                    Beq, ALUZero, ALUNonZero, BeqTarget, BneTarget, BranchTarget, print;
    wire    [1:0]   ALUOp;
    wire    [3:0]   ALUOperation; 
    wire    [27:0]  JumpPreAddr1, JumpPreAddr2;
    reg     [5:0]   clockNum = 0;

    assign          JumpPreAddr1    = {2'b0, Instr[25:0]};
    assign          Opcode          = Instr[31:26];
    assign          InstrRs         = Instr[25:21];
    assign          InstrRt         = Instr[20:16];
    assign          InstrRd         = Instr[15:11];
    assign          funct           = Instr[5:0];
    assign          Immediate       = Instr[15:0];
    assign          print           = clock;
    assign          ALUNonZero      = ~ALUZero;
    assign          JumpAddr        = { PCPlus4[31:28], JumpPreAddr2 };
    assign          PCValue         = PCOutput;
    
    PC                  pc      ( PCInput, clock, PCOutput );
    Instruction_Memory  im      ( PCOutput, Instr );
    ALU_Adder           adder1  ( PCOutput, 4, PCPlus4 );
    Control             control ( Opcode, RegDst, Jump, Branch, MemRead, MemtoReg, 
                                  ALUOp, MemWrite, ALUSrc, RegWrite, Beq );
    Shifter # ( 28 )    shftr1  ( JumpPreAddr1, JumpPreAddr2 );
    Mux_2_1 # ( 5 )     mux1    ( InstrRt, InstrRd, RegDst, RFWriteReg );
    Register_File       rf      ( RegWrite, InstrRs, InstrRt, RFWriteReg, RFWriteData, 
                                  RFReadData1, RFReadData2, print );
    Sign_Extension      snext   ( Immediate, SignExtImm );
    Mux_2_1             mux2    ( RFReadData2, SignExtImm, ALUSrc, ALUOperand2 );
    ALU_Control         aluctrl ( funct, ALUOp, ALUOperation );
    ALU_32              alu     ( RFReadData1, ALUOperand2, ALUOperation, ALUResult, ,
                                  ALUZero );
    Shifter # ( 32 )    shftr2  ( SignExtImm, RelativeAddr );
    ALU_Adder           adder2  ( PCPlus4, RelativeAddr, BranchAddr );
    and                 and1    ( BeqTarget, Branch, ALUZero );
    and                 and2    ( BneTarget, Branch, ALUNonZero );
    Mux_2_1 # ( 1 )     mux3    ( BneTarget, BeqTarget, Beq, BranchTarget );
    Mux_2_1 # ( 32 )    mux4    ( PCPlus4, BranchAddr, BranchTarget, NonJumpAddr );
    // Mux_2_1 # ( 32 )    mux5    ( NonJumpAddr, JumpAddr, Jump, PCInput );
    Data_Memory         dm      ( ALUResult, RFReadData2, MemWrite, MemRead, DMReadData, clock );
    Mux_2_1 # ( 32 )    mux6    ( ALUResult, DMReadData, MemtoReg, RFWriteData );

    initial
    begin
        #0      clock = 1; 
        PCInput = 0;
        $display( "PC = ", PCOutput );
        $display( "Instr = %b", Instr );
        $display( "clock: %2d", clockNum );
        $display( "InstrRs = %b, InstrRt = %b, InstrRd = %b", InstrRs, InstrRt, InstrRd );
        // $monitor( "time: %d", $time );
        $display( "Opcode = %b, Branch = %b", Opcode, Branch );
        $display( "DMReadData = %h, MemtoReg = %b", DMReadData, MemtoReg );
        $display( "DMReadData = %h, MemRead = %b, MemWrite = %b", DMReadData, MemRead, MemWrite );
        $display( "ALUOperand2 = %h, ALUOperation = %b, ALUResult = %h", ALUOperand2, ALUOperation, ALUResult );
        $display( 
            "RFReadData1 = %h, RFReadData2 = %h, RegWrite = %b, InstrRs = %b, InstrRt = %b, RFWriteReg = %b, RFWriteData = %h", 
            RFReadData1, RFReadData2, RegWrite, InstrRs, InstrRt, RFWriteReg, RFWriteData
        );
        // $display( "Time: %4d, CLKCount = %2d, clock = %b, PC = %h, Instr = %h", $time, clockNum, clock, PCValue, Instr );
        $display( "===============================================" );
        for ( i = 16; i <= 23; i = i + 1 )
        begin
            $write ( "[$s%1d] = %h  ", i - 16, rf.registerMem[i] );
            if  ( i == 18 || i == 21 )
                $display( "" );
        end
        for ( i = 8; i <= 15; i = i + 1 )
        begin
            $write ( "[$t%1d] = %h  ", i - 8, rf.registerMem[i] );
            if  ( i == 8 || i == 11 || i == 14 )
                $display( "" );
        end
        $write ( "[$t8] = %h  ", rf.registerMem[24] );
        $write ( "[$t9] = %h  ", rf.registerMem[25] );
        $display( "" );
        $display( "" );
    end

    always
    begin
        #half_period
            clock = ~clock;
    end

    always @ ( negedge clock )
        PCInput = PCInput + 4;

    always
        # (2*half_period)
    begin
        clockNum = clockNum + 1;
        $display( "PC = ", PCOutput );
        $display( "Instr = %b", Instr );
        $display( "clock: %2d", clockNum );
        $display( "InstrRs = %b, InstrRt = %b, InstrRd = %b", InstrRs, InstrRt, InstrRd );
        // $monitor( "time: %d", $time );
        $display( "Opcode = %b, Branch = %b", Opcode, Branch );
        $display( "DMReadData = %h, MemtoReg = %b", DMReadData, MemtoReg );
        $display( "DMReadData = %h, MemRead = %b, MemWrite = %b", DMReadData, MemRead, MemWrite );
        $display( "ALUOperand2 = %h, ALUOperation = %b, ALUResult = %h", ALUOperand2, ALUOperation, ALUResult );
        $display( 
            "RFReadData1 = %h, RFReadData2 = %h, RegWrite = %b, InstrRs = %b, InstrRt = %b, RFWriteReg = %b, RFWriteData = %h", 
            RFReadData1, RFReadData2, RegWrite, InstrRs, InstrRt, RFWriteReg, RFWriteData
        );
        // $display( "Time: %4d, CLKCount = %2d, clock = %b, PC = %h, Instr = %h", $time, clockNum, clock, PCValue, Instr );
        $display( "===============================================" );
        for ( i = 16; i <= 23; i = i + 1 )
        begin
            $write ( "[$s%1d] = %h  ", i - 16, rf.registerMem[i] );
            if  ( i == 18 || i == 21 )
                $display( "" );
        end
        for ( i = 8; i <= 15; i = i + 1 )
        begin
            $write ( "[$t%1d] = %h  ", i - 8, rf.registerMem[i] );
            if  ( i == 8 || i == 11 || i == 14 )
                $display( "" );
        end
        $write ( "[$t8] = %h  ", rf.registerMem[24] );
        $write ( "[$t9] = %h  ", rf.registerMem[25] );
        $display( "" );
        $display( "" );
    end

    initial     #run_time       $finish;
endmodule