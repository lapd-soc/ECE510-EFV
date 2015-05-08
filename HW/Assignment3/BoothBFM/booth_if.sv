// Sameer Ghewari, Portland State University, Feb 2015 

// TBX BFM Example - Simple ALU 
//Interface for ALU
// The interface specifies all external pins of the ALU module 

//Import alu_pkg definitions for struct data type and parameters
import booth_pkg::*;

interface booth_if(input bit clk, reset);
// pragma attribute booth_if partition_interface_xif

//Inputs
logic [x-1:0] m;
logic [y-1:0] r;		// Two 32 it signed operands
logic load;	// Start signal for control 

//Outputs 
logic[x+y-1:0]product;			// 32 bit signed output 
logic done; 	// Done control signal 


// Booth Interface Tasks - Bus Functional Model (BFM)

initial
begin
	load <= '0;
end
// Wait for reset task. This task makes sure that your testbench does not start provide testcases
// until reset is over.
// The pragma specified next to the task specifies that this task is made external for access in the HVL.
task wait_for_reset(); // pragma tbx xtf
  @(negedge reset);
endtask

//do_item task applies inputs, drives control signals, waits for output and sends output back 
task do_item (input mult_data req, output mult_data rsp); // pragma tbx xtf
    @(posedge clk); 	// For a task to be synthesizable for veloce, it must be a clocked task 
    
	while(!done)		//Wait for done. If the multiplier is busy from previous operation, wait.
	begin
		@(posedge clk);
	end
	
   m <= req.multiplicand;		//Issue operand a from the req.a field to the alu_port.a port 
   r <= req.multiplier; 	//Issue operand b from the req.b field to the alu_port.b port 
   
   load <= '1;	//Make control signal start = 1 to begin the operation of the ALU 
   @(posedge clk);
   load <= '0;
   
  while(done) 
  @(posedge clk); 

   while(!done) begin	//Wait until the done signal becomes 1, indicating ALU is ready with the result
     @(posedge clk);
   end
   
   // At end of the pin level bus transaction
   // Copy response data into the rsp fields:
   rsp = req; // Clone the req (note req doesn't have result)
   
   rsp.product = product; //Populate result y in response by copying it from the alu_port.y port
 endtask
endinterface: booth_if