module alu_decoder (ALUop, op5,funct3, funct7b5,ALUcontrol);

    //inputs and outputs
    input [1:0] ALUop;
    input op5;
    input [2:0] funct3;
    input funct7b5;
    output [2:0] ALUcontrol;

    //wire
    wire [1:0] concatenation = {op5,funct7b5};

    //logic
    assign ALUcontrol = (ALUop == 2'b00) ? 3'b000 :
                        (ALUop == 2'b01) ? 3'b001 :
                        ((ALUop == 2'b10) && (funct3 == 3'b010)) ? 3'b101:
                        ((ALUop == 2'b10) && (funct3 == 3'b110)) ? 3'b011:
                        ((ALUop == 2'b10) && (funct3 == 3'b111)) ? 3'b010:
                        ((ALUop == 2'b10) && (funct3 == 3'b000) && (concatenation == 2'b11)) ? 3'b001 :
                        ((ALUop == 2'b10) && (funct3 == 3'b000) && (concatenation != 2'b11) ) ? 3'b000 : 3'b000;



endmodule