LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Parity_Bit_Generator_TB IS
END Parity_Bit_Generator_TB;
 
ARCHITECTURE behavior OF Parity_Bit_Generator_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Parity_Bit_Generator is
		port(
			d_in: 				in std_logic;
			tick:					in std_logic;
			reset:				in std_logic;
			preset:				in std_logic;
			enable:				in std_logic;
			even_p: 				out std_logic
		);
    END COMPONENT;
    

   --Inputs
   signal l_d_in : std_logic;
	signal l_tick: std_logic;
	signal l_reset: std_logic;
	signal l_preset: std_logic;
	signal l_enable: std_logic;

 	--Outputs
   signal l_even_p : std_logic;
	
	
   constant tick_period : time := 1000 ms/9600;
  
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Parity_Bit_Generator PORT MAP (
          d_in => l_d_in,
          even_p => l_even_p,
			 tick => l_tick,
			 reset => l_reset,
			 preset => l_preset,
			 enable => l_enable
        );

	-- Clock process definitions
   tick_process :process
   begin
		l_tick <= '0';
		wait for tick_period/2;
		l_tick <= '1';
		wait for tick_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin
		l_reset <= '1';
		l_preset <= '0';
		l_enable <= '0';
	
		wait for tick_period/2;
		l_reset <= '0';
		l_d_in  <= '1';
		
		wait for tick_period;
		l_d_in  <= '1';
		
		wait for tick_period/8;
		l_enable <= '1';
		
		wait for 7*tick_period/8;
		l_d_in  <= '1';
		
		wait for tick_period;
		l_d_in  <= '1';
		
		wait for tick_period;
		l_d_in  <= '0';
		
		wait for tick_period;
		l_d_in  <= '1';
		
		wait for 20 us;
		l_enable <= '0';
		
		wait for 20 us;
		l_reset <= '1';
		
		wait for 20 us;
		l_reset <= '0';
		
		wait for 20 us;
		l_preset <= '1';
		
		wait;
   end process;

END;
