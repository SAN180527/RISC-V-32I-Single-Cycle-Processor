module P_C (PC_NEXT, PC, rst, clk);

    //inputs and outputs
    input [31:0] PC_NEXT;
    input rst;
    input clk;

    output reg [31:0] PC;

    //logic
    always @(posedge clk)
        begin 
            if (rst == 1'b0)
            begin
                PC <= 32'h00000000;
            end

            else
            begin
                PC <= PC_NEXT;
            end
        end   

endmodule