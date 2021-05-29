`timescale 50ps / 1ps


module TFF(WE, rstb, RE, Q, COUT);
input WE;
input rstb;
input RE;
output reg Q;
output reg COUT;

reg[6:0] count;
reg[6:0] i; 

wire COUTb = ~ COUT;

always @ (WE, rstb, RE) begin
    if (rstb == 0) begin
        Q <= 0;
        count <= 0;
        COUT <= 0;
    end
    else begin
       if (RE == 0) begin
           if(WE == 1) begin
               for(i = 0; i < 59; i = i+1) begin
                   #1 count = count + COUTb;
                   if (count == 59) COUT = 1;
               end
           end
       end
       else if(RE == 1) begin
           for(i = count; i >= 0; i = i-1) begin
               #1 Q = 1;
           end
           Q = 0;
       end 
    end
end

endmodule
