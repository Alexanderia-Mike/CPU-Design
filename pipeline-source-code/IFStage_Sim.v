`include "IFStage.v"

module IFStage_Sim;
    parameter       half_period = 50;
    parameter       finish_time = 700;

    reg     [31:0]  IDJumpTarget, IDNonJumpTarget;
    reg             IFIDFlush, IDJump, IFIDWrite, IFPCWrite, clock;

    wire    [31:0]  IFIDPCPlus4, IDInstr, IFPCPlus4Out;

    IFStage     IF  ( IDJumpTarget, IFIDFlush, IDNonJumpTarget, IDJump, IFPCPlus4Out, 
                    IFIDPCPlus4, IDInstr, IFIDWrite, IFPCWrite, clock );

    initial
    begin
        # 0     IDJumpTarget = 0; IDNonJumpTarget = 0; IFIDFlush = 0; IDJump = 0;
                IFIDWrite = 1; IFPCWrite = 1; clock = 1;
        # 40    IDJump = 1; IDJumpTarget = 40; IDNonJumpTarget = 80; 
        # 100   IFIDFlush = 1;
        # 100   IFIDFlush = 0;
        # 100   IDJumpTarget = 92; IFPCWrite = 0;
        # 100   IFIDWrite = 0; IFPCWrite = 1;
        # 100   IFIDWrite = 1;
    end

    always  # half_period       clock = ~clock;

    integer         i;
    initial         i = 0;

    always  @ ( posedge clock ) 
    begin
        i = i + 1;
        # half_period   
        $display( 
            "between %d and %d clock, IFIDPCPlus4 = %h, IDInstr = %h, IFPCPlus4Out = %h", 
            i - 1, i, IFIDPCPlus4, IDInstr, IFPCPlus4Out 
        );
        $display(
            "IFPCPlus4 = %h,    PC in IF = %h", 
            IF.IFPCPlus4,       IF.CurrentPC
        );
    end

    initial # finish_time       $finish;
endmodule