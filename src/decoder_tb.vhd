library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity Decoder_TB is
end entity Decoder_TB;

architecture Bench of Decoder_TB is
    
    constant cte_Size  : INTEGER := 2;

    signal Address_MSB : unsigned(cte_Size-1 downto 0);
    signal CS_ram      : unsigned(2**cte_Size-1 downto 0);

begin

    UUT: entity work.Address_Decoder(decoder)
    generic map(cte_Size)
    port map (
        address_msb : Address_MSB;
        CS_ram : CS_ram
    );

    ClockGen: process is
    begin
    while not StopClock loop
        clock <= '0';
        wait for 5 ns;
        clock <= '1';
        wait for 5 ns;
    end loop;
    wait;
    end process ClockGen;

    Stim: process is

    begin

    wait until rising_edge(clock); -- cycle 1
    address_msb <= "00";
    assert CS_ram = "0001";

    wait until rising_edge(clock); -- cycle 2
    address_msb <= "01";
    assert CS_ram = "0010";

    wait until rising_edge(clock); -- cycle 3
    address_msb <= "10";
    assert CS_ram = "0100";

    wait until rising_edge(clock); -- cycle 4
    address_msb <= "11";
    assert CS_ram = "1000";

    StopClock <= true;
    wait;
    end process;

end architecture Bench;