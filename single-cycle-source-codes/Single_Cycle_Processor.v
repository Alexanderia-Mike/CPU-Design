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

module Single_Cycle_Processor ( clock );
    input           clock;

    wire    [31:0]  PCInput, PCOutput, SignExtImm, RFReadData1, RFReadData2,
                    ALUOperand2, ALUResult, DMReadData, RFWriteData, PCPlus4, 
                    JumpAddr, RelativeAddr, BranchAddr, NonJumpAddr, PCValue, Instr;
    wire    [5:0]   Opcode, funct;
    wire    [4:0]   InstrRs, InstrRt, InstrRd, RFWriteReg;
    wire    [15:0]  Immediate;
    wire            RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
                    Beq, ALUZero, ALUNonZero, BeqTarget, BneTarget, BranchTarget, print;
    wire    [1:0]   ALUOp;
    wire    [3:0]   ALUOperation; 
    wire    [27:0]  JumpPreAddr1, JumpPreAddr2;

    assign          JumpPreAddr1    = { 2'b0, Instr[25:0]};
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
    Mux_2_1 # ( 32 )    mux5    ( NonJumpAddr, JumpAddr, Jump, PCInput );
    Data_Memory         dm      ( ALUResult, RFReadData2, MemWrite, MemRead, DMReadData, clock );
    Mux_2_1 # ( 32 )    mux6    ( ALUResult, DMReadData, MemtoReg, RFWriteData );
endmodule