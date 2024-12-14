library ieee;
use ieee.std_logic_1164.all;

entity async_conditioner is
	port 	(clk 	: in std_logic;
		rst 	: in std_logic;
		async 	: in std_logic;
		sync 	: out std_logic
);
end entity async_conditioner;

architecture async_conditioner_arch of async_conditioner is

	signal sync_out : std_logic;
	signal debounced_out : std_logic;

component synchronizer is
    port (
		clk          : in   std_logic;
            async          : in   std_logic;
            sync           : out  std_logic);
end component synchronizer;

component debouncer is
	generic (clk_period 	: time := 20 ns;
	 	debounce_time 	: time);
	port (clk 		: in std_logic;
		rst 		: in std_logic;
		input 		: in std_logic;
		debounced 	: out std_logic);
end component debouncer;


component one_pulse is
	port (clk 	: in std_logic;
		rst 	: in std_logic;
		input 	: in std_logic;
		pulse 	: out std_logic);
end component one_pulse;

begin

U1 : synchronizer 
port map (
	clk => clk,
	async => async, 
	sync => sync_out
);

U2 : debouncer
generic map (
	clk_period => 20 ns,
	debounce_time => 100 ms)
port map (
	clk => clk,
	rst => rst,
	input => sync_out,
	debounced => debounced_out
);

U3 : one_pulse
port map (
	clk => clk,
	rst => rst,
	input => debounced_out,
	pulse => sync
);

end architecture async_conditioner_arch;