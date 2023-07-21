library IEEE;
use IEEE.std_logic_1164.ALL;

entity PISO is
	generic(
	N: integer 
	);
	port(
	CLK: in std_logic;
	RESET: in std_logic;
	LOAD: in std_logic;
	PRESET: in std_logic;
	ENABLE: in std_logic;
	XP: in std_logic_vector(0 to N-1);
	Y: out std_logic);
end PISO;

architecture rtl of PISO is
	signal Z: std_logic_vector(0 to N-1);
	begin
		reg:process (CLK,RESET,PRESET, ENABLE)
		begin 
			if(RESET='1') then
			Z <=(others => '0');
			elsif( PRESET='1') then
			Z <=(others => '1');
			elsif( CLK'event and CLK='1' and ENABLE='1') then
				if(LOAD='0') then
					Z <='1' & Z(0 to N-2);
				elsif(LOAD='1') then
					Z<=XP;
				end if;
			end if;
		end process;
			
	
	Y<=Z(N-1);
				

end rtl;

