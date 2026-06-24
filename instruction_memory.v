module instruction_memory (A,RD,rst);

    //inputs and outputs
    input [31:0] A;
    input rst;

    output [31:0] RD;

    //memory creation
    reg [31:0] Mem [1023:0];

    initial begin
    $readmemh("memfile.dat.txt", Mem);
end

    //logic
    assign RD = (rst == 1'b0) ? 32'h00000000 : Mem[A[31:2]];


endmodule