module tb_Single_Cycle_Top();

    // 1. Declare testbench signals
    reg clk;
    reg rst;

    // 2. Instantiate your complete CPU (Device Under Test)
    Single_Cycle_Top dut (
        .clk(clk),
        .rst(rst)
    );

    // 3. Generate the Clock Signal
    // This flips the clock from 0 to 1 every 5 time steps (10 time step period)
    always #5 clk = ~clk;

    // 4. Test Sequence
    initial begin
        // Start with the clock at 0 and the reset button PRESSED (active low)
        clk = 0;
        rst = 0; 
        
        // Wait for 10 time steps so the PC settles at 0x00000000
        #10;
        
        // RELEASE the reset button! The CPU is now live.
        rst = 1;
        
        // Let the processor run for 200 time steps, then stop the simulation
        #200;
        $finish;
    end
    
    // 5. Generate Waveform Output
    // This creates the file you can view in EDA Playground or GTKWave
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_Single_Cycle_Top);
    end

endmodule