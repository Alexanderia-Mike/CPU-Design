// `include "ALU_32.v"

module ALU_Adder ( Operand1, Operand2, Result );
    input       [31:0]  Operand1, Operand2;
    output  reg [31:0]  Result;

    initial Result = 0;
    
    always @ ( Operand1, Operand2 )
        Result = Operand1 + Operand2;
endmodule