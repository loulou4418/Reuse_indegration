from cocotb.types import LogicArray

def to_array(value: int, nb_bits: int) -> str:
    """Convert the int value to a logic array"""
    res = "{0:b}".format(value)
    while len(res) != nb_bits:
        res = "0" + res
    return LogicArray(res)