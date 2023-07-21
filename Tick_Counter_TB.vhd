LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Tick_Counter_TB IS
	GENERIC(
		MOD_COUNT: integer:= 16
	);
END Tick_Counter_TB;
 
ARCHITECTURE behavior OF Tick_Counter_TB IS 

	COMPONENT Tick_Counter
		GENERIC(
			N: integer
		);	
		PORT(
			clock : IN  std_logic;
			preset : IN  std_logic;
			enable : IN std_logic;
			tick : OUT  std_logic;
			m_tick : OUT  std_logic;
			qtr_1_tick:	out std_logic;
			qtr_3_tick:	out std_logic
			);
		END COMPONENT;
    

   --Inputs
   signal L_clock : std_logic;
   signal L_preset : std_logic;
	signal L_enable : std_logic;

 	--Outputs
   signal L_tick : std_logic;
   signal L_m_tick : std_logic;
	signal L_qtr_1_tick: std_logic;
	signal L_qtr_3_tick: std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Tick_Counter
	GENERIC MAP(
		N => MOD_COUNT
	)
	PORT MAP (
		clock => L_clock,
		preset => L_preset,
		tick => L_tick,
		enable => L_enable,
		m_tick => L_m_tick,
		qtr_1_tick => L_qtr_1_tick,
		qtr_3_tick => L_qtr_3_tick
   );

   -- Clock process definitions
   clock_process :process
   begin
		L_clock <= '0';
		wait for clock_period/2;
		L_clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		L_enable <= '1';
      wait for clock_period*2;

		L_preset <= '1';		
		wait for 1 ns;		
		L_preset <= '0';
		
		wait for clock_period*18;
		
		L_preset <= '1';		
		wait for 1 ns;		
		L_preset <= '0';
		
      wait for clock_period*2;
		L_enable <= '0';

      wait;
   end process;

END;
