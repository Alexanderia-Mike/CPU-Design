module Hazard_Detection ( 
    IDBranch, IDEXRegWrite, EXMEMRegWrite, EXDst, EXMEMDst, IDEXMemRead, IDEXRt, 
    IDRs, IDRt, PCWrite, IFIDWrite, Hazard, EXMEMMemRead, forward1, forward2
);
    input               IDEXMemRead, IDBranch, EXMEMRegWrite, EXMEMMemRead, IDEXRegWrite;
    input       [4:0]   IDEXRt, IFIDRs, IFIDRt, EXDst, EXMEMDst, IDRs, IDRt;
    output  reg         PCWrite, IFIDWrite, Hazard;
    output  reg         forward1, forward2;

    always @ ( IDEXMemRead, IDEXRt, IDRs, IDRt, EXMEMMemRead, IDBranch, IDEXRegWrite, EXDst )
    begin
        if    
        // lw data hazard, insert one stall
              ( ( IDEXMemRead && ( IDEXRt == IDRs || IDEXRt == IDRt ) ) || 
        // case 4
                ( EXMEMMemRead && IDBranch && ( EXMEMDst == IDRs || EXMEMDst == IDRt ) ) ||
        // case 1 and case 3
                ( IDEXRegWrite && IDBranch && ( EXDst == IDRs || EXDst == IDRt ) ) )
        begin
            PCWrite     = 0;
            IFIDWrite   = 0;
            Hazard      = 1;
        end
        else // no hazard
        begin
            PCWrite = 1; 
            IFIDWrite = 1; 
            Hazard = 0;
        end
    end

    always @ ( EXMEMRegWrite, EXMEMMemRead, IDBranch, EXMEMDst, IDRs, IDRt )
        // case 2
        if ( EXMEMRegWrite && !EXMEMMemRead && IDBranch ) 
        begin
            if ( EXMEMDst == IDRs )		
                begin   forward1 = 1; forward2 = 0; end
            else if ( EXMEMDst == IDRt )		
                begin   forward2 = 1; forward1 = 0; end
            else
                begin   forward1 = 0; forward2 = 0; end
        end
        else
        begin
            forward1 = 0;
            forward2 = 0;
        end

endmodule