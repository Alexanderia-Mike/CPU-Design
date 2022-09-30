`include "Pipeline_CPU.v"

module Pipeline_CPU_Sim;
    parameter       half_period = 50;
    parameter       finish_time = 1000;

    reg     clock;
    reg     [4:0]   RegFile_Address;

    wire    [31:0]  RegOut, PCOut;

    Pipeline_CPU    cpu     ( clock, RegFile_Address, RegOut, PCOut );

    initial
    begin
        # 0     clock = 1; RegFile_Address = 5'b01001;
        // #140    
    end

    always  # half_period       clock = ~clock;

    integer         i, j;
    initial         i = 0;

    // initial
        // $display( 
        //     "initially, PC = %h, IDJumpTarget = %h, IDNonJumpTarget = %h, NextPC = %h", 
        //     cpu.IF.pc.currentInstrAddr, cpu.IF.IDJumpTarget, cpu.IF.IDNonJumpTarget, cpu.IF.NextPC
        // );

    // always @ ( posedge clock )
    //     $display( 
    //         "Posedge! PC = %h, IDJumpTarget = %h, IDNonJumpTarget = %h, NextPC = %h", 
    //         cpu.IF.pc.currentInstrAddr, cpu.IF.IDJumpTarget, cpu.IF.IDNonJumpTarget, cpu.IF.NextPC
    //     );

    always  @ ( clock ) 
    begin
        i = i + 1;
        # ( 10 )
        // $display( "between %d and %d clock, ", i - 1, i );
        // $display(
        //     "cpu: PCOut = %h, RegOut = %h, PCOut in IFStage = %h", 
        //     PCOut, RegOut, cpu.IF.CurrentPC
        // );
        // $display( 
        //     "IF: PC = %h, Instr = %h, NextPC = %h, PCWrite = %b", 
        //     cpu.IF.pc.currentInstrAddr, cpu.IF.IFInstr, cpu.IF.NextPC, cpu.IF.IFPCWrite
        // );
        // $display( 
        //     "ID: forward1 = %b, forward2 = %b, IDReadData1 = %h, IDReadData2 = %h, Equal = %b, BranchOrNot = %b, IDRs = %b, IDRt = %b, IFIDInstr = %h, IDJumpTarget = %h, IDNonJumpTarget = %h, IDBranch = %b, IDJump = %b, IFIDFlush = %b",
        //     cpu.ID.forward1, cpu.ID.forward2, cpu.ID.IDReaddata1, cpu.ID.IDReaddata2, cpu.ID.Equal, cpu.ID.BranchOrNot, cpu.ID.IDRs, cpu.ID.IDRt, cpu.ID.IFIDInstr, cpu.ID.IDJumpTarget, cpu.ID.IDNonJumpTarget, cpu.ID.IDBranch, 
        //     cpu.ID.IDJump, cpu.ID.IFIDFlush
        // );
        // $display(
        //     "Hazard: IDEXRegWrite = %b, IDBranch = %b, EXDst = %b, IDRs = %b, IDRt = %b, EXMEMDst = %b, forward1 = %b, forward2 = %b",
        //     cpu.HD.IDEXRegWrite, cpu.HD.IDBranch, cpu.HD.EXDst, cpu.HD.IDRs, cpu.HD.IDRt, cpu.HD.EXMEMDst, cpu.HD.forward1, cpu.HD.forward2
        // );
        // $display(
        //     "EX: IDEXImm = %h, IDEXRs = %b, IDEXRt = %b, IDEXRd = %b, IDEXRegWrite = %b, IDEXMemtoReg = %b, IDEXALUSrc = %b, IDEXMemWrite = %b, IDEXRegDst = %b, IDEXMemRead = %b, IDEXALUOp = %b, IDEXReadData1 = %h, IDEXReadData2 = %h, EXDst = %b",
        //     cpu.ID.IDEXImm, cpu.ID.IDEXRs, cpu.ID.IDEXRt, cpu.ID.IDEXRd, cpu.ID.IDEXRegWrite, cpu.ID.IDEXMemtoReg, cpu.ID.IDEXALUSrc, cpu.ID.IDEXMemWrite, cpu.ID.IDEXRegDst, cpu.ID.IDEXMemRead, 
        //     cpu.ID.IDEXALUOp, cpu.ID.IDEXReadData1, cpu.ID.IDEXReadData2, cpu.EX.EXDst, 
        // );
        // $display(
        //     "MEM: EXMEMRegWrite = %b, EXMEMDst = %b, EXMEMReadAddress = %h, EXMEMWriteData = %h, EXMEMMemtoReg = %b, EXMEMMemRead = %b, EXMEMMemWrite = %b, MEM.EXMEMDst = %b, EXMEMMemRead = %b, MEM.EXMEMMemRead = %b",
        //     cpu.EX.EXMEMRegWrite, cpu.EX.EXMEMDst, cpu.EX.EXMEMReadAddress, cpu.EX.EXMEMWriteData, cpu.EX.EXMEMMemtoReg, cpu.EX.EXMEMMemRead, 
        //     cpu.EX.EXMEMMemWrite, cpu.MEM.MEM.EXMEMDst, cpu.MEM.EXMEMMemRead, cpu.MEM.MEM.EXMEMMemRead
        // );
        // $display(
        //     "WB: MEMWBRegWrite = %b, MEMWBMemtoReg = %b, MEMWBReadData = %h, MEMWBALUResult = %h, MEMWBDst = %b, MEMWBWriteData = %h",
        //     cpu.MEM.MEMWBRegWrite, cpu.MEM.MEMWBMemtoReg, 
        //     cpu.MEM.MEMWBReadData, cpu.MEM.MEMWBALUResult, cpu.MEM.MEMWBDst, cpu.WB.MEMWBWriteData
        // );
        

        $display( "===============================================" );
        $display( "Time: %3d, CLK = %b, PC = %h", $time, clock, cpu.IF.pc.currentInstrAddr );
        for ( j = 16; j <= 23; j = j + 1 )
        begin
            $write ( "[$s%1d] = %h  ", j - 16, cpu.ID.rf.registerMem[j] );
            if  ( j == 18 || j == 21 )
                $display( "" );
        end
        for ( j = 8; j <= 15; j = j + 1 )
        begin
            $write ( "[$t%1d] = %h  ", j - 8, cpu.ID.rf.registerMem[j] );
            if  ( j == 8 || j == 11 || j == 14 )
                $display( "" );
        end
        $write ( "[$t8] = %h  ", cpu.ID.rf.registerMem[24] );
        $write ( "[$t9] = %h  ", cpu.ID.rf.registerMem[25] );
        $display( "" );
        $display( "" );

    end

    initial # finish_time       $finish;

endmodule