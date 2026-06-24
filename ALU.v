module alu(A,B,ALUcontrol,Result,Zero,Negative,Overflow,Carry);
//inputs
input [31:0] A,B;
input [2:0] ALUcontrol;
output [31:0] Result;
output Zero,Negative,Overflow,Carry;


//wires
wire [31:0] a_and_b;
wire [31:0] a_or_b;
wire [31:0] not_b;

wire carry_out;
wire [31:0] slt;
wire [31:0] mux1;

wire [31:0] sum;

wire [31:0] mux2;

//logic

//and logic
assign a_and_b= A & B;

//or logic
assign a_or_b= A | B;

assign not_b= ~B;

//mux design
assign mux1 = ALUcontrol[0] ? not_b : B ;

//add or sub
assign {carry_out, sum} = A + mux1 + ALUcontrol[0];

//zero extension for slt
assign slt = {31'b0, sum[31]};


//4x1 mux design
assign mux2 = (ALUcontrol[2:0] == 3'b000) ? sum :
         (ALUcontrol[2:0] == 3'b001)? sum :
         (ALUcontrol[2:0] == 3'b010) ? a_and_b : 
         (ALUcontrol[2:0] == 3'b011) ? a_or_b :
         (ALUcontrol[2:0] == 3'b101) ? slt : 32'h00000000;
          
assign Result = mux2;

//flags
assign Zero = &(~Result); //zero flag
assign Negative = Result[31]; //negative flag
assign Overflow = (~ALUcontrol[1]) & (A[31] ^ sum[31]) & (~((A[31] ^ B[31] ^ ALUcontrol[0]))); //overflow flag
assign Carry = carry_out & (~ALUcontrol[1]); //carry flag




endmodule