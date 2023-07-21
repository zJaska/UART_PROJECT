library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Transmitter_TX is
	port(
		RESET_ALL_TX:in std_logic;
		CLK: in std_logic;
		START: in std_logic;
		CTS: in std_logic;
		B_IN: in std_logic_vector(0 to 6);--osservare
		AVAILABLE:out std_logic;
		TX_OUT: out std_logic);
end Transmitter_TX;

architecture rtl of Transmitter_TX is

	signal RESET_START_MNG: std_logic;
	signal WORKING:std_logic;
	signal LOAD_CONTROLLER:std_logic;
	
	signal PRESET_PISO:std_logic;
	signal ENABLE_PISO:std_logic;
	signal STOP_BIT:std_logic;
	signal START_BIT:std_logic;

	constant thisN : integer := 9; 
	
	signal BIT_COUNTER_RST:std_logic;
	signal BIT_COUNTER_ENABLE:std_logic;
	signal BIT_COUNTER_OUT:std_logic_vector(0 to 3);
	signal FINISHED:std_logic;--contato fino a 10
	
	signal ENTRY_A_MUX:std_logic;
	signal ENTRI_B_MUX:std_logic;
	signal SELECT_MUX:std_logic;
	
	signal RESET_PARITY_BIT_GEN:std_logic;
	signal PRESET_PARITY_BIT_GEN:std_logic;
	signal ENABLE_PARITY_BIT_GEN:std_logic;
	
	signal TICK:std_logic;--Baudrate
	signal PRESET_JOHNSON:std_logic;
	signal ENABLE_JOHNSON:std_logic;
	
	signal L_RESET_START:std_logic;

	component START_MANAGEMENT is
	port(
		CLOCK_MNG0: in std_logic;
		CLOCK_MNG1: in std_logic;
		CTS_MNG: in std_logic;
		START_MNG: in std_logic;
		RST_MNG: in std_logic;
		RESET_START: in std_logic;
		FF_OUT_START: out std_logic;
		LOAD_CONTROL: out std_logic
	);
	end component;
	
	component PISO is
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
	end component;

	component Bit_Counter is
	generic( 
		N: integer 
	); 
	port( 
		tick: 	in std_logic; 
		reset: 	in std_logic; 
		enable: 	in std_logic;
		count: 	out std_logic_vector(N-1 downto 0) 
	);
	end component;
	
	component Parity_Bit_Generator is
	port(
		d_in: 				in std_logic;
		tick:					in std_logic;
		reset:				in std_logic;
		preset:				in std_logic;
		enable:				in std_logic;
		even_p: 				out std_logic
	);
	end component;
	
	component MUX_2_1 is
		port( SEL: in std_logic;
		A, B: in std_logic;
		Y: out std_logic
		);
	end component;
	
	component Tick_Counter is
	generic(
		N : integer:= 16
	);
	port(
		clock: 	in std_logic;
		preset:	in std_logic;
		enable:	in std_logic;
		tick:		out std_logic;
		m_tick:	out std_logic
	);
	end component;
	
begin
	
	U1: START_MANAGEMENT
		port map(
			CLOCK_MNG0=>CLK,
			CLOCK_MNG1=>TICK,
			CTS_MNG=>CTS,
			START_MNG=>START,
			RESET_START=>L_RESET_START,
			RST_MNG=>RESET_START_MNG,--Da far resettare al finire ff
			FF_OUT_START=>WORKING,
			LOAD_CONTROL=>LOAD_CONTROLLER
		);
		
	
	U2: PISO
	generic map(N=>thisN)
		port map(
			CLK=>TICK,--Cambiare con clock lento
			RESET=>'0',
			PRESET=>PRESET_PISO,
			ENABLE=>ENABLE_PISO,
			Y=>ENTRY_A_MUX,
			XP(1 to thisN-2) => B_IN(0 to 6),
			XP(0) => STOP_BIT,
			XP(thisN-1) => START_BIT,
			LOAD=>LOAD_CONTROLLER
		);
	
		STOP_BIT<='1';
		START_BIT<='0';
	
		ENABLE_PISO<=WORKING;
		PRESET_PISO<='0' when WORKING='1' else
						'1';
		
		U3: Bit_Counter
			generic map(
				N=>4
			)
			port map(
				tick=>TICK,
				reset=>BIT_COUNTER_RST,
				enable=>BIT_COUNTER_ENABLE,
				count=>BIT_COUNTER_OUT
			);
			
			BIT_COUNTER_ENABLE<=WORKING;
			
			FINISHED<='1' when BIT_COUNTER_OUT(3)='1' and BIT_COUNTER_OUT(2)='0' and BIT_COUNTER_OUT(1)='0' and BIT_COUNTER_OUT(0)='1' else
						 '0';--se faccio 3 downo to 0 sarebbe standard
			
			RESET_START_MNG<= '1' when FINISHED='1' and RESET_ALL_TX='0' else
									'1' when FINISHED='0' and RESET_ALL_TX='1' else
									'1' when FINISHED='1' and RESET_ALL_TX='1' else		
									'0';
			
			L_RESET_START<='1' when RESET_ALL_TX='1' else
								'1' when CTS='0' and START='0' and WORKING='1' and FINISHED='1' else
								'1' when CTS='1' and START='0' and WORKING='1' and FINISHED='1' else
							   '1' when CTS='0' and START='1' and WORKING='1' and FINISHED='1' else
							   '0';
									
			BIT_COUNTER_RST<= '1' when LOAD_CONTROLLER='0' and RESET_ALL_TX='1' else
									'1' when LOAD_CONTROLLER='1' 							  else
									'1' when WORKING='0' and LOAD_CONTROLLER='0'      else
									'0';
		
		
		U4: MUX_2_1
			port map(
			A=>ENTRY_A_MUX,
			B=>ENTRI_B_MUX,
			SEL =>SELECT_MUX,
			Y=>TX_OUT
			);
		
		SELECT_MUX<='1' when BIT_COUNTER_OUT(3)='0' and BIT_COUNTER_OUT(2)='0' and BIT_COUNTER_OUT(1)='0' and BIT_COUNTER_OUT(0)='1' else
						 '0';
		
		U5: Parity_Bit_Generator
			port map(
			d_in=>ENTRY_A_MUX,
			tick=>TICK,
			reset=> RESET_PARITY_BIT_GEN,
			preset=>PRESET_PARITY_BIT_GEN,
			enable=>ENABLE_PARITY_BIT_GEN,
			even_p=>ENTRI_B_MUX
			);
									
		RESET_PARITY_BIT_GEN<='1' when LOAD_CONTROLLER='1' else
									 '0';
		
		ENABLE_PARITY_BIT_GEN<=WORKING;
		
		U6:Tick_Counter
			port map(
			clock=>CLK,
			tick=> TICK,
			preset=>PRESET_JOHNSON,
			enable=>ENABLE_JOHNSON
			);
			
			ENABLE_JOHNSON<=WORKING;
			PRESET_JOHNSON<='0' when WORKING='1' else
								 '1';
		AVAILABLE<=CTS;	

end rtl;
