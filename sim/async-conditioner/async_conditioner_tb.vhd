library ieee;
use ieee.std_logic_1164.all;

entity async_conditioner_tb is
end entity async_conditioner_tb;

architecture async_conditioner_tb_arch of async_conditioner_tb is

	signal clk_tb 	: std_ulogic := '0';
	signal rst_tb 	: std_ulogic := '0';
	signal async_tb : std_ulogic := '0';
	signal sync_tb 	: std_ulogic := '0';

	constant CLK_PERIOD : time := 20 ns;


component async_conditioner is
	port 	(clk 	: in std_ulogic;
		rst 	: in std_ulogic;
		async 	: in std_ulogic;
		sync 	: out std_ulogic
);
end component async_conditioner;

begin

DUT : async_conditioner
port map (
	clk => clk_tb,
	rst => rst_tb,
	async => async_tb,
	sync => sync_tb
);

clk_tb <= not clk_tb after CLK_PERIOD / 2;

STIM : process is

begin
	async_tb <= '0'; 
	wait for 1 ms;
	async_tb <= '1';
	wait for 1 ms;
	async_tb <= '0';
	wait for 251 ms;
	async_tb <= '1'; 
	wait for 3 ms;
	async_tb <= '0'; 
	wait for 5 ms;
	async_tb <= '1'; 
	wait for 7 ms;
	async_tb <= '0'; 
	wait for 5 ms;
	async_tb <= '1'; 
	wait for 7 ms;
	async_tb <= '0'; 
	wait for 155 ms;

	async_tb <= '1'; 
	wait for 1 ms;
	async_tb <= '0';
	wait for 30 ms; 
	rst_tb <= '1'; 
	wait for 50 ms;
	rst_tb <= '0'; 
	wait for 50 ms;
	async_tb <= '1'; 
	wait for 150 ms;

end process STIM;



end architecture async_conditioner_tb_arch;
