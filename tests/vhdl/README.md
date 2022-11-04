# Design Reuse and Integration

## Compile the sources
Execute `make` here.
It will :

* First, analyse all the design units for the design hierarchy, in the correct order. GHDL provides an easy way to do this, by importing the sources in this directory : ``ghdl -i *.vhdl``

* Then, run the make command, ``ghdl -m <file_tb>``, which analyses and elaborates a design. 

* Then, run the test suite `` ghdl -r <file_tb>``

* Finally, display thanks to ``gtkwave`` by opening a window automatically.