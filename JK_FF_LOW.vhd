library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JK_FF_LOW is
	port(
		CLK: 	in std_logic; 
		J: 	in std_logic; 
		K: 	in std_logic; 
		RST:	in std_logic;
		Q: 	out std_logic;
		N_Q:	out std_logic
	);
end JK_FF_LOW;

architecture rtl of JK_FF_LOW is
signal T_Q: std_logic;
begin
	ff_sr: process( CLK )
	begin
		if(RST = '1') then
			T_Q <= '0';
		else
			if( CLK'event and CLK = '1') then
				if(J='1' and K='0') then
					T_Q <= '0';
				elsif (J='0' and K='1') then
					T_Q <= '1';
				elsif(J='1' and K='1') then 
					null;
				elsif(J='0' and K='0') then 
					T_Q <= not(T_Q);
				else
					T_Q <= '0';
				end if;
			end if;
		end if;
	end process;
	Q <= T_Q;
	N_Q <= not T_Q;
end rtl;