`timescale 1ns/100ps
module tff_tb();
    reg rstb=1, WE=0, RE=0;
    wire out, carry;

    tff DUT(WE,RE,rstb,out,carry);

    initial begin
        $dumpfile(`OUTFILE);
        $dumpvars(0);
        #1
        rstb<=0;
        RE<=1;
        #8;
        RE<=0;
        // Reset phase
        rstb<=0;
        #20;
        rstb<=1;
        #1;
        rstb<=0;

        // Write phase
        #1;
        WE<=1;
        #2;
        WE<=0;
        #2;
        WE<=1;
        #1;
        WE<=0;
        #3;

        // Read phase
        RE<=1;
        #100;

        $finish;
    end
endmodule