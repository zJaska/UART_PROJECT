library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF is
	port( CLK: in std_logic;
			D: in std_logic;
			ENABLE:in std_logic;
			RESET: in std_logic;
			Q: out std_logic
			);
end D_FF;

architecture rtl of D_FF is
begin
	ff:process(CLK,RESET)
	begin
		if ( RESET='1') then
			Q <='0';
		elsif(CLK'event and CLK='1' and ENABLE='1') then
			Q <=D;
		end if;
	end process;		
end rtl;

