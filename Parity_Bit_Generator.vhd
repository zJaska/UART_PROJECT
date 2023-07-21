library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Parity_Bit_Generator is
	port(
		d_in: 				in std_logic;
		tick:					in std_logic;
		reset:				in std_logic;
		preset:				in std_logic;
		enable:				in std_logic;
		even_p: 				out std_logic
	);
end Parity_Bit_Generator;

architecture rtl of Parity_Bit_Generator is

signal TMP : std_logic;

begin
   ff_t : process (tick, reset, enable, preset)
	begin
		if(reset='1') then
			TMP <= '0';
		elsif(preset='1') then
			TMP <= '1';
		elsif(enable='1' AND ( tick'event and tick = '1' ) AND d_in = '1') then       
			TMP <= not(TMP);
		end if;
	end process;
	
	even_p <= TMP;

end rtl;

