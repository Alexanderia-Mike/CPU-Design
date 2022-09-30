module Data_Memory ( Address, WriteData, MemWrite, MemRead, ReadData, clock );
    input       [31:0]  WriteData;
    input       [31:0]  Address;
    input               MemWrite, MemRead, clock;
    output  reg [31:0]  ReadData;

    reg         [31:0]  dataMem [0:1023];   // maximum 1024 data
    integer             i;

    initial
    begin
        ReadData = 0;
        for ( i = 0; i < 1024; i = i + 1 ) 
            dataMem[i] = 0; // initialize to be zeros
    end

    always @ ( negedge clock )
    begin
        if ( MemWrite ) dataMem[Address[31:2]] = WriteData; 
        else            ;
    end
    
    always @( Address, MemRead, dataMem[Address[31:2]] )
        if ( MemRead )  ReadData = dataMem[Address[31:2]];
        else            ReadData = 0;
endmodule