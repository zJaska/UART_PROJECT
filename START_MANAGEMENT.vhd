library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity START_MANAGEMENT is
	port(
	--DEBUG
	
		CLOCK_MNG0: in std_logic;
		CLOCK_MNG1: in std_logic;
		CTS_MNG: in std_logic;
		START_MNG: in std_logic;
		RESET_START: in std_logic;
		RST_MNG: in std_logic;
		FF_OUT_START: out std_logic;
		LOAD_CONTROL: out std_logic
	);
end START_MANAGEMENT;

architecture rtl of START_MANAGEMENT is

	component D_FF is
		port( 
		CLK: in std_logic;
			D: in std_logic;
			RESET: in std_logic;
			ENABLE:in std_logic;
			Q: out std_logic
			);
	end component;
	
	signal TEMP_OUT_FF0: std_logic;
	signal TEMP_OUT_FF1: std_logic;
	
	signal CONTROL_START_ENABLE_FF0:std_logic;

begin

	U1: D_FF
		port map(
		CLK => CLOCK_MNG0,
		D=> START_MNG,
		ENABLE=>CONTROL_START_ENABLE_FF0,
		RESET=>RESET_START,
		Q=> TEMP_OUT_FF0
		);

	U2: D_FF
		port map(
		CLK => CLOCK_MNG1,
		D=> TEMP_OUT_FF0,
		ENABLE=>'1',
		RESET=>RST_MNG,
		Q=> TEMP_OUT_FF1
		);
		
	
	CONTROL_START_ENABLE_FF0<='1' when CTS_MNG='1' and TEMP_OUT_FF1='0' else
									  '0' when CTS_MNG='0' and TEMP_OUT_FF1='1' else
									  '0' when CTS_MNG='1' and TEMP_OUT_FF1='1' else
									  '0' when CTS_MNG='0' and TEMP_OUT_FF1='0' else
									  '0';
											
	
	LOAD_CONTROL<= '1' when TEMP_OUT_FF0='1' and TEMP_OUT_FF1='0' else
						'0';
	
	FF_OUT_START<='1' when TEMP_OUT_FF0='1' else
							'0';

end rtl;

