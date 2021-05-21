`timescale 1ns/100ps
module tff_tb();
    reg rstb=1, WE=0, RE=0;
    wire out;

    tff DUT(WE,RE,rstb,out);

    initial begin
        $dumpfile(`OUTFILE);
        $dumpvars(0);
        // Reset phase
        rstb<=1;
        #1;
        rstb<=0;
        #1;
        rstb<=1;

        // Write phase
        #1;
        WE<=1;
        #2;
        WE<=0;
        #2;
        WE<=1;
        #1;
        WE<=0;
        #2;

        // Read phase
        RE<=1;
        #5;
        rstb<=0;
        #1;
        rstb<=1;

        $finish;
    end
endmodule