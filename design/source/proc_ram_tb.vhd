
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity proc_ram_tb is
end proc_ram_tb;

architecture arch of proc_ram_tb is
  constant T : time := 20 ns; 

  signal clk          : std_logic;
  signal nrst          : std_logic;
  signal dataout   :  unsigned(32 - 1 downto 0);
begin
   proc_top: entity work.proc_ram
      port map (
      	clk   => clk,
     	nrst => nrst,
	dataout => dataout
    );
    

    -- continuous clock
    process 
    begin
        clk <= '0';
        wait for T/2;
        clk <= '1';
        wait for T/2;
    end process;


    -- reset = 1 for first clock cycle and then 0
    nrst <= '0', '1' after 2*T;

end arch;