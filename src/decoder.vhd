library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity Address_Decoder is 
  generic (
    Entry_Size  : INTEGER := 2
  );
  port (
    address_msb : in  unsigned(Entry_Size-1 downto 0);
    CS_ram : out unsigned(2**Entry_Size-1 downto 0) := (others => '0')
  );
end entity Address_Decoder;

architecture decoder of Address_Decoder is

begin  

  -- left shift performed on unsigned is a logical shift:
  -- we set a vector of value 1 with a size depending on the entry size
  -- and then perform the required amout of left shifts necesary depending
  -- on address_msb value.
  CS_ram <= shift_left(to_unsigned(1, 2**Entry_Size), to_integer(address_msb));

end architecture decoder;