`timescale 1ns/100ps
module cmp_tb();
    localparam BITS=2;
    localparam PERIOD=(2**BITS)+1;

    reg tin=0;
    reg [BITS-1:0] a=~0;
    reg [BITS-1:0] b=~0;
    wire ta, tb, tout_F, tout_R;

    te enc_a(tin,a,ta);
    defparam enc_a.BITS=BITS;
    te enc_b(tin,b,tb);
    defparam enc_b.BITS=BITS;
    cmp DUT_F(tout_F,ta,tb);
    cmp DUT_R(tout_R,~ta,~tb);

    // wire tout = tin ? tout_R : tout_F;
    
    reg [BITS:0] counter = 0;
 
    initial forever begin
        repeat (PERIOD)
            #1 counter <= counter + 1;
        tin <= ~tin;
        counter <= 0;
    end

    initial begin
        $dumpfile(`OUTFILE);
        $dumpvars(1);

        #(PERIOD-0.5);
        repeat(2**BITS) begin
            b <= b + 1;
            repeat(2**BITS) begin
                a <= a + 1;
                #PERIOD;
                if(a<b && (tin ? tout_R : tout_F))
                    $error("FAIL: a=%d<b=%d but tout=1 at t=%d",a,b,counter);
                if(a>b && ~(tin ? tout_R : tout_F))
                    $error("FAIL: a=%d>b=%d but tout=0 at t=%d",a,b,counter);
            end
        end

        $finish;
    end
endmodule