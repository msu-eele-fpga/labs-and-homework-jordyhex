library ieee;
use ieee.std_logic_1164.all;

entity timed_counter is

	generic (clk_period : time;
	 	 count_time : time);

	port (clk 	: in std_ulogic;
	      enable 	: in boolean;
	      done 	: out boolean);

end entity timed_counter;

architecture timed_counter_arch of timed_counter is

	constant COUNTER_LIMIT: integer := count_time / clk_period;
	signal COUNT : integer range 0 to COUNTER_LIMIT := 0;

begin


COUNTER : process (clk) is 
begin

if rising_edge(clk) then


	if enable then
		if (COUNT < COUNTER_LIMIT) then 
			COUNT <= COUNT + 1;
			done <= false;

		else
			done <= true;
			COUNT <= 0;
			
		end if;
	else
		COUNT <= 0;
	end if;

end if;
end process;

end architecture;