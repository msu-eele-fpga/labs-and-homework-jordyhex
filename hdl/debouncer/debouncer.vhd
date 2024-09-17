library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
	generic (clk_period : time := 20 ns;
	 	 debounce_time : time
	);

	port   (clk 	: in std_ulogic;
		rst 	: in std_ulogic;
		input 	: in std_ulogic;
		debounced : out std_ulogic
	);
end entity debouncer;

architecture debouncer_arch of debouncer is

	constant count_max 	: integer := debounce_time/clk_period - 2;
	signal count 		: integer range 0 to count_max := 0;
	type state_type is (set, debouncing);
	signal state : state_type;

begin

	DEBOUNCER : process (clk)
	begin
		if rst = '1' then
			debounced <= '0';
			state <= set;
		elsif rising_edge(clk) then

			case state is
				when set 	=> if input /= debounced then
							state <= debouncing;
							debounced <= input;
							count <= 0;
						   end if;
					
				when debouncing => if count = count_max then
							state <= set;
						   else
							count <= count + 1;
					           end if;
	
			end case;
		end if;
		
	end process DEBOUNCER;

end architecture;