`include "WBStage.v"

module WBStage_Sim;
    parameter       half_period = 50;
    parameter       finish_time = 700;

    reg     [4:0]   MEMWBDst;
    reg     [31:0]  MEMWBALUResult, MEMWBReadData;
    reg             MEMWBMemtoReg, MEMWBRegWrite, clock;

    wire            MEMWBRegWriteOut;
    wire    [31:0]  MEMWBWriteData;
    wire    [4:0]   MEMWBDstOut;

    WBStage     WB  ( MEMWBRegWriteOut, MEMWBWriteData, MEMWBDstOut, MEMWBDst, 
                    MEMWBALUResult, MEMWBReadData, MEMWBMemtoReg, MEMWBRegWrite, clock );

    initial
    begin
        # 0     MEMWBDst = 5'b01101; MEMWBALUResult = 32'h12357968; MEMWBReadData = 32'h76543210;
                MEMWBMemtoReg = 1; MEMWBRegWrite = 1; clock = 1;
        # 140   MEMWBMemtoReg = 0; MEMWBRegWrite = 0;
    end

    always  # half_period       clock = ~clock;

    integer         i;
    initial         i = 0;

    always  @ ( posedge clock ) 
    begin
        i = i + 1;
        # half_period   
        $display( 
            "between %d and %d clock, MEMWBRegWriteOut = %b, MEMWBWriteData = %h, MEMWBDstOut = %b", 
            i - 1, i,  MEMWBRegWriteOut, MEMWBWriteData, MEMWBDstOut
        );
    end

    initial # finish_time       $finish;
endmodule