module Instruction_Memory ( readAddr, instruction );
    input       [31:0]  readAddr;
    output  reg [31:0]  instruction;

    reg         [7:0]   memory  [0:63][0:3];         // 64 instructions maximum

    integer             i;

    initial
    begin
        instruction = 0;
        // initialize to be zero
        for ( i = 0; i < 64; i = i+1 ) 
        begin
            memory[i][3] = 0;
            memory[i][2] = 0;
            memory[i][1] = 0;
            memory[i][0] = 0;
        end
        // read the file
        $readmemb( "InstructionMem_for_P2_Demo.txt", memory );

         // display the content
        //  for ( i = 0; i < 64; i = i + 1 )
        //      $display ( memory[i][0], memory[i][1], memory[i][2], memory[i][3],  );
    end

    always @ (readAddr)
    begin
        instruction = 
        { 
            memory[readAddr[31:2]][0],
            memory[readAddr[31:2]][1],
            memory[readAddr[31:2]][2],
            memory[readAddr[31:2]][3]
        };
    end
endmodule