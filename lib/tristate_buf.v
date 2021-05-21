`timescale 1ns/1ns
//https://arch.library.northwestern.edu/downloads/2514nk901?locale=en
module tristate_buf(in,EN,out);
    input in;
    input EN;
    output out;

    wire mid;

    assign mid = EN ? in : 1'bz;
    unit_buffer b(mid,out);
endmodule