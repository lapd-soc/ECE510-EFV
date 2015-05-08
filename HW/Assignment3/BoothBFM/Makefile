#Sameer Ghewari, Portland State University, Feb 2015
#This makefile is for TBX BFM Example - Simple booth

#Specify the mode- could be either puresim or veloce
#Always make sure that everything works fine in puresim before changing to veloce

MODE ?= veloce

#make all does everything
all: work build run

#Create respective work libs and map them 
work:
	vlib work.$(MODE)
	vmap work work.$(MODE)
	
#Compile/synthesize the environment
build:
	vlog booth_pkg.sv			#Compile the package
	vlog top_tb.sv			#Compile the testbench 
ifeq ($(MODE),puresim)		#If mode is puresim, compile everything else
	vlog booth_if.sv				#Compile the interface
	vlog booth_fsm.sv					#Compile the booth DUT 
	vlog top_hdl.sv				#Compule the HDL top 
	velhvl -sim $(MODE)
else						#else, synthesize!
	velanalyze booth_pkg.sv		#Analyze the package for synthesis 
	velanalyze -extract_hvl_info +define+QUESTA top_tb.sv	#Analyze the HVL for external task calls in BFM 
	velanalyze booth_if.sv			#Analyze the interface for synthesis
	velanalyze top_hdl.sv		#Analyze the HDL top for synthesis 
	velanalyze booth_fsm.sv			#Analyze the booth DUT for synthesis 
	velcomp -top top_hdl -$(MODE) 	#Synthesize!
	velhvl -sim $(MODE) 
endif

run:
	vsim -c -do "run -all" top_tb top_hdl	#Run all 
	cp transcript transcript.$(MODE)		#Record transcript 

norun:	#No run lets you control stepping etc. 
	vsim -c +tbxrun+norun top_tb top_hdl -cpppath $(CPP_PATH)
	cp transcript transcript.$(MODE)

clean:
	rm -rf work work.puresim work.veloce transcript *~ vsim.wlf *.log dgs.dbg dmslogdir veloce.med veloce.wave veloce.map velrunopts.ini edsenv 
	


