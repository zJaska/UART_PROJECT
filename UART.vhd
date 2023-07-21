library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity UART is
	port(
			UART_RESET_ALL_TX:in std_logic;
			UART_RESET_ALL_RX:in std_logic;
			UART_CLK: in std_logic;
			UART_START: in std_logic;
			UART_CTS: in std_logic;
			UART_B_IN: in std_logic_vector(0 to 6);
			UART_AVAILABLE:out std_logic;
			
			UART_TX_OUT: out std_logic;
			UART_RX_IN:			in std_logic;
			UART_STOP_RX_IN:		in std_logic;
			UART_DATA_OUT:		out std_logic_vector(6 downto 0);
			UART_RTS_OUT:			out std_logic;
			UART_END_ERR_OUT:	out std_logic;
			UART_PAR_ERR_OUT:	out std_logic;
			UART_READY_OUT:		out std_logic
			
			);
	
end UART;

architecture STRUCT of UART is

	component Transmitter_TX is
		port(
			RESET_ALL_TX:in std_logic;
			CLK: in std_logic;
			START: in std_logic;
			CTS: in std_logic;
			B_IN: in std_logic_vector(0 to 6);--osservare
			AVAILABLE:out std_logic;
			TX_OUT: out std_logic);
	end component;

	component Receiver is
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
	end component;
begin
	
	U1: Transmitter_TX
		port map(
			RESET_ALL_TX=>UART_RESET_ALL_TX,
			CLK=>UART_CLK,
			START=>UART_START,
			CTS=>UART_CTS,
			B_IN=>UART_B_IN,
			AVAILABLE=>UART_AVAILABLE,
			TX_OUT=>UART_TX_OUT
		);
	
	U2: Receiver
		port map(
		RESET_RECEIV=>UART_RESET_ALL_RX,
		CLOCK=>UART_CLK,
		RX_IN=>UART_RX_IN,
		STOP_RX_IN=>UART_STOP_RX_IN,
		DATA_OUT=>UART_DATA_OUT,
		RTS_OUT=>UART_RTS_OUT,
		END_ERR_OUT=>UART_END_ERR_OUT,
		PAR_ERR_OUT=>UART_PAR_ERR_OUT,
		READY_OUT=>UART_READY_OUT
		);


end STRUCT;

