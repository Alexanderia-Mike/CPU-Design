module ring_counter_4( reset, clock, out );
    input               reset, clock;
    output  reg [3:0]   out;

    initial out = 4'b0001;
    
    always @(posedge clock or posedge reset)
    begin
        if (reset == 1)
            out = 1;
        else
            out = {out[0], out[3:1]};
    end
endmodule