from distutils.command.build_scripts import first_line_re
import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from conversion_handler import to_array


@cocotb.test()
async def test_write_enable(dut):
    """ Test write enable signal """

    clock = Clock(dut.clock, 10, units="ns")  # Create a 10ns period clock on port clk
    cocotb.start_soon(clock.start())  # Start the clock

    # Chip Select always active for this test
    dut.cs.value = 1
    
    # Define a random address
    dut.address.value = to_array(random.randint(0, 2**dut.ABus_Size.value - 1), dut.ABus_Size.value)
    await RisingEdge(dut.clock)
    print(f"RAM address: {dut.address.value}")

    for i in range(10):
        # Define a random input data
        dut.datain.value = to_array(random.randint(0, 2**dut.DBus_Size.value - 1), dut.DBus_Size.value)
        print(f"Step {i+1}: datain = {dut.datain.value}")

        # Enable write every two cycles
        dut.we.value = i % 2
        await RisingEdge(dut.clock)

        # Display the results
        print(
            f"Step {i+1}: we = {dut.we.value} input = {dut.datain.value} output = {dut.dataout.value}"
        )

@cocotb.test()
async def test_chip_select(dut):
    """ Test chip select signal """

    clock = Clock(dut.clock, 10, units="ns")  # Create a 10ns period clock on port clk
    cocotb.start_soon(clock.start())  # Start the clock

    # Write Enable always active for this test
    dut.we.value = 1

    dut.address.value = to_array(random.randint(0, 2**dut.ABus_Size.value - 1), dut.ABus_Size.value)
    await RisingEdge(dut.clock)
    print(f"RAM address: {dut.address.value}")

    activation_set = [1, 3, 4, 6, 9]
    prev_input_data = 0
    
    for i in range(10):
        # Chip Select active only for certain steps
        dut.cs.value = 1 if i in activation_set else 0

        # Define random data input
        dut.datain.value = to_array(random.randint(0, 2**dut.DBus_Size.value - 1), dut.DBus_Size.value)
        await RisingEdge(dut.clock)

        # Display the resultss
        print(
            f"Step {i+1}: cs = {dut.cs.value} prev input = {prev_input_data} output = {dut.dataout.value}"
        )

        # Check the behavior
        if dut.cs.value == 1:
            assert prev_input_data == dut.dataout.value, f"{dut.datain.value} =/= {dut.dataout.value}"

        # Save the previous input
        prev_input_data = dut.datain.value
        

