`include "Register_File.v"

module Register_File_Sim (  );

    reg     [4:0]   ReadReg1, ReadReg2, WriteReg;
    reg     [31:0]  WriteData;
    reg             print, RegWrite;
    wire    [31:0]  ReadData1, ReadData2;

    Register_File rf  ( RegWrite, ReadReg1, ReadReg2, WriteReg, WriteData, 
                        ReadData1, ReadData2, print );
    
    initial
    begin
        #0      WriteReg = 16; ReadReg1 = 0; ReadReg2 = 2; WriteData = 12; print = 0; RegWrite = 1;
        #50     $display( "[%d] = %h, [%d] = %h", ReadReg1, ReadData1, ReadReg2, ReadData2 ); // should be both 0
                WriteReg = 0; ReadReg1 = 1; ReadReg2 = 2; WriteData = 0; print = 1; RegWrite = 0;
        #50     $display( "[%d] = %h, [%d] = %h", ReadReg1, ReadData1, ReadReg2, ReadData2 ); // should be c and 0
                WriteReg = 17; ReadReg1 = 0; ReadReg2 = 1; WriteData = 8; print = 0; RegWrite = 1;
        #50     $display( "[%d] = %h, [%d] = %h", ReadReg1, ReadData1, ReadReg2, ReadData2 ); // should be 8 and c
    end

    initial     #200    $finish;

endmodule