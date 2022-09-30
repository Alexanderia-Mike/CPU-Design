module Register_File 
( clock, RegWrite, ReadReg1, ReadReg2, WriteReg, WriteData, ReadData1, ReadData2, RegFile_Address, RegOutOutOut );
    input       [4:0]   ReadReg1, ReadReg2, WriteReg, RegFile_Address;
    input       [31:0]  WriteData;
    input               clock, RegWrite;
    output  reg [31:0]  ReadData1, ReadData2;
    output      [31:0]  RegOutOutOut;

    assign  RegOutOutOut = registerMem[RegFile_Address];

    reg         [31:0]  registerMem    [31:0];
    integer             i; 

    initial
    begin
        ReadData1 = 0; ReadData2 = 0;
        for ( i = 0; i < 32; i = i + 1 ) 
            registerMem[i] = 0; // initialize to be zeros
    end
    
    always @ ( ReadReg1, ReadReg2, registerMem[ReadReg1], registerMem[ReadReg2] )
    begin
        ReadData1 = registerMem[ReadReg1];
        ReadData2 = registerMem[ReadReg2];
    end

    always @ ( negedge clock )
    begin
        if ( RegWrite )
        begin
            registerMem[WriteReg] = WriteData;
        end
    end
endmodule