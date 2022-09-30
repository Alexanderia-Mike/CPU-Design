`timescale 1ns / 1ps

module ALU_32 ( a, b, operation, result, overflow, zero );
    input       [31:0]  a, b;
    input       [3:0]   operation;
    output  reg [31:0]  result;
    output  reg         overflow, zero;

    wire            set;
    wire    [31:0]  carryOut;
    wire            aInvert, bNegate;
    
    initial
    begin
        result = 0;
        overflow = 0;
        zero = 0;
    end
    
    always @ ( a, b, operation )
    begin
        case ( operation )
            4'b0000:    result = a & b;
            4'b0001:    result = a | b;
            4'b0010:    result = a + b;
            4'b0110:    result = a - b;
            4'b0111:    result = a < b ? 1 : 0;
            default:    result = 0;
        endcase
    end

    always @ ( a, b )
        zero = a == b ? 1 : 0;
    
    always @ ( a, b )   overflow = 0;
endmodule
