module Data_Memory (A, WD, WE,clk,rst,RD);

    //inputs and outputs
    input [31:0] A, WD;
    input WE, clk,rst;

    output [31:0] RD;

    //memory creation
    reg [31:0] Data_Mem [1023:0];

    //read functionality
    assign RD = (WE) ? 32'h00000000 : Data_Mem[A[31:2]];

    //write functionality
    always @(posedge clk)
    begin
        if (WE)
        begin
            Data_Mem[A[31:2]] <= WD;
        end
    end   


endmodule