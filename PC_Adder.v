module PC_Adder(a,b,c);

    //inputs and outputs
    input [31:0] a,b;
    output [31:0] c;

    //logic
    assign c = a + b;

endmodule