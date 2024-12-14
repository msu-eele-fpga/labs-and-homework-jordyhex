library ieee;
use ieee.std_logic_1164.all;

entity one_pulse is
	port  (clk 	: in std_logic;
		rst 	: in std_logic;
		input 	: in std_logic;
		pulse 	: out std_logic);
end entity one_pulse;

architecture one_pulse_arch of one_pulse is

	signal prev_input : std_logic := '0';
begin

	ONE_PULSE : process (clk)
		begin
		if rst = '1' then
			pulse <= '0';
		elsif rising_edge(clk) then 
			if (input = '1' and prev_input = '0') then
				pulse <= '1';
			else
				pulse <= '0';
			end if;
		prev_input <= input;
		end if;
	end process;

end architecture;
