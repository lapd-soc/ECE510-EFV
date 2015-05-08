// This is HVL for Booth's Multiplier verification environment that runs on the Workstation
// Sameer Ghewari, Portland State University, Winter 2014

import xtlm_pkg::*; // For trans-language TLM channels.
`include "config.v"
//File Handlers
int product_file;
int multiplicand_file;
int multiplier_file;

//SystemVerilog Queue to store test cases that were sent
//These are popped and given to the golden model once a result is obtained from the emulator 
logic [(data_width*2)-1:0] sent_queue [$];

//Since DUT outputs a result of "zero" during reset, it is ignored by startup variable
logic startup = 0;

//When debug is 1, results are printed on terminal
parameter debug=1;

//When file is 1, multiplicand, multiplier and results are written to text files
parameter file = 1;

int error_count;

//Scoreboard class
//This class monitors the output pipe. It creates a new object for outputpipe 
// A task runs contineously monitoring the output pipe 
	class scoreboard;
		int m,r;
		longint result; 
		
		xtlm_fifo #(bit[(data_width*2)-1:0]) monitorChannel;
		function new ();
		begin
			monitorChannel = new ("top.outputpipe");
			
			if(file) begin
			product_file=$fopen("product.txt","w");
			$fwrite(product_file,"Product\n");
			end
			
		end
		endfunction

		task run();
			while (1)
			begin
				longint product;
				monitorChannel.get(product);	//Note- this task is blocking. Waits here until result is available 
			    
				if(startup)
				begin 
					{m,r}=sent_queue.pop_front;	//Pop the test case 
					result = m*r; 				//Perform multiplication, used as model
					if(product !== result)		//If obtained and expected products don't match, its an error
					begin
					$display("Error: multiplicand=%d multiplier=%d expected product=%d obtained product =%d",m,r,result,product);
					error_count++;
					end

					if(file)	//Write to file if file I/O is enabled 
					$fwrite(product_file,"%0d\n",product);
				
					if(debug)	//Display in debug 
					$display("Multiplicand=%d Multiplier=%d Expected product=%d Obtained product =%d",m,r,result,product);
				end
				
				if(!startup)	//The first result sent is zero (in reset). Its ignored 
				startup = 1;
			end	
		endtask
    
	endclass

	

//Stimulus (test) generation class 
//This generates testecases with SV inline randomization 
//To avoid recompilation of the code, user input is taken during vsim command
//invoke. This user input is RUNS and SIGNS. Runs tells how many test cases
//to be generated and Signs tells the sign of the multiplicand and multiplier. 

	class stimulus_gen ;

		xtlm_fifo #(bit[(data_width*2)-1:0]) driverChannel;
		int m,r;
		
    
		function new();			//Constructor 
			begin
				driverChannel = new ("top.inputpipe");		
							
				if(file) begin 
				multiplicand_file=$fopen("multiplicand.txt","w");
				multiplier_file=$fopen("multiplier.txt","w");
				$fwrite(multiplicand_file,"Multiplicand\n");
				$fwrite(multiplier_file,"Multiplier\n");
				end
				
			end
		endfunction

		task run;
		  input [31:0]runs;
		  input [15:0]signs;
		  
		repeat(runs)				
			begin			
				
				case(signs)
				       "++": 
							begin
								if(randomize(m) with {m>0;m<((2**31)-1);});
								//if(debug) $display("m=%d",m);
								if(randomize(r) with { r>0;r<((2**31)-1);});
								//if(debug) $display("r=%d",r);
							end
						
						"--":
							begin
								if(randomize(m) with {m<0;m>(-(2**31));});
								//if(debug) $display("m=%d",m);
								if(randomize(r) with {r<0;r>(-(2**31));});
							end
      
						"+-":
							begin
								if(randomize(m) with { m>0;m<((2**31)-1);});
								//if(debug) $display("m=%d",m);
								if(randomize(r) with { r<0;r>((-2**31));});
								//if(debug) $display("m=%d",m);         
							end 
							
						"-+":
							begin
								if(randomize(m) with {m<0;m>(-(2**31));});
								//if(debug) $display("m=%d",m);
								if(randomize(r) with {r>0;r<((2**31)-1);});
								//if(debug) $display("m=%d",m);       
							end
      
					default:
							begin
								if(randomize(m) with { m>0;m<50;});
								//if(debug) $display("m=%d",m);
								if(randomize(r) with { r>0;r<20;});
								//if(debug) $display("m=%d",m);								
							end
				endcase	
				
				driverChannel.put({m,r});
				sent_queue.push_back({m,r});
				if(file) begin 
				$fwrite(multiplicand_file,"%0d\n",m);
				$fwrite(multiplier_file,"%0d\n",r);
				end
			end
		       	
       	driverChannel.flush_pipe;		
                 
		endtask

	endclass


	module booth_hvl;

		scoreboard scb;
		stimulus_gen stim_gen;
		integer runs;
		reg [15:0]signs;

		task run();
		  integer i;
			fork
			begin
				scb.run();
			end
			join_none
        
			fork			
			begin
				stim_gen.run(runs,signs);
			end			
			join_none
		endtask

		initial 
		fork
		  if($value$plusargs("RUNS=%d",runs))
		    $display("Generating %d Operands",runs);
		    
		   if($value$plusargs("SIGNS=%s",signs))
		    $display("Generating Multiplicand with %c Sign and Multiplier with %c Sign",signs[15:8],signs[7:0]);
		    		
			scb = new();
			stim_gen = new();
			$display("\nStarted at"); $system("date");
			run();
			
			
		join_none

	final
	begin
		$display("\nEnded at"); $system("date");
		if(!error_count)
		$display("All tests are successful");
		else
		$display("%0d Tests failed",error_count);
	end
	endmodule
 



