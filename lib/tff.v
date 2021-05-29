`timescale 1ns/100ps
// https://arch.library.northwestern.edu/concern/generic_works/8k71nh39w?locale=en
module tff(WE,RE,rstb,out,carry);
    parameter BITS=2;
    parameter RING_SEGS=2**BITS;

    input WE,RE,rstb;
    output out;
    output reg carry;

    wire EN = WE | RE;
    wire ring_ctrl = rstb & ~RE;
    wire ring_loopback = (ring_ctrl ~& ring[0]);

    reg [RING_SEGS-1:0] ring;
    
    always @(posedge EN) begin
        #0.1
        while(EN & rstb) begin
            ring <= {ring_loopback,ring[RING_SEGS-1:1]};
            #1;
        end
    end

    assign out=~ring[0];

    always @(posedge out) begin
        if(rstb)
            carry<=1'b1;
    end

    always @(negedge rstb) begin
        carry<=1'b0;
    end
endmodule