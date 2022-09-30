`include "ALU_32.v"

module ALU_32_Sim ();
    reg     [31:0]  a, b;
    reg     [3:0]   operation;
    wire    [31:0]  result;
    wire            overflow, zero;

    ALU_32  aha ( a, b, operation, result, overflow, zero );

    initial 
    begin
        #0      a = 0; b = 32; operation = 4'b0010; 
        #100    a = 20;
                $display( "result = %h", result );
        #100    $display( "result = %h", result );
    end

    initial #500    $finish;
endmodule