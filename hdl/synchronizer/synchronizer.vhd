library IEEE;
use IEEE.std_logic_1164.all;

entity synchronizer is
    port   (clk            : in   std_ulogic;
            async          : in   std_ulogic;
            sync           : out  std_ulogic);
end entity synchronizer;


architecture synchronizer_arch of synchronizer is

	signal async_1 : std_ulogic;
begin

	SYNC_PROC : process (clk)
	begin
		if rising_edge(clk) then
			async_1 <=async;
			sync <= async_1;
		end if;
	end process; 

end architecture;
