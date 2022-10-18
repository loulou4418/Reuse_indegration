import cocotb
from cocotb.triggers import Timer

from conversion_handler import to_array



@cocotb.test()
async def test_decoder_simple(dut):
    """Test the decoder's output for different inputs"""

    # Retrieving the entry size
    ENTRY_SIZE = dut.ENTRY_SIZE.value.integer
    print(f"Decoder entry size: {ENTRY_SIZE}")

    # Covering all cases
    for input in range(2**ENTRY_SIZE):

        # Assign a value to address_msb signal
        dut.address_msb.value = to_array(input, ENTRY_SIZE)

        # Timer to trigger the value change
        await Timer(100, units="ns")
        
        # Display values & checking if the behavior is what's expected
        print(f"{input}: MSB: {dut.address_msb.value} ; CS_RAM = {dut.CS_ram.value}\n")
        assert (
            dut.cs_ram.value.integer == 2**dut.address_msb.value.integer
        ), f"Chip Select {dut.cs_ram.value} was incorrect for address_msb = {dut.address_msb.value}"
