library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity address_decode is
  generic (
    Entry_Size  : INTEGER := 2
  );
  port (
    address_msb : in  unsigned(Entry_Size-1 downto 0);
    CS_ram : out unsigned(2**Entry_Size-1 downto 0) := (others => '0')
  );
end entity address_decode;

architecture address_decode of address_decode is

begin  

  -- left shift performed on unsigned is a logical shift
  CS_ram <= shift_left(to_unsigned(1, 2**Entry_Size), to_integer(address_msb));

end architecture address_decode;