from secrets import randbelow
from math import log2
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from conversion_handler import to_array

@cocotb.test()
async def test_write_quadram(dut):
    """
    This test writes in random addresses of the quadram
    (10 write cycles) and then does 10 read cycles at the 
    same addresses to check if only the correct RAM cell
    had been written into.
    """

    clock = Clock(dut.clock, 100, units="ns")  # Create a 10ns period clock on port clk
    cocotb.start_soon(clock.start())  # Start the clock

    dut.we.value = 1
    NB_MSB = dut.Nb_MSB.value.integer
    ABUS_SIZE = dut.ABus_Size.value.integer
    DBUS_SIZE = dut.DBus_Size.value.integer

    max_addr = 2**ABUS_SIZE-1
    max_data = 2**DBUS_SIZE-1

    print(
        "\n"
        f"Number of MSB: {NB_MSB}\n"
        f"Address bus size: {ABUS_SIZE}\n"
        f"Data bus size: {DBUS_SIZE}\n"
    )

    addresses = []

    # Write cycles in different RAMs
    for i in range(10):
        wr_addr = to_array(randbelow(max_addr), ABUS_SIZE)
        dut.address.value = wr_addr
        addresses.append(wr_addr)

        dut.datain.value = to_array(randbelow(max_data), DBUS_SIZE)
        
        await RisingEdge(dut.clock)

        print(f"{dut.datain.value} written at {dut.address.value} in RAM {int(log2(dut.cs_ram.value.integer))}.")
    
    # Deactivate Write Enable
    dut.we.value = 0
    await RisingEdge(dut.clock)

    # Read cycles to check if the decoder's working
    for addr in addresses:
        dut.address.value = addr
        # Warning: Read Address is modified after a clock cycle so sometimes
        # the read can show undefined values.
        await RisingEdge(dut.clock)