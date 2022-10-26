
-- Simple generic RAM Model
--
-- +-----------------------------+
-- |    Copyright 2008 DOULOS    |
-- |   designer :  JK            |
-- +-----------------------------+

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity sync_ram is
  generic (
    DBus_Size  : INTEGER := 8;
    ABus_Size  : INTEGER := 10
  );
  port (
    clock   : in  std_logic;
    we      : in  std_logic;
    cs      : in  std_logic;
    address : in  unsigned(ABus_Size-1 downto 0);
    datain  : in  unsigned(DBus_Size-1 downto 0);
    dataout : out unsigned(DBus_Size-1 downto 0)
  );
end entity sync_ram;

architecture RTL of sync_ram is

   type ram_type is array (0 to (2**address'length)-1) of unsigned(datain'range);
   signal ram : ram_type;
   signal read_address : unsigned(address'range);

begin

  RamProc: process(clock) is

  begin
    if rising_edge(clock) then
      if (cs = '1') then
        if (we = '1') then
          ram(to_integer(address)) <= datain;
        end if;
        read_address <= address;
      end if;
    end if;
  end process RamProc;

  dataout <= ram(to_integer(read_address)) when cs = '1' else (others => 'Z');

end architecture RTL;
