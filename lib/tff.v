`timescale 1ns/100ps
//https://arch.library.northwestern.edu/downloads/2514nk901?locale=en
module tff(WE,RE,rstb,out);
    parameter BITS=2;
    parameter RING_SEGS=2**BITS;

    input WE,RE,rstb;
    output out;

    wire EN = WE | RE;
    wire ring_ctrl = rstb & ~RE;
    wire ring_loopback = (ring_ctrl ~& ring[0]);

    reg [RING_SEGS:0] ring;
    
    always @(posedge EN) begin
        #0.1
        while(EN & rstb) begin
            ring <= {ring_loopback,ring[RING_SEGS:1]};
            #1;
        end
    end

    assign out=~ring[0];

    always @(negedge rstb) begin
        ring <=~0;
    end
endmodule