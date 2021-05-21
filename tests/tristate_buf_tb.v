`timescale 1ns/100ps
module tristate_buf_tb();
    reg in,EN;
    wire out;

    tristate_buf b(in,EN,out);

    initial begin
        $dumpfile(`OUTFILE);
        $dumpvars(1);

        in<=1'b1;
        EN<=1'b0;
        #1.1
        if(out != 1'bz)
            $error("FAIL: EN=0 caused in=out=1.");

        EN<=1'b1; // Clear contents
        #1.1
        EN<=1'b0;
        
        in<=1'b0;
        EN<=1'b1;
        #0.9
        if(out == 1'b0)
            $error("FAIL: EN=1 caused in=out=0 too quickly.");
        #0.2
        if(out != 1'b0)
            $error("FAIL: EN=1 did not pass in=0 to out");
        
        in<=1'b1;
        #0.9
        if(out == 1'b1)
            $error("FAIL: EN=0 caused in=out=1 too quickly.");
        #0.2
        if(out != 1'b1)
            $error("FAIL: EN=1 did not pass in=1 to out");
        
        #1
        $finish;
    end
endmodule