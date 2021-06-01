`timescale 1ns/1ns

module net();
    parameter INPUTS=25;
    parameter TSTEPS=20;
    parameter HALFPERIOD=100;

    reg [INPUTS-1:0] signals=0;
    reg clk=0;
    reg rstb=0;
    reg RE=0;

    wire spike1,spike2;

    // Weights file order:
    //  neuron 1 lo bits
    //  neuron 1 hi bits
    //  neuron 2 lo bits
    //  neuron 2 hi bits
    reg [INPUTS-1:0] weightfile [0:3];

    wire latinhib_bus = RE|spike1|spike2;
    iaf output_neuron_1(weightfile[0],weightfile[1],signals,clk,rstb,latinhib_bus,spike1);
    defparam output_neuron_1.INPUTS=INPUTS;
    iaf output_neuron_2(weightfile[2],weightfile[3],signals,clk,rstb,latinhib_bus,spike2);
    defparam output_neuron_2.INPUTS=INPUTS;

    reg [INPUTS-1:0] inputfile [0:TSTEPS-1];

    integer tstep;

    initial forever begin
        #(HALFPERIOD);
        clk<=0;
        #(HALFPERIOD-1);
        rstb<=0;
        #1;
        rstb<=1;
        clk<=1;
    end

    initial begin
        $dumpfile(`OUTFILE);
        $dumpvars(0);

        $readmemb(`WEIGHTFILE,weightfile);

        RE<=1;
        #(HALFPERIOD);
        #(HALFPERIOD-1);
        RE<=0;


        $readmemb(`INPUTFILE,inputfile);
        #1
        for(tstep=1;tstep<TSTEPS+1;tstep=tstep+1) begin
            signals<=inputfile[tstep-1];
            #(2*HALFPERIOD);
        end
        signals<=0;
        tstep<=1'bx;

        $finish;
    end
endmodule