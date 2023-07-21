LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Receiver_TB IS
END Receiver_TB;
 
ARCHITECTURE behavior OF Receiver_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Receiver
    PORT(
			RESET_RECEIV: IN std_logic;
         CLOCK : IN  std_logic;
         RX_IN : IN  std_logic;
         STOP_RX_IN : IN  std_logic;
         DATA_OUT : OUT  std_logic_vector(6 downto 0);
         RTS_OUT : OUT  std_logic;
         END_ERR_OUT : OUT  std_logic;
         PAR_ERR_OUT : OUT  std_logic;
         READY_OUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
	signal L_RESET_RECEIV : std_logic;
   signal L_CLOCK : std_logic;
   signal L_RX_IN : std_logic;
   signal L_STOP_RX_IN : std_logic;

 	--Outputs
   signal L_DATA_OUT : std_logic_vector(6 downto 0);
   signal L_RTS_OUT : std_logic;
   signal L_END_ERR_OUT : std_logic;
   signal L_PAR_ERR_OUT : std_logic;
   signal L_READY_OUT : std_logic;

   -- Clock period definitions
	constant Tick_period : time := 320 ns;
   constant CLOCK_period : time := Tick_period/16;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Receiver PORT MAP (
			 RESET_RECEIV => L_RESET_RECEIV,
          CLOCK => L_CLOCK,
          RX_IN => L_RX_IN,
          STOP_RX_IN => L_STOP_RX_IN,
          DATA_OUT => L_DATA_OUT,
          RTS_OUT => L_RTS_OUT,
          END_ERR_OUT => L_END_ERR_OUT,
          PAR_ERR_OUT => L_PAR_ERR_OUT,
          READY_OUT => L_READY_OUT
        );

   -- Clock process definitions
   CLOCK_process :process
   begin
		L_CLOCK <= '0';
		wait for CLOCK_period/2;
		L_CLOCK <= '1';
		wait for CLOCK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
      wait for 100 ns;
		L_RESET_RECEIV <= '1';
		wait for 100 ns;
		
		L_RESET_RECEIV <= '0';		
		L_STOP_RX_IN <= '0';
		L_RX_IN <= '1';
      wait for Tick_period*2;
		
		
		-- Start bit = 0, D_IN = "0010101", Parity bit = 1, stop bit = 1
		
		L_RX_IN <= '0'; --start bit (320ns)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(6)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(5)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(4)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(3)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(2)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(1)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(0)
      wait for Tick_period;
		L_RX_IN <= '1'; --parity bit
      wait for Tick_period;
		L_RX_IN <= '1'; --stop bit
      wait for Tick_period*3;
		
		
		-- Start bit = 0, D_IN = "1100100", Parity bit = 0(ERR), stop bit = 1
		
		L_RX_IN <= '0'; --start bit (2240ns)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(6)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(5)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(4)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(3)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(2)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(1)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(0)
      wait for Tick_period;
		L_RX_IN <= '0'; --parity bit
      wait for Tick_period;
		L_RX_IN <= '1'; --stop bit
      wait for Tick_period*3;

		-- Start bit = 0, D_IN = "1010110", Parity bit = 0, stop bit = 1
		-- stop_rx=1 dopo 2 tick period
		
		L_RX_IN <= '0'; --start bit (4160ns)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(6)
      wait for Tick_period;
		L_STOP_RX_IN <= '1';
		L_RX_IN <= '0'; --D_IN(5)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(4)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(3)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(2)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(1)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(0)
      wait for Tick_period;
		L_RX_IN <= '0'; --parity bit
      wait for Tick_period;
		L_RX_IN <= '1'; --stop bit
      wait for Tick_period*6;
		L_STOP_RX_IN <= '0';
      wait for Tick_period;

		
		-- Start bit = 0, D_IN = "1100100", Parity bit = 1, stop bit = 0 (ERR)
		
		L_RX_IN <= '0'; --start bit (6080ns)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(6)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(5)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(4)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(3)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(2)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(1)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(0)
      wait for Tick_period;
		L_RX_IN <= '1'; --parity bit
      wait for Tick_period;
		L_RX_IN <= '0'; --stop bit
      wait for Tick_period;
		
		
		-- Start bit = 0, D_IN = "1101110", Parity bit = 1, stop bit = 1 (ERR)
		
		L_RX_IN <= '0'; --start bit (6080ns)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(6)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(5)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(4)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(3)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(2)
      wait for Tick_period;
		L_RX_IN <= '1'; --D_IN(1)
      wait for Tick_period;
		L_RX_IN <= '0'; --D_IN(0)
      wait for Tick_period;
		L_RX_IN <= '1'; --parity bit
      wait for Tick_period;
		L_RX_IN <= '1'; --stop bit
      wait for Tick_period;
		
      wait;
   end process;

END;
