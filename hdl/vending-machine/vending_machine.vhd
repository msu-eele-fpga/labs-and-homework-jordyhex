library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine is
port   (clk 	 : in std_ulogic;
	rst 	 : in std_ulogic;
	nickel 	 : in std_ulogic;
	dime 	 : in std_ulogic;
	dispense : out std_ulogic;
	amount 	 : out natural range 0 to 15
);
end entity vending_machine;

architecture vending_machine_arch of vending_machine is

	type state_type is (c0, c5, c10, c15);
	signal state : state_type;

begin

state_logic : process(clk, rst)
  begin
	if rst = '1' then
		state <= c0;
	elsif rising_edge(clk) then
		case state is
        		when c0 => 
				if ((dime = '1' and nickel = '1') or dime = '1') then
					state <= c10; 
				elsif (nickel = '1') then
            				state <= c5;
				else
					state <= c0;
				end if;
        		when c5 => 
				if ((dime = '1' and nickel = '1') or dime = '1') then
					state <= c15; 
				elsif (nickel = '1') then 
					state <= c10;
				else
           			 	state <= c5;
				end if;
        		when c10 => 
				if ((dime = '1' and nickel = '1') or dime = '1') then
					state <= c15; 
				elsif (nickel = '1') then 
					state <= c15;
				else
           			 	state <= c10;
				end if;
        		when others =>
          			state <= c0;	-- Accounts for c15 too
      		end case;

    	end if;
end process state_logic;

output_logic : process(state)
  begin
    case state is
      when c0 =>
        dispense <= '0';
        amount 	 <= 0;
      when c5 =>
        dispense <= '0';
        amount   <= 5;
      when c10 =>
        dispense <= '0';
        amount   <= 10;
      when c15 =>
        dispense <= '1';
        amount   <= 15;
      when others =>
        dispense <= '0';
        amount   <= 0;
    end case;
end process output_logic;

end architecture;