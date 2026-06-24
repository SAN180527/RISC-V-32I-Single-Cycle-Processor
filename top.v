module Single_Cycle_Top(clk, rst);
    
    // Inputs and outputs
    input clk, rst;

    // Data Wires
    wire [31:0] PC_Top, PC_Next_Top, PCPlus4, PCTarget; // NEW: PC routing wires
    wire [31:0] RD_Instr;
    wire [31:0] RD1_Top, RD2_Top;                       // NEW: Added RD2_Top
    wire [31:0] Imm_Ext_Top;
    wire [31:0] SrcB;                                   // NEW: ALU B-input mux wire
    wire [31:0] ALU_Result_Top;
    wire [31:0] ReadData;                               // NEW: Data Memory output wire
    wire [31:0] Result;                                 // NEW: Final WriteBack mux wire

    // Control Wires (NEW: Declared all the control signals)
    wire reg_write, mem_write, result_src, alu_src, pc_src, zero;
    wire [1:0] imm_src;
    wire [2:0] ALUcontrol_Top;


    // ==========================================
    // MULTIPLEXERS & ADDERS (The "Glue" Logic)
    // ==========================================

    // PC Adder (PC + 4)
    PC_Adder PC_ADD(
        .a(PC_Top),
        .b(32'd4),
        .c(PCPlus4) // FIXED: Outputs to PCPlus4, not directly to PC_Next
    );

    // Branch Target Adder (PC + Immediate)
    assign PCTarget = PC_Top + Imm_Ext_Top;

    // PC Multiplexer (Chooses between PC+4 or Branch Target)
    assign PC_Next_Top = (pc_src) ? PCTarget : PCPlus4;

    // ALU Source Multiplexer (Chooses between Register 2 or Immediate)
    assign SrcB = (alu_src) ? Imm_Ext_Top : RD2_Top;

    // WriteBack Multiplexer (Chooses between ALU Result or Memory Data)
    assign Result = (result_src) ? ReadData : ALU_Result_Top;


    // ==========================================
    // MODULE INSTANTIATIONS
    // ==========================================

    P_C PC( 
        .clk(clk),
        .rst(rst),
        .PC(PC_Top),
        .PC_NEXT(PC_Next_Top)
    );

    instruction_memory IM( 
        .A(PC_Top),
        .rst(rst),
        .RD(RD_Instr)
    );

    Reg_file RF ( 
        .clk(clk),
        .rst(rst),
        .A1(RD_Instr[19:15]),
        .A2(RD_Instr[24:20]),     // FIXED: Wired to rs2 in the instruction
        .A3(RD_Instr[11:7]),
        .RD1(RD1_Top),
        .RD2(RD2_Top),            // FIXED: Wired to RD2_Top
        .WD3(Result),             // FIXED: Wired to the WriteBack Mux
        .WE3(reg_write)
    );

    sign_extend SE(
        .In(RD_Instr),
        .ImmSrc(imm_src),         // FIXED: Added the ImmSrc control signal we updated earlier!
        .Imm_Ext(Imm_Ext_Top)
    );

    alu ALU(
        .A(RD1_Top),
        .B(SrcB),                 // FIXED: Wired to the ALU Source Mux
        .Result(ALU_Result_Top),
        .Zero(zero),              // FIXED: Wired to the zero flag
        .Negative(),              // (Unused in base design, left disconnected)
        .Overflow(),              // (Unused in base design, left disconnected)
        .Carry(),                 // (Unused in base design, left disconnected)
        .ALUcontrol(ALUcontrol_Top)
    );

    control_unit controller (
        .op(RD_Instr[6:0]),
        .funct3(RD_Instr[14:12]),
        .funct7b5(RD_Instr[30]),
        .op5(RD_Instr[5]),
        .zero(zero),
        .RegWrite(reg_write),
        .MemWrite(mem_write),
        .ResultSrc(result_src),
        .ALUSrc(alu_src),
        .PCSrc(pc_src),
        .ImmSrc(imm_src),
        .ALUcontrol(ALUcontrol_Top)
    );

    Data_Memory DM(
        .A(ALU_Result_Top),
        .WD(RD2_Top),             // FIXED: Store instructions write the value from rs2
        .WE(mem_write),           // FIXED: Wired to MemWrite control signal
        .clk(clk),
        .rst(rst),
        .RD(ReadData)             // FIXED: Wired to ReadData
    );

endmodule