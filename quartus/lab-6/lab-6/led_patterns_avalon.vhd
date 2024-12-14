library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns_avalon is
	port (
			clk 		: in std_logic;
			rst 		: in std_logic;
			-- avalon memory-mapped slave interface
			avs_read 		: in std_logic;
			avs_write 		: in std_logic;
			avs_address 	: in std_logic_vector(1 downto 0);
			avs_readdata 	: out std_logic_vector(31 downto 0);
			avs_writedata 	: in std_logic_vector(31 downto 0);
			-- external I/O; export to top-level
			push_button 	: in std_logic;
			switches 		: in std_logic_vector(3 downto 0);
			led 				: out std_logic_vector(7 downto 0)
);
end entity led_patterns_avalon;

architecture led_patterns_avalon_arch of led_patterns_avalon is

	signal hps_register		: std_logic_vector(31 downto 0) :=  "00000000000000000000000000000000"; 	-- hps_led_control
	signal led_register  	: std_logic_vector(31 downto 0) :=  "00000000000000000000000000000000"; 	-- led_reg
	signal base_register 	: std_logic_vector(31 downto 0)  := "00000000000000000000000000010000"; 	-- base_period
	signal sys_clk_register : std_logic_vector(31 downto 0) :=  "00000010111110101111000010000000";
	signal synced 				: std_logic;
	
component async_conditioner is
	port (
			clk 	: in std_logic;
			rst	: in std_logic;
			async	: in std_logic;
			sync 	: out std_logic
	);
end component async_conditioner;

component led_patterns is
	port (clk 				 : in std_logic;
			rst 				 : in std_logic;
			push_button 	 : in std_logic;
			switches 		 : in std_logic_vector(3 downto 0);
			hps_led_control : in std_logic;
			sys_clks_sec 	 : in std_logic_vector(31 downto 0); -- 50 MHz (50 million clock cycles) 
			base_period 	 : in std_logic_vector(7 downto 0);
			led_reg 			 : in std_logic_vector(7 downto 0);
			led 				 : out std_logic_vector(7 downto 0));
end component led_patterns;

begin
CONDITIONER:  async_conditioner 
	port map (clk 		=> clk, 
				 rst 		=> rst, 
				 async 	=> push_button, 
				 sync 	=> synced);

PATTERNS : led_patterns
	port map (clk 				 => clk,
				rst 				 => rst,
				push_button 	 => SYNCED,
				switches 		 => switches,
				hps_led_control => hps_register(0),
				sys_clks_sec 	 => sys_clk_register,
				base_period 	 => base_register(7 downto 0),
				led_reg 			 => led_register(7 downto 0),
				led				 => led);


avalon_register_read : process(clk)
begin

	if rising_edge(clk) and avs_read = '1' then
		case avs_address is
			when "00"	=> avs_readdata <= hps_register;
			when "01"	=> avs_readdata <= sys_clk_register;
			when "10"	=> avs_readdata <= led_register;
			when "11"	=> avs_readdata <= base_register;
			when others => avs_readdata <= (others => '0');
		end case;
	end if;

end process avalon_register_read;

avalon_register_write : process(clk, rst)
begin
	if rst = '1' then
		hps_register 		<= "00000000000000000000000000000000";
		sys_clk_register  <= "00000010111110101111000010000000";
		led_register		<= "00000000000000000000000000000000";
		base_register		<= "00000000000000000000000000010000";
	elsif rising_edge(clk) and avs_write = '1' then
		case avs_address is
			when "00"	=> hps_register 		<= avs_writedata;
			when "01"	=> sys_clk_register	<= avs_writedata;
			when "10"	=> led_register		<= avs_writedata;
			when "11"	=> base_register		<= avs_writedata;
			when others => null;
		end case;
	end if;
end process avalon_register_write;

end architecture led_patterns_avalon_arch;