module adder_synch #(parameter data_width_g = 8) (
    input [data_width_g-1:0] operand_a_in,
    input [data_width_g-1:0] operand_b_in,
    input clk,
    input rst_n,
    input add_sub,
    output logic [data_width_g-1:0] result_out,
    output logic carry_out
    );

always_ff @(posedge clk or negedge rst_n) begin 

if (~rst_n) begin
       result_out <= 0;    
end

else begin
	if (add_sub ==1) begin
        result_out = operand_a_in + operand_b_in;
	end

	else if (add_sub ==0) begin
	result_out = operand_a_in - operand_b_in;
	end
  
end	


end

endmodule : adder_synch




