`timescale 1ns / 1ps

module Control(
    instruction, RegDst, Branch, BranchOrNot, MemRead, MemtoReg, ALUOp, MemWrite, 
    ALUSrc, RegWrite, jump, equal
);
    input       [5:0]   instruction;
    input               equal;    
    output reg          RegDst;
    output reg          Branch; 
    output reg          BranchOrNot;
    output reg          MemRead;
    output reg          MemtoReg;
    output reg  [1:0]   ALUOp;
    output reg          MemWrite;
    output reg          ALUSrc;
    output reg          RegWrite;
    output reg          jump;

    reg                 Branch_Beq;
    reg                 Branch_Bne; 

    initial
    begin
        RegDst = 1; Branch = 0; BranchOrNot = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b10;
        MemWrite = 0; ALUSrc = 0; RegWrite = 1; jump = 0; Branch_Beq = 0; Branch_Bne = 0;
    end

    always @(instruction)
    begin 
        case (instruction)
        //R-type
            6'b000000:
            begin
                RegDst = 1; Branch_Beq = 0; Branch_Bne = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b10;
                MemWrite = 0; ALUSrc = 0; RegWrite = 1; jump = 0;
            end
            
        //addi 
            6'b001000:
            begin
                RegDst = 0; Branch_Beq = 0; Branch_Bne = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00;
                MemWrite = 0; ALUSrc = 1; RegWrite = 1; jump = 0;   
            end

        //sw
            6'b101011:
            begin
                RegDst = 0; Branch_Beq = 0; Branch_Bne = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00;
                MemWrite = 1; ALUSrc = 1; RegWrite = 0; jump = 0;   
            end

        //lw
            6'b100011:
            begin
                RegDst = 0; Branch_Beq = 0; Branch_Bne = 0; MemRead = 1; MemtoReg = 1; ALUOp = 2'b00;
                MemWrite = 0; ALUSrc = 1; RegWrite = 1; jump = 0;   
            end

        //andi
            6'b001100:
            begin
                RegDst = 0; Branch_Beq = 0; Branch_Bne = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b11;
                MemWrite = 0; ALUSrc = 1; RegWrite = 1; jump = 0;   
            end

        //j
            6'b000010:
            begin
                RegDst = 0; Branch_Beq = 0; Branch_Bne = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00;
                MemWrite = 0; ALUSrc = 0; RegWrite = 0; jump = 1;   
            end

        //beq
            6'b000100:
            begin
                RegDst = 0; Branch_Beq = 1; Branch_Bne = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b01;
                MemWrite = 0; ALUSrc = 0; RegWrite = 0; jump = 0;   
            end

        //bne
            6'b000101:
            begin
                RegDst = 0; Branch_Beq = 0; Branch_Bne = 1; MemRead = 0; MemtoReg = 0; ALUOp = 2'b01;
                MemWrite = 0; ALUSrc = 0; RegWrite = 0; jump = 0;
            end

            default 
            begin
                RegDst = 0; Branch_Beq = 0; Branch_Bne = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00;
                MemWrite = 0; ALUSrc = 0; RegWrite = 0; jump = 0; 
            end
        endcase
    end

    always @ ( Branch_Beq, Branch_Bne, equal )
    begin
        // BranchOrNot
        if ( 
            ( Branch_Beq && equal ) ||
            ( Branch_Bne && ~equal )
        )
                BranchOrNot = 1;
        else    BranchOrNot = 0;
        // Branch
        if ( Branch_Beq || Branch_Bne )
                Branch = 1;
        else    Branch = 0;
    end
endmodule  
