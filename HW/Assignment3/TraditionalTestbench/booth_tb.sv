// Traditional Testbench for Booth's Multiplier 

module booth_tb;

localparam x=32, y=32; 
localparam debug = 1;
// Testbench Variables
int multiplicand, multiplier; 

logic [x-1:0] m,r;
logic clk, load, reset; 

longint product; 
logic done; 
bit boot = 1;

//Instantiate DUT 
booth_fsm #(.x(32),.y(32)) DUT ( 
	.m(m),
    .r(r),
    .clk(clk),
	.load(load),
	.reset(reset),
    .product(product),
    .done(done));

// Generate clock/reset 
initial
begin 
	clk = 0;
	forever #5 clk = ~clk;
end

initial
begin
	reset = 1;
	@(posedge clk);
	reset = 0;
end

initial
begin
	wait_for_reset;
	
	apply_test (5,4);
	wait_for_done;
	check_result (5,4,product);

	repeat(100)
	begin
		multiplicand = $random;
		multiplier = $random; 
		apply_test (multiplicand, multiplier);
		wait_for_done; 
		check_result (multiplicand, multiplier, product);
	end
	$stop;
	
end

//Wait for reset 
task wait_for_reset;
	while(reset)
	@(posedge clk);
endtask

// Apply Test Cases 
task apply_test (input int x, input int y);
	m <= x;
	r <= y; 
	load <= '1; 
	@(posedge clk);
	load <= '0;
endtask

// Wait for done
task wait_for_done;

	if(boot)	//Skip first done=1 after reset (first result is zero).
	begin
	while(!done)
	@(posedge clk);
	boot = '0;
	end

	while(done)
	@(posedge clk);
	
	while(!done)
	@(posedge clk);
	
	

endtask

// Check result
task check_result (input int x, input int y, input longint result);
	longint result_golden;
	result_golden = x * y;
	if (result !== result_golden)
	$display("Error: Multiplicand = %0d Multiplier = %0d Expected Product = %0d Obtained Product = %0d",x,y,result_golden, result);
	else if(debug)
	$display("Multiplicand = %0d Multiplier = %0d Expected Product = %0d Obtained Product = %0d",x,y,result_golden, result);
endtask

endmodule 