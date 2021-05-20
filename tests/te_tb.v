`timescale 1ns/100ps
module te_tb();
    localparam BITS = 4;

    reg tin = 0;
    reg [BITS-1:0] din = ~0;
    wire tout;

    reg [BITS:0] counter = 0;

    te DUT(tin,din,tout);
    defparam DUT.BITS = BITS;

    initial forever #(2**BITS+1) tin=~tin;

    initial forever #1 counter = counter + 1;

    initial begin
        $dumpfile(`OUTFILE);
        $dumpvars(1);

        #(2**BITS+0.5) // Prime TE with zero input
        repeat (2**BITS) begin
            counter = ~0;
            din = din + 1;
            repeat (2**BITS) begin
                #1;
                if(counter < din && tin==tout)
                    $error("FAIL: din=%b,t=%d TE transitioned too fast.",din,counter);
                else if(counter >= din && tin!=tout)
                    $error("FAIL: din=%b,t=%d TE transitioned too slowly.",din,counter);
            end
            #1;
        end

        $finish;
    end


endmodule