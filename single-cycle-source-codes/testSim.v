module testSim (  );
    parameter   half_period = 500;

    reg     clock;

    // always  @ ( posedge clock )
    //     $display( "aha you are a fool, positive" );
    
    // always  @ ( negedge clock )
    //     $display( "aha, negative" );

    always  @ ( clock )
        $display( "clock changed" );
    
    // initial #0      clock = 0;

    // always  # half_period   clock = ~clock;

    initial #1400   $finish;
endmodule