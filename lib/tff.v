`timescale 1ns/1ns
//https://arch.library.northwestern.edu/downloads/2514nk901?locale=en
module tff(WE,RE,rstb,out,carry);
    parameter BITS=3;
    parameter RING_SEGS=2**BITS;

    input WE,RE,rstb;
    output out;
    output reg carry=0;

    wire EN = WE | RE;
    wire ring_ctrl = rstb & ~RE;
    wire ring_loopback = (~carry & ~(ring_ctrl & out));

    reg [RING_SEGS-1:0] ring;
    
    always @(posedge EN) begin
        while(EN)
            #1 ring <= {ring_loopback,ring[RING_SEGS-1:1]};
    end

    assign out=ring[0];

    always @(posedge ring[0])
        if (~rstb)
            carry<=1;
    always @(negedge rstb) begin
        carry<=0;
        ring<=0;
    end


endmodule