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
    
//    assign aInvert = operation[3];
//    assign bNegate = operation[2];

//    ALU_1   alu01 (a[0], b[0], set, aInvert, bNegate, bNegate, operation[1:0], result[0], , , carryOut[0]);
//    ALU_1   alu02 (a[1], b[1], 1'b0, aInvert, bNegate, carryOut[0], operation[1:0], result[1], , , carryOut[1]);
//    ALU_1   alu03 (a[2], b[2], 1'b0, aInvert, bNegate, carryOut[1], operation[1:0], result[2], , , carryOut[2]);
//    ALU_1   alu04 (a[3], b[3], 1'b0, aInvert, bNegate, carryOut[2], operation[1:0], result[3], , , carryOut[3]);
//    ALU_1   alu05 (a[4], b[4], 1'b0, aInvert, bNegate, carryOut[3], operation[1:0], result[4], , , carryOut[4]);
//    ALU_1   alu06 (a[5], b[5], 1'b0, aInvert, bNegate, carryOut[4], operation[1:0], result[5], , , carryOut[5]);
//    ALU_1   alu07 (a[6], b[6], 1'b0, aInvert, bNegate, carryOut[5], operation[1:0], result[6], , , carryOut[6]);
//    ALU_1   alu08 (a[7], b[7], 1'b0, aInvert, bNegate, carryOut[6], operation[1:0], result[7], , , carryOut[7]);
//    ALU_1   alu09 (a[8], b[8], 1'b0, aInvert, bNegate, carryOut[7], operation[1:0], result[8], , , carryOut[8]);
//    ALU_1   alu10 (a[9], b[9], 1'b0, aInvert, bNegate, carryOut[8], operation[1:0], result[9], , , carryOut[9]);
//    ALU_1   alu11 (a[10], b[10], 1'b0, aInvert, bNegate, carryOut[9], operation[1:0], result[10], , , carryOut[10]);
//    ALU_1   alu12 (a[11], b[11], 1'b0, aInvert, bNegate, carryOut[10], operation[1:0], result[11], , , carryOut[11]);
//    ALU_1   alu13 (a[12], b[12], 1'b0, aInvert, bNegate, carryOut[11], operation[1:0], result[12], , , carryOut[12]);
//    ALU_1   alu14 (a[13], b[13], 1'b0, aInvert, bNegate, carryOut[12], operation[1:0], result[13], , , carryOut[13]);
//    ALU_1   alu15 (a[14], b[14], 1'b0, aInvert, bNegate, carryOut[13], operation[1:0], result[14], , , carryOut[14]);
//    ALU_1   alu16 (a[15], b[15], 1'b0, aInvert, bNegate, carryOut[14], operation[1:0], result[15], , , carryOut[15]);
//    ALU_1   alu17 (a[16], b[16], 1'b0, aInvert, bNegate, carryOut[15], operation[1:0], result[16], , , carryOut[16]);
//    ALU_1   alu18 (a[17], b[17], 1'b0, aInvert, bNegate, carryOut[16], operation[1:0], result[17], , , carryOut[17]);
//    ALU_1   alu19 (a[18], b[18], 1'b0, aInvert, bNegate, carryOut[17], operation[1:0], result[18], , , carryOut[18]);
//    ALU_1   alu20 (a[19], b[19], 1'b0, aInvert, bNegate, carryOut[18], operation[1:0], result[19], , , carryOut[19]);
//    ALU_1   alu21 (a[20], b[20], 1'b0, aInvert, bNegate, carryOut[19], operation[1:0], result[20], , , carryOut[20]);
//    ALU_1   alu22 (a[21], b[21], 1'b0, aInvert, bNegate, carryOut[20], operation[1:0], result[21], , , carryOut[21]);
//    ALU_1   alu23 (a[22], b[22], 1'b0, aInvert, bNegate, carryOut[21], operation[1:0], result[22], , , carryOut[22]);
//    ALU_1   alu24 (a[23], b[23], 1'b0, aInvert, bNegate, carryOut[22], operation[1:0], result[23], , , carryOut[23]);
//    ALU_1   alu25 (a[24], b[24], 1'b0, aInvert, bNegate, carryOut[23], operation[1:0], result[24], , , carryOut[24]);
//    ALU_1   alu26 (a[25], b[25], 1'b0, aInvert, bNegate, carryOut[24], operation[1:0], result[25], , , carryOut[25]);
//    ALU_1   alu27 (a[26], b[26], 1'b0, aInvert, bNegate, carryOut[25], operation[1:0], result[26], , , carryOut[26]);
//    ALU_1   alu28 (a[27], b[27], 1'b0, aInvert, bNegate, carryOut[26], operation[1:0], result[27], , , carryOut[27]);
//    ALU_1   alu29 (a[28], b[28], 1'b0, aInvert, bNegate, carryOut[27], operation[1:0], result[28], , , carryOut[28]);
//    ALU_1   alu30 (a[29], b[29], 1'b0, aInvert, bNegate, carryOut[28], operation[1:0], result[29], , , carryOut[29]);
//    ALU_1   alu31 (a[30], b[30], 1'b0, aInvert, bNegate, carryOut[29], operation[1:0], result[30], , , carryOut[30]);
//    ALU_1   alu32 (a[31], b[31], 1'b0, aInvert, bNegate, carryOut[30], operation[1:0], result[31], set, , carryOut[31]);

//    assign  zero = ~(|result);
//    xor     (overflow, carryOut[30], carryOut[31]);

    always @ ( a, b )
        zero = a == b ? 1 : 0;
    
    always @ ( a, b )   overflow = 0;
endmodule
