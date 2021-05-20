`timescale 1ns/1ns

module unit_buffer(in,out);
    input in;
    output reg out;
    always @(in)
        #1 out=in;
endmodule