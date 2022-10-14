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

# ramchip.vhd:
ABUS_SIZE = 10
DBUS_SIZE = 8
ifeq ($(VHDL_FILE), ramchip.vhd)
	SIM_ARGS += -gABUS_SIZE=$(ABUS_SIZE) -gDBUS_SIZE=$(DBUS_SIZE)
	TOPLEVEL = sync_ram
	MODULE = test_ramchip
endif

# Pointing to the VHDL file to test
VHDL_SOURCES = $(SRC_DIRECTORY)/$(VHDL_FILE)

EXTRA_ARGS += --std=08
SIM_ARGS += --wave=wave.ghw

# Export generics to test
# Can't use plusargs since they aren't supported by ghdl
export ENTRY_SIZE
export DBUS_SIZE
export ABUS_SIZE

include $(shell cocotb-config --makefiles)/Makefile.sim

