`include "Pipeline_CPU_FPGA.v"

module Pipeline_FPGA_Sim;
    parameter       half_period_ssd = 0.00001; // every 4 s sel should change
    parameter       half_period_normal = 10;   // clock for pipeline cpu
    parameter       finish_time = 700;

    reg             clock, clock_ssd;
    reg     [4:0]   RegFile_Address;
    reg             PC_look_up;

    wire    [10:0]  ssd_out_final;

    Pipeline_CPU_FPGA   cpu ( clock_ssd, clock, RegFile_Address, PC_look_up, ssd_out_final );

    always  # half_period_ssd       clock_ssd   = ~clock_ssd;
    always  # half_period_normal    clock       = ~clock;

    initial
    begin
        # 0     clock = 0; clock_ssd = 0; RegFile_Address = 5'b01001; PC_look_up = 1;
        # 50    PC_look_up = 0;
    end

    always
    #10
        $display( 
            "ssd = %b, ssdout0 in cpu = %b, sel in cpu = %b, ssd in cpu = %b", 
            ssd_out_final, cpu.ssd.ssd_out0, cpu.ssd.sel, cpu.ssd_out_final
        );


    initial # finish_time       $finish;
endmodule