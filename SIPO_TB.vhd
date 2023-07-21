LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY SIPO_TB IS
	GENERIC(
		WIDTH: integer := 4
	);
END SIPO_TB;
 
ARCHITECTURE behavior OF SIPO_TB IS 
 
    COMPONENT SIPO
	 GENERIC(
			N: integer
	 );
    PORT(
         tick : IN  std_logic;
         rx : IN  std_logic;
         enable : IN  std_logic;
         reset : IN  std_logic;
         B_OUT : OUT  std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal L_tick : std_logic;
   signal L_rx : std_logic;
   signal L_enable : std_logic;
   signal L_reset : std_logic;

 	--Outputs
   signal L_B_OUT : std_logic_vector(WIDTH-1 downto 0);
 
   constant tick_period : time := 1000 ms / 9600;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   UUT: SIPO 
	GENERIC MAP(
		N => WIDTH
	)
	PORT MAP (
		tick => L_tick,
		rx => L_rx,
		enable => L_enable,
		reset => L_reset,
		B_OUT => L_B_OUT
	);

   -- Clock process definitions
   tick_process :process
   begin
		L_tick <= '0';
		wait for tick_period/2;
		L_tick <= '1';
		wait for tick_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
	
      wait for tick_period;
		L_reset <= '1';
		L_enable <= '0';
		
		L_reset <= '0';
		
		wait for tick_period/2;
		L_rx  <= '1';
		
		wait for tick_period;
		L_rx  <= '1';
		
		wait for tick_period/8;
		L_enable <= '1';
		
		wait for 7*tick_period/8;
		L_rx  <= '1';
		
		wait for tick_period;
		L_rx  <= '1';
		
		wait for tick_period;
		L_rx  <= '0';
		
		wait for tick_period;
		L_rx  <= '1';
		
		wait for tick_period/8;
		L_enable <= '0';
		
		
		wait for 2*tick_period;
		L_reset <= '1';
		
      wait;
   end process;

END;
