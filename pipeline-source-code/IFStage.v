`include "Mux_2_1.v"
`include "ALU_Adder.v"
`include "Instruction_Memory.v"
`include "PC.v"

module IFStage ( 
    IDJumpTarget, IFIDFlush, IDNonJumpTarget, IDJump, IFPCPlus4Out, IFIDPCPlus4, 
    IFIDInstr, IFIDWrite, IFPCWrite, clock, PCOut
);
    input       [31:0]  IDJumpTarget, IDNonJumpTarget;
    input               IFIDFlush, IFIDWrite, IFPCWrite, clock, IDJump;

    output reg  [31:0]  IFIDPCPlus4, IFIDInstr;
    output      [31:0]  IFPCPlus4Out;
    output      [31:0]  PCOut;

    assign  IFPCPlus4Out    = IFPCPlus4;
    assign  PCOut           = CurrentPC;

    wire        [31:0]  NextPC, CurrentPC, IFPCPlus4, IFInstr;

    initial
    begin
        IFIDPCPlus4 = 0;
        IFIDInstr = 0;
    end

    Mux_2_1             mux1    ( IDNonJumpTarget, IDJumpTarget, IDJump, NextPC );
    ALU_Adder           adder   ( 4, CurrentPC, IFPCPlus4 );
    Instruction_Memory  im      ( CurrentPC, IFInstr );
    PC                  pc      ( NextPC, clock, CurrentPC, IFPCWrite );

    always @ ( posedge clock )
    begin
        // if ( IFIDFlush )
        // begin
        //     IFIDPCPlus4   = 0;
        //     IFIDInstr     = 0;
        // end
        // else
        // begin
        //     if ( IFIDWrite )
        //     begin
        //         IFIDPCPlus4   = IFPCPlus4;
        //         IFIDInstr     = IFInstr;
        //     end
        // end
        if ( IFIDWrite )
        begin
            if ( IFIDFlush )
                begin
                    IFIDPCPlus4   = 0;
                    IFIDInstr     = 0;
                end
            else
            begin
                IFIDPCPlus4   = IFPCPlus4;
                IFIDInstr     = IFInstr;
            end
        end
    end
endmodule