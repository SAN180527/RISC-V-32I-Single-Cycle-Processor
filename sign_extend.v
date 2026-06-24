module sign_extend (
    input [31:0] In,
    input [1:0] ImmSrc,
    output [31:0] Imm_Ext
);

    //Logic: Use ImmSrc to multiplex between the different instruction formats
    assign Imm_Ext = 
        //I-Type: Immediate is bits [31:20]
        (ImmSrc == 2'b00) ? {{20{In[31]}}, In[31:20]} :
        
        // S-Type (SW): Immediate is split into [31:25] and [11:7]
        (ImmSrc == 2'b01) ? {{20{In[31]}}, In[31:25], In[11:7]} :
        
        // B-Type (BEQ): Immediate is scrambled, and multiplied by 2
        (ImmSrc == 2'b10) ? {{20{In[31]}}, In[7], In[30:25], In[11:8], 1'b0} :
        
        // Default case
        32'h00000000;

endmodule