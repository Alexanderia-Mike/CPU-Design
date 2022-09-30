`include "ring_counter_4.v"

module ring_counter_sim;
    parameter       half_period = 50; 
    parameter       finish_time = 1000;
    
    reg             reset, clock;
    wire    [3:0]   out;

    ring_counter_4  ring ( reset, clock, out );

    initial
    begin
        # 0     clock = 1; reset = 0;
    end

    always  # 20
    begin
        $display( 
            "out = %b",
            out
        );
    end

    always  # ( half_period )   clock = ~clock;

    initial # finish_time       $finish;
endmodule