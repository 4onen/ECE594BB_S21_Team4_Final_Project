`timescale 1ns/1ns

module test_tb();
    reg testsig = 0;
    initial begin
        $dumpfile(`OUTFILE);
        $dumpvars(1);
        #1
        testsig = 1;
        #1
        if(testsig != 1) $error("FAIL: testsig=%b, expected 1",testsig);
        #1
        testsig = 0;
        #1
        if(testsig != 0) $error("FAIL: testsig=%b, expected 1",testsig);
        $finish();
    end
endmodule