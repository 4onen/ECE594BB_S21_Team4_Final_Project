`timescale 1ns/1ns
//https://arch.library.northwestern.edu/downloads/2514nk901?locale=en
module tff(WE,RE,rstb,out,carry);
    parameter BITS=3;

    input WE,RE,rstb;
    output out;
    output reg carry;

    wire EN = WE | RE;
    wire ring_ctrl = rstb & ~RE;

    wire [(2**(BITS-1)):0] ring_vals;
    genvar i;
    generate
        for (i=1;i<2**(BITS-1)+1;i=i+1)
            tristate_buf b(ring_vals[i-1],EN,ring_vals[i]);
    endgenerate

    assign ring_vals[0] = (~carry & ~(ring_ctrl & out));
    assign out = ring_vals[(2**(BITS-1))];

    always @(posedge out)
        if(~rstb)
            carry<=1;
    always @(negedge rstb)
        carry<=0;

endmodule