LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Transmitter_TX_TB IS
END Transmitter_TX_TB;
 
ARCHITECTURE behavior OF Transmitter_TX_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Transmitter_TX
    PORT(
         RESET_ALL_TX : IN  std_logic;
         CLK : IN  std_logic;
         START : IN  std_logic;
         CTS : IN  std_logic;
         B_IN : IN  std_logic_vector(6 downto 0);
         AVAILABLE:out std_logic;
			TX_OUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal L_RESET_ALL_TX : std_logic;
   signal L_CLK : std_logic;
   signal L_START : std_logic;
   signal L_CTS : std_logic;
   signal L_B_IN : std_logic_vector(6 downto 0);
	
	
	
 	--Outputs
   signal L_TX_OUT : std_logic;
	signal L_AVAILABLE:std_logic;
	--debug
	
   -- Clock period definitions
	constant Tick_period : time := 160 ns;
   constant CLK_period : time := Tick_period/16;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Transmitter_TX PORT MAP (
         --debug
			
			RESET_ALL_TX =>L_RESET_ALL_TX,
          CLK => L_CLK,
          START => L_START,
          CTS => L_CTS,
          B_IN => L_B_IN,
          TX_OUT => L_TX_OUT,
			 AVAILABLE=>L_AVAILABLE
			
        );

   -- Clock process definitions
   CLK_process :process
   begin
		L_CLK <= '0';
		wait for CLK_period/2;
		L_CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		L_RESET_ALL_TX<='1';
      -- hold reset state for 100 ns.
      wait for Tick_period;
		L_RESET_ALL_TX<='0';
 
		
      -- B_IN = '1110101', lascio start per 1 baudrate,
      -- la trasmissione funziona
		L_B_IN<="1110101";
		L_START<='1';
		L_CTS<='1';
		
		wait for Tick_period ;
		L_START<='0';
		wait for 9*Tick_period ;

      
      -- B_IN = '1010101', aspetto 1 baudrate
      -- e poi metto start a 1,
      -- dopo un baudrate cts a 0
      -- la trasmissione funziona da quando metto start 
      -- e da li in poi non trasmette più
		L_B_IN<="1010101";

		wait for Tick_period;
		L_START<='1';
		wait for Tick_period;
		
		L_CTS<='0';
		
		wait for 9*Tick_period;
		

      -- B_IN = '1110101', start già alto,
      -- aspetto 3 baudrate e poi cts=1,
      -- la trasmissione funziona
      -- da quando metto cts=1
		L_B_IN<="1110101";
		
		wait for 3*Tick_period;
		L_CTS<='1';		
		wait for 10*Tick_period;
		
      
      -- B_IN = '1010101', start già alto,
      -- aspetto 1 baudrate e poi start basso,
      -- la trasmissione funziona appena
      -- finisce quella precedente
		L_B_IN<="1010101";
		
		wait for Tick_period;
		
		L_START<='0';

      wait;
   end process;

END;
