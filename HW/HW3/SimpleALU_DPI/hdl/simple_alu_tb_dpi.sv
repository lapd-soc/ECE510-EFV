module simple_alu_tb_dpi;

parameter width = 8;

reg 	clk;
reg 	reset;
bit 	operandA;
bit 	operandB;
bit 	opcode;
bit 	result;
integer	isMoreData;


//clock generator
//tbx clkgen
initial
begin
    clk = 0;
    forever
    begin
        #10 clk = ~clk; 
    end
end


//reset generator
//tbx clkgen
initial
begin
    reset = 1;
    #20 reset = 0;
end



// This is the declaration of an imported task
// whose definition is written at c-side and 
// will be called from HDL.

import "DPI-C" task reset_completed ();
import "DPI-C" task GetDataFromSoftware (output bit [31:0] operandA, output bit [31:0] operandB, output [31:0] opcode, output bit [31:0] isMoreData);
import "DPI-C" task SendDataToSoftware (input bit [31:0] result);
import "DPI-C" task computation_completed ();


initial begin
    @(posedge clk);
    while(reset) @(posedge clk);
    reset_completed;
end



always @(posedge clk)
begin
    if (!reset)
    begin
        
		GetDataFromSoftware(operandA, operandB, opcode, isMoreData); //Get data from software
		
		repeat(2) @(posedge clk);
		
		SendDataToSoftware(product);
		
        if (isMoreData == 0)
        begin
           computation_completed;
           $finish();
        end
    end
end

simple_alu #(.width(width)) DUT
( 	clk,
	reset,
	operandA,
	operandB,
	opcode,
	result
);


endmodule
