// Simple ALU Module
// Supports Add, Subtract, AND, OR Operations

module simple_alu #(parameter width = 8) (
    input 		    clk,
    input 		    reset,
    input [width-1:0] 	    operandA, operandB,
    input [1:0] 	    opcode,
    output logic[width-1:0] result
);


    always_ff @(posedge clk)
    begin 
    	if(reset)
	    result <= '0;
	else
	begin
	    case(opcode)
	        0: result <= operandA + operandB; 
		1: result <= operandA - operandB;
		2: result <= operandA & operandB;	
		3: result <= operandA | operandB;
	    endcase
	end
    end
endmodule 
