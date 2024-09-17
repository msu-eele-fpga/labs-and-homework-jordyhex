library ieee;
use ieee.std_logic_1164.all;

entity one_pulse is
	port  (clk 	: in std_ulogic;
		rst 	: in std_ulogic;
		input 	: in std_ulogic;
		pulse 	: out std_ulogic);
end entity one_pulse;

architecture one_pulse_arch of one_pulse is

	signal prev_input : std_ulogic := '0';
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
