module main_decoder(op, zero, ResultSrc, ALUSrc, MemWrite, RegWrite, ImmSrc, ALUOp, PCSrc);

    input        zero;
    input  [6:0] op;
    output       ALUSrc, MemWrite, RegWrite, PCSrc, ResultSrc;
    output [1:0] ImmSrc, ALUOp;

    wire branch;

    // R-type, lw, I-type ALU all write to rd
    assign RegWrite  = (op == 7'b0110011)   // R-type
                    || (op == 7'b0000011)   // lw
                    || (op == 7'b0010011);  // I-type ALU 

    assign MemWrite  = (op == 7'b0100011);  // sw 

    assign ResultSrc = (op == 7'b0000011);  // lw 

    // lw, sw, I-type ALU all use immediate as ALU B-input
    assign ALUSrc    = (op == 7'b0000011)   // lw
                    || (op == 7'b0100011)   // sw
                    || (op == 7'b0010011);  // I-type ALU

    assign branch    = (op == 7'b1100011);  // beq

    assign ImmSrc    = (op == 7'b0100011) ? 2'b01 :  // sw
                       (op == 7'b1100011) ? 2'b10 :  // beq
                                            2'b00;   // lw, I-type, R-type 

    // R-type and I-type ALU both need ALUOp=10 
    assign ALUOp     = (op == 7'b0110011)   ? 2'b10 :  // R-type
                       (op == 7'b0010011)   ? 2'b10 :  //I-type ALU
                       (op == 7'b1100011)   ? 2'b01 :  // beq
                                              2'b00;   // lw, sw

    assign PCSrc     = branch & zero;

endmodule