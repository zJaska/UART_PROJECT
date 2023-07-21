library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Bit_Counter is
	generic( 
		N: integer 
	); 
	port( 
		tick: 	in std_logic; 
		reset: 	in std_logic; 
		enable: 	in std_logic;
		count: 	out std_logic_vector(N-1 downto 0) 
	);
end Bit_Counter;

architecture rtl of Bit_Counter is
	signal temp_count: std_logic_vector(0 to N-1) := (others => '0');
	signal t_sum: std_logic_vector(0 to N);
	signal t_a: std_logic_vector(N-1 downto 0);
	component Ripple_Carry_Adder is
		generic (
			N : integer
		);
		port (
			OP: 	in std_logic;
			A: 	in std_logic_vector(N-1 downto 0);
			B: 	in std_logic_vector(N-1 downto 0);
			S: 	out std_logic_vector(N downto 0)
		);
	end component;
begin
	t_a <= (0 => '1', others => '0');
	U1: Ripple_Carry_Adder
		generic map(
			N => N
		)
		port map(
			OP => '0',
			A => t_a,
			B => temp_count,
			S => t_sum
		);
		
	count_process: process( tick, reset, enable ) 
	begin 
		if( reset = '1' ) then 
			temp_count <= (others => '0'); 
		elsif(enable='1' AND ( tick'event and tick = '1' )) then 
			temp_count <= t_sum(1 to N); 
		end if; 
	end process;

	count <= temp_count;

end rtl;

