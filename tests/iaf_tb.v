`timescale 1ns/100ps
module iaf_tb();
    parameter INPUTS=5;
    parameter THRESH=5;

    reg [INPUTS-1:0] weight_high_bits=0, weight_low_bits=0, signals=0;
    reg RE=0;
    reg trig=0;
    reg rstb=1;
    wire spike=0;

    iaf DUT(weight_low_bits,weight_high_bits,signals,trig,RE,rstb,spike,spike);
    defparam DUT.INPUTS=INPUTS;
    defparam DUT.VT=THRESH;

    task read(input integer n); begin
        RE<=1;
        #(n);
        RE<=0;
        rstb<=0;
        #1;
        rstb<=1;
    end endtask

    initial begin
        $dumpfile(`OUTFILE);
        $dumpvars(3);

        read(THRESH);
        trig<=1;
        #(THRESH);
        trig<=0;
        read(THRESH);
        weight_high_bits<=~0;
        weight_low_bits<=~0;
        signals<=~0;
        trig<=1;
        #(THRESH);
        trig<=0;
        read(THRESH);

        $finish;
    end
endmodule