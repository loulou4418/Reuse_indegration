#!/bin/bash

# Makefile

# Directories definition
VERI_DIRECTORY = $(shell pwd)
TEST_DIRECTORY = $(shell dirname $(VERI_DIRECTORY))
SRC_DIRECTORY = $(shell dirname $(TEST_DIRECTORY))/design/source

# Default vhdl file to test
VERI_FILE = alu.sv
VERI_TB_FILE = tb_alu.cpp

# Pointing to the VHDL file to test
VERI_SOURCE = $(SRC_DIRECTORY)/$(VERI_FILE)

EXTRA_ARGS += --trace -cc -Wno-fatal #-Wall
SIM_ARGS += --exe

compile:
	verilator $(EXTRA_ARGS) $(VERI_SOURCE) $(SIM_ARGS) $(VERI_TB_FILE)

sim:
	make -C obj_dir -f Valu.mk Valu
	./obj_dir/Valu
	gtkwave waveform.vcd

format:
	./iStyle $(VERI_SOURCE)
