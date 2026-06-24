module Reg_file(clk, rst, A1, A2, A3, RD1, RD2, WD3, WE3);

    //inputs and outputs
    input clk, rst;
    input [4:0] A1, A2, A3;
    input [31:0] WD3;
    input WE3;
    output [31:0] RD1, RD2;

    //Memory creation
    reg [31:0] Registers [31:0];

    //Read functionality 
    assign RD1 = (rst == 1'b0) ? 32'h00000000 : ((A1 == 5'b0) ? 32'h00000000 : Registers[A1]);
    assign RD2 = (rst == 1'b0) ? 32'h00000000 : ((A2 == 5'b0) ? 32'h00000000 : Registers[A2]);

    //Write functionality 
    always @(posedge clk) 
    begin
        if (WE3 && (A3 != 5'b0)) 
        begin
            Registers[A3] <= WD3;
        end
    end

endmodule