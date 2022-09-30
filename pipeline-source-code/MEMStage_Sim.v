`include "MEMStage.v"

module MEMtage_Sim;
    parameter       half_period = 50;
    parameter       finish_time = 750;

    reg             EXMEMMemWrite, EXMEMMemRead, EXMEMRegWrite, EXMEMMemtoReg, clock;
    reg     [31:0]  EXMEMWriteData, EXMEMALUResult;
    reg     [4:0]   EXMEMDst;
    
    wire            EXMEMMemReadOut, EXMEMRegWriteOut;
    wire    [4:0]   EXMEMDstOut;
    wire            MEMWBRegWrite, MEMWBMemtoReg;
    wire    [31:0]  MEMWBReadData, MEMWBALUResult;
    wire    [4:0]   MEMWBDst;
    wire    [31:0]  EXMEMALUResultOut;

    MEMStage    MEM ( EXMEMDst, EXMEMMemWrite, EXMEMMemRead, EXMEMRegWrite, EXMEMMemtoReg, 
                    EXMEMWriteData, EXMEMALUResult, EXMEMMemReadOut, EXMEMRegWriteOut, 
                    EXMEMDstOut, MEMWBRegWrite, MEMWBMemtoReg, MEMWBReadData, MEMWBALUResult, 
                    MEMWBDst, EXMEMALUResultOut, clock );

    initial
    begin
        # 0     EXMEMDst = 5'b01010; EXMEMMemWrite = 1; EXMEMMemRead = 0; EXMEMRegWrite = 1;
                EXMEMMemtoReg = 1; EXMEMWriteData = 32'h12348765; EXMEMALUResult = 0; clock = 1; 
        # 140   EXMEMMemWrite = 0; EXMEMMemRead = 1; EXMEMRegWrite = 0; EXMEMMemtoReg = 0; 
                EXMEMALUResult = 12;
    end

    always  # half_period       clock = ~clock;

    integer         i;
    initial         i = 0;

    always  @ ( posedge clock ) 
    begin
        i = i + 1;
        # half_period   
        $display( 
            "between %d and %d clock, EXMEMDstOut = %b, MEM.EXMEMDst = %b, EXMEMMemReadOut = %b, EXMEMMemRead = %b, MEM.EXMEMMemRead = %b, EXMEMRegWriteOut = %b, MEMWBRegWrite = %b, MEMWBMemtoReg = %b, MEMWBReadData = %h, MEMWBALUResult = %h, MEMWBDst = %b, EXMEMALUResultOut = %h", 
            i - 1, i, EXMEMDstOut, MEM.EXMEMDst, EXMEMMemReadOut, EXMEMMemRead, MEM.EXMEMMemRead, EXMEMRegWriteOut, MEMWBRegWrite, MEMWBMemtoReg, MEMWBReadData, MEMWBALUResult, MEMWBDst, EXMEMALUResultOut
        );
    end

    initial # finish_time       $finish;
endmodule