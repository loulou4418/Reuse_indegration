# Makefile

TOPLEVEL_LANG = vhdl

# Directories definition
TEST_DIRECTORY = $(shell pwd)
SRC_DIRECTORY = $(shell dirname $(TEST_DIRECTORY))/src/

# Default vhdl file to test
VHDL_FILE = decoder.vhd

## Definition of default generic values for each file

# decoder.vhd:
ENTRY_SIZE = 2
ifeq ($(VHDL_FILE), decoder.vhd)
	SIM_ARGS += -gENTRY_SIZE=$(ENTRY_SIZE)
	TOPLEVEL = address_decoder
	MODULE = test_address_decoder
endif

# Pointing to the VHDL file to test
VHDL_SOURCES = $(SRC_DIRECTORY)/$(VHDL_FILE)

EXTRA_ARGS += --std=08
SIM_ARGS += --wave=wave.ghw

# Export generics to test
# Can't use plusargs since they aren't supported by ghdl
export ENTRY_SIZE

include $(shell cocotb-config --makefiles)/Makefile.sim

