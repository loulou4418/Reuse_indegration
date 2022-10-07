## Cocotb usage

Cocotb provides an easier way of writing testbenches using Python.
/!\ ghdl.2.0 is required!

To test a particular vhdl file, do:

`make SIM=ghdl VHDL_FILE=foo.vhd`

It's possible to define generic values for a particular file in the command line.
By default: `make SIM=ghdl` points to decoder.vhd.