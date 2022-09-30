`include "clock_divider_500.v"

module clock_divider_500_sim;
    parameter       half_period = 1; // every 400000 s sel should be counted once
    parameter       finish_time = 700000;

    reg     clock, reset;
    wire    clock_out;

    clock_divider_500   divider ( reset, clock, clock_out );

    always  # half_period           clock       = ~clock;

    initial
    begin
        # 0     clock = 0; reset = 0;
    end

    always @ ( posedge clock_out )
        $display( "counted! time = %7d", $time );


    initial # finish_time       $finish;
endmodule