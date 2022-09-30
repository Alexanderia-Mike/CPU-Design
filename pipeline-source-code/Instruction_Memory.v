module Instruction_Memory ( readAddr, instruction );
    input       [31:0]  readAddr;
    output  reg [31:0]  instruction;

    reg         [7:0]   memory  [0:255][0:3];         // 256 instructions maximum

    integer             i;

    initial
    begin
        instruction = 0;
        // initialize to be zero
        // { memoryr[0][3], memory[0][2], memory[0][1], memory[0][0] } 
        //     = 32'b00100000000010010000000000000010; // addi $t1, $0, 2
        // { memoryr[1][3], memory[1][2], memory[1][1], memory[1][0] } 
        //     = 32'b00100001000010000000000000000001; // addi $t0, $t0, 1
        // { memoryr[2][3], memory[2][2], memory[2][1], memory[2][0] } 
        //     = 32'b00010101000010011111111111111110; // bne $t0, $t1, Last
        for ( i = 0; i < 64; i = i+1 ) 
        begin
            memory[i][3] = 0;
            memory[i][2] = 0;
            memory[i][1] = 0;
            memory[i][0] = 0;
        end
        // read the file
        // $readmemb( "InstructionMem_for_P2_Demo.txt", memory );
        // $readmemb( "InstructionMem_for_P2_Demo_bonus.txt", memory );
        $readmemb( "bne_test.txt", memory );

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


// addi $t1, $0,  2 # pc = 0
// Last:
// addi $t0, $t0, 1 # pc = 4
// bne  $t0, $t1, Last # pc = 8
// EXIT: