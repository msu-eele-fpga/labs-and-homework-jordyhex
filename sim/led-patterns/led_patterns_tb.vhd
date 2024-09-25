library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity led_patterns_tb is
end entity led_patterns_tb;


architecture led_patterns_tb_arch of led_patterns_tb is

component led_patterns is
	port (clk 				: in std_ulogic;
		rst 			: in std_ulogic;
		push_button 	 	: in std_ulogic;
		switches 		: in std_ulogic_vector(3 downto 0);
		hps_led_control 	: in boolean;
		sys_clks_sec 	 	: in std_ulogic_vector(31 downto 0); 
		base_period 	 	: in unsigned(7 downto 0);
		led_reg 		: in std_ulogic_vector(7 downto 0);
		led 			: out std_ulogic_vector(7 downto 0)); 
end component led_patterns;

	constant CLK_PERIOD		: time := 20 ns;
	constant CLK_CYCLES_50 		: std_ulogic_vector(31 downto 0) := "00000010111110101111000010000000"; -- 50,000,000 clk cycles per second
	signal clk_tb 			: std_ulogic := '0';
	signal rst_tb 			: std_ulogic := '0';
	signal push_button_tb 	 	: std_ulogic := '0';
	signal switches_tb 		: std_ulogic_vector(3 downto 0) := "0000";
	signal hps_led_control_tb 	: boolean := false;
	signal sys_clks_sec_tb 	 	: std_ulogic_vector(31 downto 0) := "00000010111110101111000010000000"; 
	signal base_period_tb 	 	: unsigned(7 downto 0) := "00010000";
	signal led_reg_tb 		: std_ulogic_vector(7 downto 0) := "00000000";
	signal led_tb 			: std_ulogic_vector(7 downto 0); 
	
begin

DUT : led_patterns
	port map (clk 		=> clk_tb,
		rst 		=> rst_tb,
		push_button 	=> push_button_tb,
		switches 	=> switches_tb,
		hps_led_control => hps_led_control_tb,
		sys_clks_sec 	=> sys_clks_sec_tb,
		base_period 	=> base_period_tb,
		led_reg 	=> led_reg_tb,
		led 		=> led_tb);

clk_tb <= not clk_tb after CLK_PERIOD / 2;

rst_tb <= '0';
STIMULUS : process is
begin


	for i in 0 to 15 loop

		switches_tb <= std_ulogic_vector(to_unsigned(i, 4));
        	push_button_tb <= not push_button_tb;
		push_button_tb <= not push_button_tb;
        	
		wait for CLK_PERIOD * 2;

        
        	wait for 100 ns;

	end loop;

end process STIMULUS;

end architecture led_patterns_tb_arch;
