`timescale 1ns/1ns
// Integrate-and-fire module
// INPUTS number 2-bit digital weight inputs
module iaf(
    input [INPUTS-1:0] weight_low_bits,
    input [INPUTS-1:0] weight_high_bits,
    input [INPUTS-1:0] signals,
    input trig,
    input RE,
    input rstb,
    input latinhib_bus,
    output spike
);

    parameter INPUTS=25;
    parameter VT=59;

    wire [INPUTS-1:0] encoding_steps;
    assign encoding_steps[INPUTS-1] = trig;

    genvar i;
    generate
        for(i=1;i<INPUTS;i=i+1) begin
            te signalencoder(encoding_steps[i],{weight_high_bits[i],weight_low_bits[i]},encoding_steps[i-1]);
            defparam signalencoder.BITS=2;
        end
    endgenerate

    tff accum(.WE(encoding_steps[0]),.RE(RE),.rstb(rstb),.carry(spike));
    defparam accum.RING_SEGS=VT;



endmodule