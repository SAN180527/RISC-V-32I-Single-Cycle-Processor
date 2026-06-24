module control_unit(
    input        zero,
    input  [6:0] op,
    input  [2:0] funct3,
    input        funct7b5, // Bit 30 of the instruction
    input        op5,      // Bit 5 of the opcode
    output       RegWrite,
    output       MemWrite,
    output       ResultSrc,
    output       ALUSrc,
    output       PCSrc,
    output [1:0] ImmSrc,
    output [2:0] ALUcontrol
);

    // Internal wire connecting Main Decoder to ALU Decoder
    wire [1:0] ALUOp;

    // Instantiate the Main Decoder
    main_decoder md (
        .op(op),
        .zero(zero),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp),
        .PCSrc(PCSrc)
    );

    // Instantiate the ALU Decoder
    alu_decoder ad (
        .ALUop(ALUOp),
        .op5(op5),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .ALUcontrol(ALUcontrol)
    );

endmodule