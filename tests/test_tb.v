`timescale 1ns/1ns

module test_tb();
    reg testsig = 0;
    initial begin
        $dumpfile(`OUTFILE);
        $dumpvars(1);
        #1 testsig = 1;
        #1 testsig = 0;
        #1 $finish();
    end
endmodule