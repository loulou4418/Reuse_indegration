library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity sync_quadram is
    generic (
      DBus_Size   : INTEGER := 32;
      ABus_Size   : INTEGER := 12;
      Nb_MSB : INTEGER := 2
    );
    port (
      clock   : in  std_logic;
      we      : in  std_logic;
      address : in  unsigned(ABus_Size-1 downto 0);
      datain  : in  unsigned(DBus_Size-1 downto 0);
      dataout : out unsigned(DBus_Size-1 downto 0)
    );
end entity sync_quadram;

architecture cell of sync_quadram is

    signal cs_ram         : unsigned(2**Nb_MSB-1 downto 0);
    alias address_msb_in  : unsigned(Nb_MSB-1 downto 0) is address(ABus_Size-1 downto ABus_Size-Nb_MSB-1);

begin  

    Decoder: entity work.Address_Decoder(decoder)
    generic map (Nb_MSB)
    port map (
        address_msb => address_msb_in,
        CS_ram => cs_ram
    );

    boucle:for I in 0 to 2**Nb_MSB-1 generate
        RAM: entity work.sync_ram(RTL)
        generic map (DBus_Size, ABus_Size)
        port map (
            clock   => clock,
            we      => we,
            cs      => cs_ram(I),
            address => address,
            datain  => datain,
            dataout => dataout
        );
    end generate;

end architecture cell;