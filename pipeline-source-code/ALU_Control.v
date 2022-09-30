module ALU_Control ( funct, ALUOp, ALUOperation );
    input       [5:0]   funct;
    input       [1:0]   ALUOp;
    output  reg [3:0]   ALUOperation;

    initial ALUOperation = 0;

    always @ ( funct, ALUOp )
        case (ALUOp)
            2'b00:  ALUOperation = 4'b0010; // add
            2'b01:  ALUOperation = 4'b0110; // subtract
            2'b11:  ALUOperation = 4'b0000; // and
            default: // 2'b10
            begin
                case (funct)
                    6'b100000:  ALUOperation = 4'b0010; // add 
                    6'b100010:  ALUOperation = 4'b0110; // subtract
                    6'b100100:  ALUOperation = 4'b0000; // and
                    6'b100101:  ALUOperation = 4'b0001; // or
                    6'b101010:  ALUOperation = 4'b0111; // slt
                    default:    ALUOperation = 0;       // don't cares
                endcase
            end
        endcase
endmodule