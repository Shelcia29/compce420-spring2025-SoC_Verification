// pass_through.sv
// This is a code example of a simple SystemVerilog testbench design
// The module feeds inputs a and b through to outputs x and y

// NOTE: This example breaks the fundamental design rule: 
// You should always have one module per file!

// The module parameter data_width_g has a default value of 8
// The testbench can override the default value when instantiating the module
module pass_through #(parameter data_width_g = 8)(

// Module inputs
input clk,
input rst_n,
input a_in,
input [data_width_g-1:0] b_in,

// Because the X and Y outputs are set in always blocks and not continuously,
// set the data type to logic
// - The default is usually wire if not specified otherwise
output logic x_out,
output logic [data_width_g-1:0] y_out
);

// Combinational block
always_comb 
    x_out = a_in;

// Synchronous block
always_ff @(posedge clk or negedge rst_n)
    // Clear all output registers on reset
    if (~rst_n) 
        y_out <= 0;
    else // Operation when not in reset
        y_out <= b_in;   
endmodule: pass_through


////////////////////////////////////////////////////////////
// Testbench starts here
////////////////////////////////////////////////////////////

// A testbench module for simulation
// A testbench doesn't have any inputs or outputs, so the port list is empty
module pass_through_tb ();
    
    // The width parameter can be declared as local here
    localparam data_width_g = 16;
    
    // Internal signals that are connected to the DUT
    // Signals are of type logic
    logic clk;
    logic rst_n;
    logic a;
    logic [data_width_g-1:0] b;
    logic x;
    logic [data_width_g-1:0] y;
    
    ////////////////////////////////////////////////////////////
    // Procedures start here
    // - All the procedures (initial, always) run in parallel so 
    //   their order doesn't matter
    ////////////////////////////////////////////////////////////
    // Set clk to 0 in the beginning and toggle it in an always block
    // Cycle = 10ns
    initial clk = 1'b0;
    always #5 clk = ~clk;
    
    // Generate reset and some input in an initial block
    initial begin: initial_procedure // initial_procedure is the LABEL of the BEGIN-END block
                                     // Adding labels make the code more readable, because
                                     // it's easy to see what ends in the END statement
    
        // In the beginning, set reset and input signals to 0
        rst_n = 0;
        a = 1'b0;
        b = 0;
        
        // Wait for 10 ns and then set the reset to 1
        #10 rst_n = 1'b1;
        
        // After setting reset to 1, set some values to a and b
        #10 a = 1'b1;
            b = 16'h21;
            
        // A repeat loop, that randomizes a and increments b 15 times every 10ns
        repeat(15) begin : random_loop
        #10 a = $urandom;
            b = b + 1;
        end : random_loop

        // The sequence is completed, so the initial block is processed
        // wait another 10 ns and then finish the simulation
        #10 $finish;
    end: initial_procedure

    ////////////////////////////////////////////////////////////
    // Instantiate the DUT - in other words connect it to the testbench
    // Also deliver the parameter to the DUT
    ////////////////////////////////////////////////////////////
    pass_through #(.data_width_g(data_width_g)) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .a_in(a),
        .b_in(b),
        .x_out(x),
        .y_out(y)    
    );
        
endmodule: pass_through_tb