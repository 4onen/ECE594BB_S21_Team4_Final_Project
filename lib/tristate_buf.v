`timescale 1ns/1ns
//https://arch.library.northwestern.edu/downloads/2514nk901?locale=en
module tristate_buf(in,EN,out);
    input in;
    input EN;
    output reg out;

    always @(in or EN) begin
        if(EN)
            #1 if(EN) out=in;
    end
endmodule