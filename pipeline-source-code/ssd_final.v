`include "clock_divider_500.v"
`include "ring_counter_4.v"
`include "ssd.v"

module ssd_final ( clock_ssd, ssd_disp, ssd_out_final );
    input               clock_ssd;
    input       [31:0]  ssd_disp;

    output  reg [10:0]  ssd_out_final;

    wire        [6:0]   ssd_out3, ssd_out2, ssd_out1, ssd_out0; // 6 - 0: g - a
    wire                reset;
    wire        [3:0]   sel, AN; // AN: 3-0, left - right, AN3 - AN1

    initial ssd_out_final = 0;

    assign  reset       =   0;
    assign  AN[3]       =   ~sel[3];
    assign  AN[2]       =   ~sel[2];
    assign  AN[1]       =   ~sel[1];
    assign  AN[0]       =   ~sel[0];
 

    clock_divider_500   divider ( reset, clock_ssd, clock_500   );
    ring_counter_4      ring    ( reset, clock_500, sel         );
    ssd                 ssd3    ( ssd_disp[15:12],  ssd_out3    );
    ssd                 ssd2    ( ssd_disp[11:8],   ssd_out2    );
    ssd                 ssd1    ( ssd_disp[7:4],    ssd_out1    );
    ssd                 ssd0    ( ssd_disp[3:0],    ssd_out0    );

    always @ ( sel, ssd_out0, ssd_out1, ssd_out2, ssd_out3 )
        case ( sel )
            4'b0001:    ssd_out_final = { AN, ssd_out0 }; // the least significant bit
            4'b0010:    ssd_out_final = { AN, ssd_out1 };
            4'b0100:    ssd_out_final = { AN, ssd_out2 };
            // 4'b1000
            default:    ssd_out_final = { AN, ssd_out3 }; // the most significant bit
        endcase
endmodule