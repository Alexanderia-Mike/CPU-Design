`include "ssd_final.v"

module ssd_final_sim;
    parameter       half_period = 10; // every 10000 cycle, sel would change
    parameter       finish_time = 100000;

    reg             clock_ssd;
    reg     [31:0]  ssd_disp;

    wire    [10:0]  ssd_out_final;

    ssd_final   ssd ( clock_ssd, ssd_disp, ssd_out_final );

    initial
    begin
        # 0     clock_ssd = 1; ssd_disp = 32'h12345678;
    end

    always  # 2000
    begin
        $display( 
            "the ssd output is %b, ssd_disp in ssd_final is %h, ssd_out3 = %b, ssd_out2 = %b, ssd_out1 = %b, ssd_out0 = %b", 
            ssd_out_final, ssd.ssd_disp, ssd.ssd_out3, ssd.ssd_out2, ssd.ssd_out1, ssd.ssd_out0
        );
        $display(
            "the sel is %b",
            ssd.sel
        );
    end

    always  # ( half_period )   clock_ssd = ~clock_ssd;

    initial # finish_time       $finish;
endmodule