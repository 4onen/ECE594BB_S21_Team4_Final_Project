`timescale 50ps / 1ps

module TimeEncoder(start, din, tout);

input start;
input[1:0] din;
output reg tout;

initial begin
    tout = 0;
end
always @ (posedge start) begin
    if (din == 0) begin
        tout = 0;
    end
    else if(din == 1) begin
        tout = 1; #1
        tout = 0;
    end
    else if(din == 2) begin
        tout = 1; #2
        tout = 0;
    end
    else if(din == 3) begin
        tout = 1; #3
        tout = 0;
    end
end


endmodule
