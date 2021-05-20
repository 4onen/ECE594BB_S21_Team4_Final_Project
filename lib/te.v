`timescale 1ns/1ns
// doi:10.1109/JSSC.2018.2883394
module te(tin,din,tout);

    parameter BITS=3;

    input tin;
    input [BITS-1:0] din;
    output tout;

    wire [(2**BITS)-1:0] internal_times;

    assign internal_times[0] = tin;

    genvar i;
    generate
        for (i=1;i<2**BITS;i=i+1) begin
            unit_buffer b(internal_times[i-1],internal_times[i]);
        end
    endgenerate

    assign tout = internal_times[din];
endmodule