module ssd ( c, SSD_out );
    input   [3:0]   c;
    output  [6:0]  SSD_out;

    assign SSD_out[0] = (~c[3])&(~c[2])&(~c[1])&c[0] | (~c[3])&(c[2])&(~c[1])&(~c[0]) | (c[3])&(c[2])&(~c[1])&(c[0]) | (c[3])&(~c[2])&(c[1])&(c[0]);
    assign SSD_out[1] = (c[2])&(c[1])&(~c[0]) | (c[3])&(c[2])&(c[1]) | (c[3])&(c[1])&(c[0]) | (c[3])&(c[2])&(~c[0]) | (~c[3])&(c[2])&(~c[1])&(c[0]);
    assign SSD_out[2] = (c[3])&(c[2])&(c[1]) | (c[3])&(c[2])&(~c[0]) | (~c[3])&(~c[2])&(c[1])&(~c[0]);
    assign SSD_out[3] = (c[2])&(c[1])&(c[0]) | (~c[3])&(~c[2])&(~c[1])&(c[0]) | (~c[3])&(c[2])&(~c[1])&(~c[0]) | (c[3])&(~c[2])&(c[1])&(~c[0]);
    assign SSD_out[4] = (~c[3])&(c[0]) | (~c[3])&(c[2])&(~c[1]) | (~c[2])&(~c[1])&(c[0]);
    assign SSD_out[5] = (~c[3])&(c[1])&(c[0]) | (~c[3])&(~c[2])&(c[1]) | (~c[3])&(~c[2])&(c[0]) | (c[3])&(c[2])&(~c[1])&(c[0]);
    assign SSD_out[6] = (~c[3])&(~c[2])&(~c[1]) | (~c[3])&(c[2])&(c[1])&(c[0]) | (c[3])&(c[2])&(~c[1])&(~c[0]);
endmodule