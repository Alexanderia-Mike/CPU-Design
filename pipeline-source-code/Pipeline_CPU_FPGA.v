`include "Pipeline_CPU.v"
`include "ssd_final.v"

module Pipeline_CPU_FPGA ( clock_ssd, clock, RegFile_Address, PC_look_up, ssd_out_final );
    input           clock, clock_ssd;
    input   [4:0]   RegFile_Address;
    input           PC_look_up;

    output  [10:0]  ssd_out_final;

    wire    [31:0]  ssd_disp, RegOut;
    wire    [31:0]  PCOut;
    wire            reset;

    assign  ssd_disp    =   PC_look_up == 1 ? PCOut : RegOut;
    assign  reset       =   0;

    Pipeline_CPU        cpu     ( clock, RegFile_Address, RegOut, PCOut );
    clock_divider_500   divider ( reset, clock_ssd, clock_500 );
    ssd_final           ssd     ( clock_500, ssd_disp, ssd_out_final );
endmodule