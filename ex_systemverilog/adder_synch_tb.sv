module adder_synch_tb;

localparam data_width_g = 8 ;
logic rst_n;
logic clk;
logic [data_width_g-1:0] operand_a_in;
logic [data_width_g-1:0] operand_b_in;
logic add_sub;
logic [data_width_g-1:0] result_out;
logic carry_out;

adder_synch #(.data_width_g(data_width_g)) DUT(
	.rst_n(rst_n),
	.clk(clk),
	.operand_a_in(operand_a_in),
	.operand_b_in(operand_b_in),
	.add_sub(add_sub),
	.result_out(result_out),
	.carry_out(carry_out)
);

always #5 clk = ~clk; 

initial begin
    
    clk = 0;
    rst_n = 0;
    operand_a_in = 0;
    operand_b_in = 0;
    add_sub = 0;
	
    
    rst_n = 1;
    #5 rst_n = 0;
    #5 rst_n = 1; 

//Test 1
    operand_a_in = 8'b00000001; //1
    operand_b_in = 8'b00000100; //4
    add_sub = 1; // Add
    #10; // Wait for 10 ns
    $display("Test 1 (Addition): Operand A = %b, Operand B = %b, Result = %b, Carry = %b", operand_a_in, operand_b_in, result_out, carry_out);

//Test 2
    operand_a_in = 8'b00000101; //5
    operand_b_in = 8'b00000011; //3
    add_sub = 0; // sub
    #10; // Wait for 10 ns
    $display("Test 2 (Subtraction): Operand A = %b, Operand B = %b, Result = %b, Carry = %b", operand_a_in, operand_b_in, result_out, carry_out);

//Test 3  
repeat (5) begin
  operand_a_in = $urandom & 8'hFF;  
  operand_b_in = $urandom & 8'hFF;  
  add_sub = $random % 2;  
  #20;  

  $display("Test 3 (Random Inputs): Operand A (Binary) = %b, Operand B (Binary) = %b, Add/Sub = %b, Result = %b, Carry = %b", operand_a_in, operand_b_in, add_sub, result_out, carry_out);
end
     
$finish;

end

endmodule
