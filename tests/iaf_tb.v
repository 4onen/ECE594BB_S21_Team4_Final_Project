`timescale 1ns/100ps
module iaf_tb();
    parameter INPUTS=25;
    parameter THRESH=59;
    parameter PERIOD=200;

    reg [INPUTS-1:0] weight_high_bits=0, weight_low_bits=0, signals=0;
    reg RE=0;
    reg clk=0;
    reg rstb=1;
    wire spike;

    iaf DUT(weight_low_bits,weight_high_bits,signals,clk,rstb,RE|spike,spike);
    defparam DUT.INPUTS=INPUTS;
    defparam DUT.VT=THRESH;
    
    initial forever begin
        #(PERIOD/2);
        clk<=0;
        #(PERIOD/2-1);
        rstb<=0;
        #1;
        rstb<=1;
        clk<=1;
    end

    initial begin
        $dumpfile(`OUTFILE);
        $dumpvars(3);

        RE<=1;
        #(PERIOD-1)
        RE<=0;

        weight_high_bits<=25'b11111;
        weight_low_bits<=25'b11111;
        signals<=~0;
        #1;

        #(20*PERIOD);

        $finish;
    end
endmodule