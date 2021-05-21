`timescale 1ns/1ns
//https://arch.library.northwestern.edu/downloads/2514nk901?locale=en
module cmp(sign,a,b);
    input a;
    input b;
    output sign;

    reg nora_out = 0;
    wire norb_out = ~(b | nora_out);

    assign sign = a | norb_out;

    always @(a,b) begin
        nora_out <= ~sign;
    end
endmodule