# Source makefile: https://github.com/jimtremblay/ghdl-example/blob/master/Makefile
# Help ghdl: https://ghdl.github.io/ghdl/quick_start/simulation/DLXModelSuite.html

# Need to install ghdl and gtkwave

# vhdl files
FILES = source/*
VHDLEX = .vhd

# testbench
TESTBENCHPATH = testbench/${TESTBENCHFILE}$(VHDLEX)
TESTBENCHFILE = ram_tb

#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = 

SIMDIR = simulation
STOP_TIME = 500ns
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean make run view

compile:
	@$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHPATH) $(FILES)
	@$(GHDL_CMD) -m  $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHFILE)

make:
	@mkdir simulation
	make compile

run:
	@$(GHDL_CMD) -r  $(GHDL_FLAGS) --workdir=simulation $(TESTBENCHFILE) --wave=./$(SIMDIR)/wave.ghw 

view:
	gtkwave ./$(SIMDIR)/wave.ghw

clean:
	@rm -rf $(SIMDIR)

