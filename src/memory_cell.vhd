library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity memory_cell is
  generic (
    Address_MSB   : INTEGER := 2
    DBus_Size  : INTEGER := 8;
    ABus_Size  : INTEGER := 10
  );
  port (
    clock      : in  std_logic;
    we         : in  unsigned(2**Address_MSB downto 0);
    data_in    : in unsigned(DBus_Size-1 downto 0);
    address_in : in unsigned(ABus_Size-1 downto 0);
    data_out   : out unsigned(DBus_Size-1 downto 0) := (others => 'Z')
  );
end entity memory_cell;

architecture RAMS of memory_cell is

constant CellNb : INTEGER := 2**Address_MSB;
signal CS_ram : unsigned(CellNb-1 downto 0) := to_unsigned(0, CellNb);

begin

    Decoder: entity work.address_decode(address_decode)
    generic map(Address_MSB)
    port map (
        address_msb   => clock,
        CS_ram        => CS_ram
    );

    boucle:for I in 0 to CellNb generate
    RAM(I) : work.sync_ram(RTL)
    generic map(DBus_Size, ABus_Size)
    port map ( 
        clock   => clock,
        we      => we,
        cs      => Decoder.CS_ram(I),
        address => address_in,
        datain  => data_in,
        DataOut => data_out
    );
    end generate;
    
    data_out <= RAM(to_integer(Decoder.CS_ram)).data_out;


end architecture RAMS;