
//This is Verilog FSM Code for Booth's Multiplier. This is the DUT

import booth_pkg::*;
module booth_fsm (booth_if booth_port);
    
    typedef enum {INIT, LOAD, BOOTH, DONE} states; 
	
    states PS,NS;
	logic [$clog2(y)-1:0]counter;
	logic [x+y:0]booth_var;
	logic [x-1:0]sum;

	//Sequential FSM Logic

		always_ff @(posedge booth_port.clk)
		begin
			if(booth_port.reset)
			PS <= INIT;
			else
			PS <= NS;
		end


	//Next State Generation Logic

		always_comb
		begin
  
			case(PS)
    
			INIT:
			if(booth_port.load)
				NS=LOAD;
			else
				NS=INIT;
      
			LOAD: 
			if(booth_port.load)
				NS=LOAD;
			else
				NS=BOOTH;
      
			BOOTH:
			if(!(counter == (y-1)))
				NS=BOOTH;
			else
				NS=DONE;
    
			DONE:
			if(booth_port.load)
				NS=LOAD;
			else
				NS=DONE;
           
			default: NS=LOAD;
    
			endcase
		end


	// Load & Shift Logic

		always_ff @(posedge booth_port.clk)
		begin
  
			case (PS)
    
			INIT:
			begin
				booth_var <= 0;
				counter <= y-1;
				booth_port.done <=1;
      
			end
    
			LOAD: 
			begin
				booth_var <={{x{1'b0}},booth_port.r,1'b0};
				counter <= 0;
				booth_port.done <= 0;
			end
    
			BOOTH:
			begin
				booth_var[x+y:x+1] <= {sum[x-1],sum[x-1:1]};
				booth_var[x:0] <= {sum[0],booth_var[x:1]};
				counter <= counter + 1'b1;
				booth_port.done <= 0;        
			end
    
			DONE:
			begin 
				booth_port.product <= booth_var[x+y:1];
				booth_port.done <=1;
			end
   
			default: booth_var <={{x{1'b0}},booth_port.r,1'b0};
			endcase
		end


	// Booth Encoding Logic 
		always_comb
		begin
  
		case(booth_var[1:0])
    
			2'b00:  sum=booth_var[x+y:x+1];			 //No change
			2'b01:  sum=booth_var[x+y:x+1]+booth_port.m;		 //Add 
			2'b10:  sum=booth_var[x+y:x+1]+((~booth_port.m)+1); //Subtract (2's complement)
			2'b11:  sum=booth_var[x+y:x+1];			// No change
		endcase
		end


endmodule


