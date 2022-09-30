module Control 
( opcode, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Beq );
    input       [5:0]   opcode;
    output  reg [1:0]   ALUOp;
    output  reg         RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Beq;

    initial
    begin
        ALUOp = 2'b00; RegDst = 0; Jump = 0; Branch = 0; MemRead = 0; 
        MemtoReg = 0; MemWrite = 0; ALUSrc = 0; RegWrite = 0; Beq = 0;
    end

    always @ (opcode)
    begin
        case (opcode)
            6'b100011: // 23, lw
                begin
                    ALUOp = 2'b00; RegDst = 0; Jump = 0; Branch = 0; MemRead = 1;
                    MemtoReg = 1; MemWrite = 0; ALUSrc = 1; RegWrite = 1; Beq = 0;
                end
            6'b101011: // 2b, sw
                begin
                    ALUOp = 2'b00; RegDst = 0; Jump = 0; Branch = 0; MemRead = 0; 
                    MemtoReg = 0; MemWrite = 1; ALUSrc = 1; RegWrite = 0; Beq = 0;
                end
            6'b000000: // 00, R-type
                begin
                    ALUOp = 2'b10; RegDst = 1; Jump = 0; Branch = 0; MemRead = 0; 
                    MemtoReg = 0; MemWrite = 0; ALUSrc = 0; RegWrite = 1; Beq = 0;
                end
            6'b001000: // 08, addi
                begin
                    ALUOp = 2'b00; RegDst = 0; Jump = 0; Branch = 0; MemRead = 0; 
                    MemtoReg = 0; MemWrite = 0; ALUSrc = 1; RegWrite = 1; Beq = 0;
                end
            6'b001100: // 0c, andi
                begin
                    ALUOp = 2'b11; RegDst = 0; Jump = 0; Branch = 0; MemRead = 0; 
                    MemtoReg = 0; MemWrite = 0; ALUSrc = 1; RegWrite = 1; Beq = 0;
                end
            6'b000100: // 04, beq
                begin
                    ALUOp = 2'b01; RegDst = 0; Jump = 0; Branch = 1; MemRead = 0; 
                    MemtoReg = 0; MemWrite = 0; ALUSrc = 0; RegWrite = 0; Beq = 1;
                end
            6'b000101: // 05, bne
                begin
                    ALUOp = 2'b01; RegDst = 0; Jump = 0; Branch = 1; MemRead = 0; 
                    MemtoReg = 0; MemWrite = 0; ALUSrc = 0; RegWrite = 0; Beq = 1;
                end
            6'b000010: // 02, j
                begin
                    ALUOp = 2'b00; RegDst = 0; Jump = 1; Branch = 0; MemRead = 0; 
                    MemtoReg = 0; MemWrite = 0; ALUSrc = 0; RegWrite = 0; Beq = 0;
                end
            default: 
                begin
                    ALUOp = 2'b00; RegDst = 0; Jump = 0; Branch = 0; MemRead = 0; 
                    MemtoReg = 0; MemWrite = 0; ALUSrc = 0; RegWrite = 0; Beq = 0;
                end
        endcase
    end
endmodule