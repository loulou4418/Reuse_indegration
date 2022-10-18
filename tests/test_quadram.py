import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from conversion_handler import to_array

@cocotb.test()
async def test_write_quadram(dut):
    """Test the quadram's writing"""

    clock = Clock(dut.clock, 100, units="ns")  # Create a 10ns period clock on port clk
    cocotb.start_soon(clock.start())  # Start the clock

    dut.we.value = 1
    NB_MSB = dut.Nb_MSB.value.integer
    ABUS_SIZE = dut.ABus_Size.value.integer
    DBUS_SIZE = dut.DBus_Size.value.integer

    print(NB_MSB, ABUS_SIZE, DBUS_SIZE)

    for i in range(10):

        if i == 1:
            dut.address.value = to_array(0x311, ABUS_SIZE)
            dut.datain.value = to_array(0x4, DBUS_SIZE)
            print(to_array(0x4, DBUS_SIZE)._value)
        elif i == 4:
            dut.we.value = 0
            dut.address.value = to_array(0x311, ABUS_SIZE)

        else:
            address = (i % 3) << 8 | 0x55
            dut.address.value = to_array(address, ABUS_SIZE)
            dut.datain.value = to_array(i % 3, DBUS_SIZE)

        await RisingEdge(dut.clock)