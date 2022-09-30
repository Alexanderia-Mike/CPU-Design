module Mux_3to1(in1, in2, in3,control, out);
input [31:0] in1;
input [31:0] in2;
input [31:0] in3;
input control;
output reg [31:0] out;

always@(in1 or in2 or in3 or control)
begin
    case(control)
    2'b00: out = in1;
    2'b01: out = in2;
    2'b10: out = in3;
    default out = in1;
    endcase
end
endmodule