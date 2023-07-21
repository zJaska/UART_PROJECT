library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Receiver is
	port(
		RESET_RECEIV:	in std_logic;
		CLOCK:			in std_logic;
		RX_IN:			in std_logic;
		STOP_RX_IN:		in std_logic;
		DATA_OUT:		out std_logic_vector(6 downto 0);
		RTS_OUT:			out std_logic;
		END_ERR_OUT:	out std_logic;
		PAR_ERR_OUT:	out std_logic;
		READY_OUT:		out std_logic
	);
end Receiver;

architecture rtl of Receiver is
	signal T_DATA: std_logic_vector(8 downto 0);
	signal M_TICK: std_logic;
	signal T_BIT_COUNT: std_logic_vector(3 downto 0);
	signal T_ENABLE_PAR: std_logic:='0';
	signal T_ENABLE_COMP: std_logic:='0';
	signal T_RESET: std_logic:='1';
	signal T_ERR_P_CHECK: std_logic:='0';
	signal T_8: std_logic_vector(3 downto 0);
	signal T_10: std_logic_vector(3 downto 0);
	signal T_LT_8: std_logic;
	signal T_EQ_10: std_logic;
	signal RST_ENABLE: std_logic;
	signal T_READY_TICK: std_logic;
	
	component Parity_Bit_Generator is
		port(
			tick:					in std_logic;
			reset:				in std_logic;
			preset:				in std_logic;
			enable:				in std_logic;
			d_in: 				in std_logic;
			even_p:				out std_logic
		);
	end component;
	
	component Tick_Counter is
		generic(
			N : integer
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
	
	component SIPO is
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
	end component;
	
	component Comparator_4_bit is
		port(
			A: 		in std_logic_vector(3 downto 0);
			B: 		in std_logic_vector(3 downto 0);
			EQ: 		out std_logic;
			A_GT_B:	out std_logic;
			A_LT_B:	out std_logic
		);
	end component;
	
	component JK_FF_LOW is
		port(
			CLK: 	in std_logic; 
			J: 	in std_logic; 
			K: 	in std_logic; 
			RST: 	in std_logic;
			Q: 	out std_logic;
			N_Q:	out std_logic
		);
	end component;
	
begin
	U1: Parity_Bit_Generator
		port map(
			tick => M_TICK,
			reset => T_RESET,
			preset => '0',
			enable => T_ENABLE_PAR,
			d_in => RX_IN,
			even_p => T_ERR_P_CHECK
		);
		
	U2: Tick_Counter
		generic map(
			N => 16
		)
		port map(
			clock => CLOCK,
			preset => T_RESET,
			enable => T_ENABLE_COMP,
			tick => open,
			qtr_1_tick => open,
			m_tick => M_TICK,
			qtr_3_tick => T_READY_TICK
		);
		
	U3: Bit_Counter
		generic map( 
			N => 4 
		)
		port map( 
			tick => M_TICK,
			reset => T_RESET,
			enable => T_ENABLE_COMP,
			count => T_BIT_COUNT 
		);
	
	U4: SIPO 
		generic map(
			N => 9
		)
		port map(
			tick => M_TICK,
			rx => RX_IN,
			enable => T_ENABLE_COMP,
			reset => T_RESET,
			B_OUT => T_DATA
		);
	
	U5: Comparator_4_bit
		port map(
			A => T_8,
			B => T_BIT_COUNT,
			EQ => open,
			A_GT_B => T_LT_8,
			A_LT_B => open
		);
		
	U6: Comparator_4_bit
		port map(
			A => T_10,
			B => T_BIT_COUNT,
			EQ => T_EQ_10,
			A_GT_B => open,
			A_LT_B => open
		);
		
	U7: JK_FF_LOW
		port map(
			CLK => CLOCK,
			J => RX_IN,
			K => RST_ENABLE,
			RST => RESET_RECEIV,
			Q => T_ENABLE_COMP,
			N_Q => T_RESET
		);
	
	T_8 <= "1000";
	
	T_10 <= "1010";
	
	RTS_OUT <= not(STOP_RX_IN);
		
	RST_ENABLE <= '0' when (T_EQ_10 = '1' and T_READY_TICK = '1') else
						'1';
						  
	T_ENABLE_PAR <= '1' when (T_ENABLE_COMP = '1' and T_LT_8 = '1') else
						 '0';

	DATA_OUT <= T_DATA(6 downto 0);
	
	END_ERR_OUT <= '1' when (T_DATA(8) = '0' and T_EQ_10 = '1') else
						'0';
						
	PAR_ERR_OUT <= '1' when (T_ERR_P_CHECK = '0' and T_DATA(7) = '1' and T_EQ_10 = '1') else
						'1' when (T_ERR_P_CHECK = '1' and T_DATA(7) = '0' and T_EQ_10 = '1') else
						'0';
						
	READY_OUT <= T_EQ_10;

end rtl;

