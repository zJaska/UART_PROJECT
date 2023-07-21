LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Bit_Counter_TB IS
	generic(
		MOD_COUNT : integer := 4
	);
END Bit_Counter_TB;
 
ARCHITECTURE behavior OF Bit_Counter_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	COMPONENT Bit_Counter
	generic(
		N : integer
	);
	PORT(
		tick : IN  std_logic;
		reset : IN  std_logic;
		enable : IN  std_logic;
		count : OUT  std_logic_vector(0 to N-1)
	);
	END COMPONENT;
    

   --Inputs
   signal L_tick : std_logic;
   signal L_reset : std_logic;
   signal L_enable : std_logic;

 	--Outputs
   signal L_count : std_logic_vector(0 to MOD_COUNT-1);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant tick_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: Bit_Counter 
	GENERIC MAP(
		N => MOD_COUNT
	)
	PORT MAP (
		tick => L_tick,
		reset => L_reset,
		enable => L_enable,
		count => L_count
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
      wait for tick_period*2;
		
		L_enable <= '1';
		L_reset <= '1';
		wait for 10 ns;
		L_reset <= '0';
		
		wait for tick_period*16;
		
		L_reset <= '1';		
		wait for 10 ns;		
		L_reset <= '0';
		
		wait for tick_period*3;
		L_enable <= '0';
		
      wait;
   end process;

END;
