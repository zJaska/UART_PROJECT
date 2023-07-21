library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Tick_Counter is
	generic(
		N : integer:= 16
	);
	port(
		clock: 		in std_logic;
		preset:		in std_logic;
		enable:		in std_logic;
		tick:			out std_logic;
		m_tick:		out std_logic;
		qtr_1_tick:	out std_logic;
		qtr_3_tick:	out std_logic
	);
end Tick_Counter;

architecture rtl of Tick_Counter is
signal tmp: std_logic_vector(N-1 downto 0):= (others => '0');
begin
	process(clock, preset, enable)
		begin
		if preset = '1' then
			tmp <= (0 => '1', others => '0');
		elsif (enable='1' and clock'event and clock = '1' ) then
			tmp <= (tmp(0) & tmp(N-1 downto 1));
		end if;
	end process;
	
	qtr_3_tick <= tmp(N/4 - 1);
	qtr_1_tick <= tmp((3*N)/4 - 1);
	m_tick <= tmp(N/2 - 1);
	tick <= tmp(N-1);

end rtl;

