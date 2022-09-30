`timescale 1ns / 1ps

module registerFile( 
    clock, RegWrite, ReadReg1, ReadReg2, WriteRegAddr, WriteData, ReadData1, ReadData2 
);
    input           clock;
    input           RegWrite;
    input   [4:0]   ReadReg1, ReadReg2, WriteRegAddr;
    input   [31:0]  WriteData;
    output  [31:0]  ReadData1, ReadData2;

    reg     [31:0]  registers[0:31];

    integer         i;
    initial 
    begin
        for (i=0; i<32; i=i+1)
            registers[i]=32'b0;
    end

    assign ReadData1 = registers[ReadReg1];
    assign ReadData2 = registers[ReadReg2];
    always @ (negedge clock) 
    begin
        if (RegWrite==1'b1)
            registers[WriteRegAddr] = WriteData;
        $display("[$s0] = %h, [$s1] = %h, [$s2] = %h", registers[16], registers[17], registers[18]);
        $display("[$s3] = %h, [$s4] = %h, [$s5] = %h", registers[19], registers[20], registers[21]);
        $display("[$s6] = %h, [$s7] = %h, [$t0] = %h", registers[22], registers[23], registers[8]);
        $display("[$t1] = %h, [$t2] = %h, [$t3] = %h", registers[9], registers[10], registers[11]);
        $display("[$t4] = %h, [$t5] = %h, [$t6] = %h", registers[12], registers[13], registers[14]);
        $display("[$t7] = %h, [$t8] = %h, [$t9] = %h", registers[15], registers[24], registers[25]);
        $display("////////////////////////////////////////////");
    end
endmodule
