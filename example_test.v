

`timescale 1ns / 1ps

module example_tb;

    // Inputs
    reg inA;
    reg clk;

    // Outputs
    wire out1;
    wire out2;

    // Instantiate the Unit Under Test (UUT)
    example uut (
        .inA(inA),
        .clk(clk),
        .out1(out1),
        .out2(out2)
    );

    initial begin
    $dumpfile("example_tb.vcd");
    $dumpvars(0, example_tb);
        // Initialize Inputs
        inA = 0;
        clk = 0;
        

        // Wait for 100ns for global reset to finish
        #100;

        #3 inA=1;
        #5 inA=0;
        #9 inA=1;
        #2 inA=0;
        #6 inA=1;
        #7 inA=0;
        #1 inA=1;
        #3 inA=0;
        #6 inA=1;
    
        end
        $finish;


    always @ (posedge clk) begin
        // Toggle clock every 20ns
        if ($time % 20 == 0) begin
            clk <= ~clk;
        end
    end
always	#10	clk = ~clk;
endmodule
