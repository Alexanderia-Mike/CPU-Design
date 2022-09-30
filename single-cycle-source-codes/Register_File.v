module Register_File 
( RegWrite, ReadReg1, ReadReg2, WriteReg, WriteData, ReadData1, ReadData2, print );
    input       [4:0]   ReadReg1, ReadReg2, WriteReg;
    input       [31:0]  WriteData;
    input               print, RegWrite;
    output  reg [31:0]  ReadData1, ReadData2;
    reg         [31:0]  registerMem    [31:0];

    initial
    begin
        ReadData1 = 0; ReadData2 = 0;
    end
    
    integer             i;

    initial
        for ( i = 0; i < 32; i = i + 1 ) 
            registerMem[i] = 0; // initialize to be zeros
    
    always @ ( ReadReg1, ReadReg2, registerMem[ReadReg1], registerMem[ReadReg2] )
    begin
        ReadData1 = registerMem[ReadReg1];
        ReadData2 = registerMem[ReadReg2];
    end

    always @ ( negedge print )
    begin
        if ( RegWrite )
        begin
            registerMem[WriteReg] = WriteData;
        end
    end

endmodule