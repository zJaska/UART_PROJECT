LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY UART_TB IS
END UART_TB;
 
ARCHITECTURE behavior OF UART_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART
    PORT(
         UART_RESET_ALL_TX : IN  std_logic;
			UART_RESET_ALL_RX : IN std_logic;
         UART_CLK : IN  std_logic;
         UART_START : IN  std_logic;
         UART_CTS : IN  std_logic;
         UART_B_IN : IN  std_logic_vector(0 to 6);
         UART_AVAILABLE : OUT  std_logic;
         UART_TX_OUT : OUT  std_logic;
			
         UART_RX_IN : IN  std_logic;
         UART_STOP_RX_IN : IN  std_logic;
         UART_DATA_OUT : OUT  std_logic_vector(6 downto 0);
         UART_RTS_OUT : OUT  std_logic;
         UART_END_ERR_OUT : OUT  std_logic;
         UART_PAR_ERR_OUT : OUT  std_logic;
         UART_READY_OUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal L_UART_RESET_ALL_TX : std_logic;
	signal L_UART_RESET_ALL_RX : std_logic;
   signal L_UART_CLK : std_logic;
   signal L_UART_START : std_logic;
   signal L_UART_B_IN : std_logic_vector(0 to 6);
   signal L_UART_RX : std_logic;
   signal L_UART_STOP_RX_IN : std_logic;

 	--Outputs
   signal L_UART_AVAILABLE : std_logic;
   signal L_UART_DATA_OUT : std_logic_vector(6 downto 0);
   signal L_UART_RTS : std_logic;
   signal L_UART_END_ERR_OUT : std_logic;
   signal L_UART_PAR_ERR_OUT : std_logic;
   signal L_UART_READY_OUT : std_logic;	

   -- Clock period definitions
   constant UART_CLK_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART PORT MAP (
          UART_RESET_ALL_TX => L_UART_RESET_ALL_TX,
			 UART_RESET_ALL_RX => L_UART_RESET_ALL_RX,
          UART_CLK => L_UART_CLK,
          UART_START => L_UART_START,
          UART_CTS => L_UART_RTS,
          UART_B_IN => L_UART_B_IN,
          UART_AVAILABLE => L_UART_AVAILABLE,
          UART_TX_OUT => L_UART_RX,
          UART_RX_IN => L_UART_RX,
          UART_STOP_RX_IN => L_UART_STOP_RX_IN,
          UART_DATA_OUT => L_UART_DATA_OUT,
          UART_RTS_OUT => L_UART_RTS,
          UART_END_ERR_OUT => L_UART_END_ERR_OUT,
          UART_PAR_ERR_OUT => L_UART_PAR_ERR_OUT,
          UART_READY_OUT => L_UART_READY_OUT
        );

   -- Clock process definitions
   UART_CLK_process :process
   begin
		L_UART_CLK <= '0';
		wait for UART_CLK_period/2;
		L_UART_CLK <= '1';
		wait for UART_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	

      wait for 100 ns;
		L_UART_RESET_ALL_TX <= '1';
		L_UART_RESET_ALL_RX <= '1';
		L_UART_STOP_RX_IN <= '0';
		L_UART_START <= '0';
      wait for UART_CLK_period*10;
		
		L_UART_RESET_ALL_TX <= '0';
		L_UART_RESET_ALL_RX <= '0';
		L_UART_B_IN <= "1100100";
		L_UART_START <= '1';
		
		wait for UART_CLK_period*16*10;
		
		L_UART_B_IN <= "1011100";
		
		wait for UART_CLK_period*16*2;
		
		L_UART_STOP_RX_IN <= '1';
		
		wait for UART_CLK_period*16*15;
		
		L_UART_STOP_RX_IN <= '0';
		
		L_UART_B_IN <= "1010100";
		
		wait for UART_CLK_period*16*1;
		
		L_UART_START <= '0';
		
		wait for UART_CLK_period*16*9;
		
		L_UART_B_IN <= "1010110";
		L_UART_START <= '1';
		
		wait for UART_CLK_period*8;
		
		L_UART_START <= '0';
		
		wait for UART_CLK_period*8;
		
		wait for UART_CLK_period*16*9;
		
		L_UART_B_IN <= "0010110";
		L_UART_START <= '1';
		
		wait for UART_CLK_period*16*10;
		
		L_UART_B_IN <= "1010111";
		
		wait for UART_CLK_period*16*10;
		
		L_UART_B_IN <= "1010110";
		
		wait for UART_CLK_period*16*10;
		
		L_UART_B_IN <= "0101111";
		
		wait for UART_CLK_period*16;
		
		L_UART_START <= '0';
		
      wait;
   end process;

END;
