library ieee;
use ieee.std_logic_1164.all;

entity async_conditioner is
	port 	(clk 	: in std_ulogic;
		rst 	: in std_ulogic;
		async 	: in std_ulogic;
		sync 	: out std_ulogic
);
end entity async_conditioner;

architecture async_conditioner_arch of async_conditioner is

	signal sync_out : std_ulogic;
	signal debounced_out : std_ulogic;

component synchronizer is
    port (
		clk          : in   std_ulogic;
            async          : in   std_ulogic;
            sync           : out  std_ulogic);
end component synchronizer;

component debouncer is
	generic (clk_period 	: time := 20 ns;
	 	debounce_time 	: time);
	port (clk 		: in std_ulogic;
		rst 		: in std_ulogic;
		input 		: in std_ulogic;
		debounced 	: out std_ulogic);
end component debouncer;


component one_pulse is
	port (clk 	: in std_ulogic;
		rst 	: in std_ulogic;
		input 	: in std_ulogic;
		pulse 	: out std_ulogic);
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