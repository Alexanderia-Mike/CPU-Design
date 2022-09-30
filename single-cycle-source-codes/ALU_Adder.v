// `include "ALU_32.v"

module ALU_Adder ( Operand1, Operand2, Result );
    input   [31:0]  Operand1, Operand2;
    output  [31:0]  Result;

    ALU_32  adder ( Operand1, Operand2, 4'b0010, Result, ,  );
endmodule0;
    
    always @ ( Operand1, Operand2 )
        Result = Operand1 + Operand2;
endmodule