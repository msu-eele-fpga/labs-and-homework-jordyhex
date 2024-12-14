library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns is

port (clk 				 : in std_logic;
		rst 				 : in std_logic;
		push_button 	 : in std_logic;
		switches 		 : in std_logic_vector(3 downto 0);
		hps_led_control : in std_logic;
		sys_clks_sec 	 : in std_logic_vector(31 downto 0); -- 50 MHz (50 million clock cycles) 
		base_period 	 : in std_logic_vector(7 downto 0);
		led_reg 			 : in std_logic_vector(7 downto 0);
		led 				 : out std_logic_vector(7 downto 0));
end entity led_patterns;


architecture led_patterns_arch of led_patterns is

	type state_type is (TRANSITION, STATE_0, STATE_1, STATE_2, STATE_3, STATE_4);
	signal state, previous_state : state_type := STATE_0;
	
	signal RATE_1			: unsigned(39 downto 0) := unsigned(base_period) * unsigned(sys_clks_sec);	-- 1 second
	signal RATE_2			: integer					:= to_integer(RATE_1(39 downto 3));			-- 2 seconds
	signal RATE_P5			: integer 					:= to_integer(RATE_1(39 downto 5));			-- 1/2 second 
	signal RATE_P25		: integer 					:= to_integer(RATE_1(39 downto 6));			-- 1/4 second
	signal RATE_P12p5		: integer					:= to_integer(RATE_1(39 downto 7));			-- 1/8 seconds	
	signal RATE_P6p25		: integer					:= to_integer(RATE_1(39 downto 8));			-- 1/16 seconds	
	signal CLK_CYCLES_50	: integer					:= 50000000;
	
	signal led_7_cnt 			: integer range 0 to CLK_CYCLES_50 := 0;
	signal transition_cnt 	: integer range 0 to CLK_CYCLES_50 := 0;
	signal led_cnt 			: integer := 0;
	signal ledr 				: std_logic_vector(7 downto 0) := "01000000";
	signal up_down_cnt 		: unsigned(6 downto 0) := "0000000";

begin
	
PATTERNS : process (clk, hps_led_control, state, push_button, rst) is
begin

	if hps_led_control = '0' then
	
		if rst = '1' then 							
			led(7 downto 0)  <= "00000000";
			ledr(7 downto 0) <= "11000000";
			led_cnt <= 0;
			transition_cnt <= 0;
			led_7_cnt <= 0;
			state <= STATE_0;	
			
		elsif rising_edge(clk) then
			
			if push_button = '1' then
				state <= TRANSITION;
				transition_cnt <= 0;
			end if;
			
			if (state /= transition) then 
				led_cnt <= led_cnt + 1; 
				led <= ledr;  
			end if;
			
			case state is
			
				when TRANSITION =>
					led(7 downto 0) <= "0000" & switches(3 downto 0);		-- Display switch value I want led 7 to be zero
					transition_cnt <= transition_cnt + 1;
					
					if transition_cnt = CLK_CYCLES_50 then
						transition_cnt <= 0;
					   led_cnt <= 0;
						led_7_cnt <= 0;
						case switches is
							when "0000" => 
								ledr(6 downto 0) <= "1000000";
								state <= STATE_0;
							when "0001" =>
								ledr(6 downto 0) <= "0000011";
								state <= STATE_1;
							when "0010" =>
								ledr(7 downto 0) <= "10000000";
								up_down_cnt <= "0000000";
								state <= STATE_2;
							when "0011" => 
								ledr(7 downto 0) <= "11111111";
								up_down_cnt <= "1111111";
								state <= STATE_3;
							when "0100" => 
								ledr(6 downto 0) <= "0000001";
								state <= STATE_4;
							when others => state <= previous_state;
						end case;
						
					end if;
				
				when STATE_0 =>									-- 25,000,000 clock cycles 1/2 of a second
					if led_cnt = RATE_P5 then 					
						led_cnt <= 0;
						ledr(6 downto 0) <= (ledr(0) & ledr(6 downto 1));
					end if;
					previous_state <= state;
				
				when STATE_1 => 									-- 12,500,000 clock cycles 1/4 of a second				
						if led_cnt = RATE_P25 then
							led_cnt <= 0;
							ledr(6 downto 0) <= (ledr(4 downto 0) & ledr(6 downto 5));
						end if;
						previous_state <= state;
				
				when STATE_2 =>									-- 100,000,000 clock cycles is 2 seconds
					if led_cnt = RATE_2 then
						led_cnt <= 0;
						up_down_cnt <= up_down_cnt + 1;
						ledr(6 downto 0) <= std_logic_vector(up_down_cnt);
					end if;
					previous_state <= state;
				
				when STATE_3 =>									-- 6,250,000 clock cycles 1/8 of a second					
					if led_cnt = RATE_P12p5 then
						led_cnt <= 0;
						up_down_cnt <= up_down_cnt - 1;
						ledr(6 downto 0) <= std_logic_vector(up_down_cnt);
					end if;
					previous_state <= state;
				
				when STATE_4 =>									-- 3,125,000 clock cycles 1/16 of a second
					if led_cnt = RATE_P6p25 then 
						led_cnt <= 0;
						ledr(6 downto 0) <= (ledr(5 downto 0) & ledr(6));
					end if;
					previous_state <= state;
				when others => led(6 downto 0) <= "1111111";
			end case;
			
			led_7_cnt <= led_7_cnt + 1;
			
			if led_7_cnt = CLK_CYCLES_50 then
				led_7_cnt <= 0;
				ledr(7) <= not ledr(7);
			end if;
			
		end if;
		
	elsif hps_led_control = '1' then
		
		led <= led_reg;
		
	end if;
	
end process PATTERNS;


end architecture led_patterns_arch;