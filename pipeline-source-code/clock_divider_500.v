`include "Counter_N_bit.v"

module clock_divider_500( reset, clock, clock_out );
    input           clock, reset;
    output          clock_out;

    wire    [17:0]  count; 
    wire            load;
    
    assign          load = count[0]&count[1]&count[2]&count[3]&count[4]&count[5]&count[8]&count[10]&count[11]&count[16]&count[17];
    Counter_N_bit #(18)  
                    Counter(1'b1, reset, clock, load, 18'b0, count);
    assign          clock_out = load;
endmodule
