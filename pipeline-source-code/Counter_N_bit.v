module Counter_N_bit(
    CE, reset, clock, load, Data_in, count // asynchronous reset
);
    parameter N = 9;
    input clock, reset, load, CE;
    input [N-1:0] Data_in;
    output reg [N-1:0] count;
    
    always @(posedge reset or posedge clock)
    begin
        if (reset == 1)
            count = 0;
        else if (CE == 0)
            count = count;
        else if (load == 1)
            count = Data_in;
        else
            count = count + 1;
    end
endmodule

