library ieee;
use ieee.std_logic_1164.all;

entity one_pulse_tb is
end entity one_pulse_tb;

architecture one_pulse_tb of one_pulse_tb is

    	component one_pulse
        port   (clk   : in  std_ulogic;
            	rst   : in  std_ulogic;
            	input : in  std_ulogic;
            	pulse : out std_ulogic);
    	end component;

    	-- Testbench Signals -- 
    	signal clk_tb   : std_ulogic := '0';
    	signal rst_tb   : std_ulogic := '0';
    	signal input_tb : std_ulogic := '0';
    	signal pulse_tb : std_ulogic := '0';
	signal pulse_expected : std_ulogic;

    	constant CLK_PERIOD : time := 20 ns;

begin

    DUT : one_pulse
    port map   (clk   => clk_tb,
            	rst   => rst_tb,
            	input => input_tb,
            	pulse => pulse_tb);

	-- Clock Generation --
	CLK_GEN : process is
  	begin
    		clk_tb <= not clk_tb;
    		wait for CLK_PERIOD / 2;

  	end process CLK_GEN;

    	-- STIMULUS PROCESSES -- 
	INPUT_STIM : process is
	begin
		rst_tb <= '1';   -- Testing reset
        	wait for 2 * CLK_PERIOD;

        	rst_tb <= '0';
        	wait for CLK_PERIOD;

		-- Test Case #1: Input rising edge
        	input_tb <= '0';
        	wait for CLK_PERIOD;
		input_tb <= '1';	-- Pulse should occur here
        	wait for CLK_PERIOD;
		input_tb <= '0';
        	wait for 2* CLK_PERIOD;

        	-- Test Case #2: Hold input high 
        	input_tb <= '1'; -- Check for extra pulses
        	wait for 3 * CLK_PERIOD;
        
        	-- Test Case #3: Hold input low
        	input_tb <= '0';
        	wait for 3 * CLK_PERIOD;

        	-- Test Case #4: Multiple input transitions 
        	input_tb <= '1';
        	wait for CLK_PERIOD;
        	input_tb <= '0';
        	wait for 2 * CLK_PERIOD;
        	input_tb <= '1';
        	wait for 2 * CLK_PERIOD;

        	wait;

    	end process INPUT_STIM;

	EXPECTED_PULSE : process is
	begin

		pulse_expected <= '0';
		wait for 4 * CLK_PERIOD;

		pulse_expected <= '1';
		wait for CLK_PERIOD;

		pulse_expected <= '0';
		wait for 2 * CLK_PERIOD;

		pulse_expected <= '1';
		wait for CLK_PERIOD;

		pulse_expected <= '0';
		wait for 5 * CLK_PERIOD;

		pulse_expected <= '1';
		wait for CLK_PERIOD;

		pulse_expected <= '0';
		wait for 2 * CLK_PERIOD;

		pulse_expected <= '1';
		wait for CLK_PERIOD;

		pulse_expected <= '0';
		wait;

	end process EXPECTED_PULSE;

	OUTPUT_CHECK : process is
	variable failed : boolean := false;
	begin

	for i in 0 to 9 loop

		if pulse_expected /= pulse_tb then
			report "Invalid pulse" severity error;
			failed := true;
		end if;
      		wait for CLK_PERIOD;
	end loop;

    		if failed then
      			report "Tests failed!" severity failure;
    		else
      			report "all tests passed!";
    		end if;

		wait;

	std.env.finish;
	end process OUTPUT_CHECK;
	

end architecture one_pulse_tb;
