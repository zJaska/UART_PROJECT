library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SIPO is
	generic(
		N: integer
	);
	port(
		tick: 	in std_logic;
		rx: 		in std_logic;
		enable: 	in std_logic;
		reset: 	in std_logic;
		B_OUT: 	out std_logic_vector(N-1 downto 0)
	);
end SIPO;

architecture rtl of SIPO is
signal t_shift : std_logic_vector(N-1 downto 0);
begin
	sipo : process (tick, reset, enable)
	begin
		if(reset='1') then
			t_shift <= (others => '0');
		elsif(enable='1' AND ( tick'event and tick = '1' )) then       
			t_shift <= (rx & t_shift(N-1 downto 1));
		end if;
	end process;

	B_OUT <= t_shift;


end rtl;

