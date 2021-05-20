`timescale 1ns/100ps

module unit_buffer_tb();
    reg testclk = 0;
    wire out;
    unit_buffer b(testclk,out);

    initial forever #4 testclk=~testclk;

    initial begin
        $dumpfile(`OUTFILE);
        $dumpvars(1);

        #2
        if(out != testclk) $error("FAIL: testclk=%b, out=%b, buffer did not respond in 2 ticks.",testclk,out);

        #2.5
        if(out == testclk) $error("FAIL: testclk=%b, out=%b, buffer responded in less than 1 tick.",testclk,out);

        #0.6
        if(out != testclk) $error("FAIL: testclk=%b, out=%b, buffer did not respond in 1.1 ticks.",testclk,out);

        #0.9

        $finish;
    end

endmodule