`timescale 1ns/100ps
module tff_tb();
    reg rstb=1, WE=0, RE=0;
    wire out;
    wire carry;

    tff DUT(WE,RE,rstb,out,carry);
    defparam DUT.RING_SEGS=59;

    task write(input integer n); begin
        WE<=1;
        #(n);
        WE<=0;
        #1;
    end endtask

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
        $dumpvars(0);
        // Read phase
        read(60);
        #1;

        // Write phase
        write(5);
        write(7);
        write(3);
        write(0);
        write(44);

        // Read phase
        read(60);
        #0;
        rstb<=0;
        #1;
        rstb<=1;

        $finish;
    end
endmodule