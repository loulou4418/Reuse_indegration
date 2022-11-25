library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity proc_ram is
    generic (
      nb_msb    : INTEGER := 1;
      abus_size : INTEGER := 8;
      dbus_size : INTEGER := 32
    );
    port(
      clk, nrst : in std_logic;
      dataout   : out unsigned(dbus_size - 1 downto 0)
    ); 
end proc_ram;

architecture structure of proc_ram is

  signal we          : std_logic;
  signal address_in  : unsigned(abus_size - 1 downto 0);
  signal DataToRead  : unsigned(dbus_size - 1 downto 0);
  signal DataToWrite : unsigned(dbus_size - 1 downto 0);
    
  -- define Verilog component 
  component simple_proc is 
    port(
      clk, nrst : in std_logic;
      datain    : in unsigned(dbus_size - 1 downto 0);
      we        : out std_logic;
      address   : out unsigned(abus_size - 1 downto 0);
      dataout   : out unsigned(dbus_size - 1 downto 0)
    );
  end component;
  
  begin
    -- use Verilog component i.e. simple proc
    proc: simple_proc
      port map (
        clk     => clk, 
        nrst    => nrst, 
        we      => we,
        datain  => DataToRead,
        address => address_in,
        dataout => DataToWrite
    );

    ram: entity work.sync_quadram(cell)
    generic map (dbus_size, abus_size, nb_msb)
    port map (
      clock   => clk,
      we      => we,
      address => address_in,
      datain  => DataToWrite,
      dataout => DataToRead
    );

end structure;