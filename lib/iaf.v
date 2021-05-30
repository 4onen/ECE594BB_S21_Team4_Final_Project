`timescale 1ns/1ns
// Integrate-and-fire module
// INPUTS number 2-bit digital weight inputs
module iaf(
    input [INPUTS-1:0] weight_low_bits,
    input [INPUTS-1:0] weight_high_bits,
    input [INPUTS-1:0] signals,
    input clk,
    input rstb,
    input latinhib_bus,
    output reg spike
);

    parameter INPUTS=25;
    parameter VT=59;

    wire [INPUTS-1:0] encoding_steps;
    assign encoding_steps[INPUTS-1] = clk;

    wire carry;

    genvar i;
    generate
        for(i=1;i<INPUTS;i=i+1) begin
            te signalencoder(
                encoding_steps[i],
                {weight_high_bits[i]&signals[i],weight_low_bits[i]&signals[i]},
                encoding_steps[i-1]
            );
            defparam signalencoder.BITS=2;
        end
    endgenerate

    tff accum(.WE((~encoding_steps[0])&clk),.RE(latinhib_bus),.rstb(rstb),.carry(carry));
    defparam accum.RING_SEGS=VT;

    always @(negedge clk)
        spike<=carry;
    
    always @(posedge clk)
        spike<=0;

endmodule