#!/bin/bash
# Makefile

# Default vhdl file to test
VERI_FILE_NAME = simple_proc
VERI_TB_FILE = $(VERI_FILE_NAME)_tb.cpp
VERI_FILE = $(VERI_FILE_NAME).sv

# Directories definition
VERI_DIRECTORY = $(shell pwd)
TEST_DIRECTORY = $(shell dirname $(VERI_DIRECTORY))
SRC_DIRECTORY = $(shell dirname $(TEST_DIRECTORY))/design/source


# Pointing to the VHDL file to test
VERI_SOURCE = $(SRC_DIRECTORY)/$(VERI_FILE)

EXTRA_ARGS += --trace -cc -Wno-fatal #-Wall
SIM_ARGS += --exe

all: compile sim 

compile:
	verilator $(EXTRA_ARGS) $(VERI_SOURCE) $(SIM_ARGS) $(VERI_TB_FILE)
#    --cc to get C++ output (versus e.g. SystemC or only linting).
#    --exe, along with our sim_main.cpp wrapper file, so the build will create an executable instead of only a library.
#    -Wall so Verilator has stronger lint warnings enabled.
#    An finally, our.v which is our SystemVerilog design file.

sim:
	make -C obj_dir -f V$(VERI_FILE_NAME).mk V$(VERI_FILE_NAME)
	./obj_dir/V$(VERI_FILE_NAME)

view:
	gtkwave waveform.vcd

format:
	./iStyle $(VERI_SOURCE)

clean:
	rm -R obj_dir
