// Sameer Ghewari, Portland State University, Feb 2015 

// TBX BFM Example - Simple ALU 
// This is the HVL testbench. Runs on the workstation. This is a very straightforward directed
// testbench and does not include better way of test case generation. You could use SV classes
// and constrained random test case generation to develop test cases 

//Import alu_pkg definitions for struct data type and parameters
import booth_pkg::*;


module top_tb;

//Create temporary variables to generate test cases and record responses 
mult_data req, resp;

initial
  begin	
	//Wait for reset
	top_hdl.booth_port.wait_for_reset();
	// Note the hirearchical call to the exported task inside BFM. 
	// HDL Top -> BFM/IF -> Task 
	
	//generate a test case 
	req = {5,7,0};
	//Invoke bus transaction 
    top_hdl.booth_port.do_item(req,resp);
	//Display result	
	$display("%p",resp);
	
	$stop;
  end

endmodule: top_tb
