library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_2_1 is
		port( SEL: in std_logic;
		A, B: in std_logic;
		Y: out std_logic
		);
end MUX_2_1;

architecture rtl of MUX_2_1 is

begin
	with sel select
		y<= A when '0',
			B when '1',
			'-' when others;
end rtl;

