## Verilator usage

/!\ Verilator and gtkWave are required!

To test a particular verilog file like `my_file.sv` do 
`make VERI_FILE_NAME=my_file`

then to open waveforme
`make view`

The source file needs to be located in design/source while the testbench in tests/verilog. The testbench file is a .cpp.

To use formatter please clone and install iStyle repository from gitHub then 
`make format`