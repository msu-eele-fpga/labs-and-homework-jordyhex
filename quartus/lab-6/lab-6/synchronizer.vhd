library IEEE;
use IEEE.std_logic_1164.all;

entity synchronizer is
    port   (clk            : in   std_logic;
            async          : in   std_logic;
            sync           : out  std_logic);
end entity synchronizer;


architecture synchronizer_arch of synchronizer is

	signal async_1 : std_logic;
begin

	SYNC_PROC : process (clk)
	begin
		if rising_edge(clk) then
			async_1 <=async;
			sync <= async_1;
		end if;
	end process; 

end architecture;
