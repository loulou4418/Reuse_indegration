
-- test bench solution to ex09

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_std.all;

entity Ram_TB is
end entity Ram_TB;

architecture Bench of Ram_TB is
  
  constant   cte_DBus_Size  : INTEGER := 8;
  constant   cte_ABus_Size  : INTEGER := 10;

  signal Address :unsigned(cte_ABus_Size-1 downto 0);
  signal DataIn, DataOut :unsigned(cte_DBus_Size-1 downto 0);
  signal WE : Std_logic;
  signal CS : Std_logic := '0';
  signal clock : Std_logic;
  signal StopClock : boolean := FALSE;

begin

  UUT: entity work.sync_ram(RTL)
  generic map(cte_DBus_Size, cte_ABus_Size)
  port map (
    clock   => clock,
    we      => WE,
    cs      => CS,
    address => Address,
    datain  => DataIn,
    DataOut => DataOut
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
    datain <=    "00000000";
    address <= "0000000001";
    we <= '0';

    wait until rising_edge(clock); -- cycle 2
    we <= '1';
    datain <= "00000100";

    wait until rising_edge(clock); -- cycle 3
    cs <= '1';
    datain <=    "00000111";
    address <= "0000000010";

    wait until rising_edge(clock); -- cycle 4
    we <= '0';

    wait until rising_edge(clock); -- cycle 5
    address <= "0000000001";

    wait until rising_edge(clock); -- cycle 6
    address <= "0000000010";

    wait until rising_edge(clock); -- cycle 7
    wait until rising_edge(clock); -- cycle 8

    StopClock <= true;
    wait;
  end process;

end architecture Bench;

architecture Bench2 of Ram_TB is

  signal Address :unsigned(9 downto 0);
  signal DataIn, DataOut :unsigned(7 downto 0);
  signal WE : Std_logic;
  signal CS : Std_logic := '1';
  signal clock : Std_logic;
  signal StopClock : boolean := FALSE;

  signal ok: boolean := true;

begin

  UUT: entity work.sync_ram(RTL)
  generic map(8, 8)
  port map (
    clock   => clock,
    we      => WE,
    cs      => CS,
    address => Address,
    datain  => DataIn,
    DataOut => DataOut
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

    -- Initialise input signals
    address <= "0000000000";
    datain  <=   "00000000";
    we <= '0';
    wait until rising_edge(clock);

    -- write to all addresses
    while address /= "1111111111" loop
      we <= '1';
      wait until rising_edge(clock);
      address <= address + 1;
      datain  <= datain + 1;
    end loop;

    -- stop writing
    address <= "0000000000";
    datain  <=   "00000000";
    we <= '0';
    wait until rising_edge(clock);

    -- read from all addresses
    while address /= "1111111111" loop
      address <= address + 1;
      wait until rising_edge(clock);
      -- ok should permanently go false on the first error
      ok <= ok and dataout = address(7 downto 0) - 1;
    end loop;

    StopClock <= true;
    wait;
  end process;

end architecture Bench2;
