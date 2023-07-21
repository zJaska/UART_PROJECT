LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY TB_PISO IS
	GENERIC (WIDTH : INTEGER :=10);
END TB_PISO;
 
ARCHITECTURE behavior OF TB_PISO IS 

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PISO
	 GENERIC ( N: integer);
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         LOAD : IN  std_logic;
         PRESET : IN  std_logic;
			ENABLE : IN  std_logic;
         XP: in std_logic_vector(0 to N-1);
         Y : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal L_CLK : std_logic;
   signal L_RESET : std_logic;
   signal L_LOAD : std_logic;
   signal L_PRESET : std_logic;
	signal L_ENABLE : std_logic;
   signal L_XP: std_logic_vector(0 to WIDTH-1);

 	--Outputs
   signal L_Y : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   UUT: PISO 
			GENERIC MAP(
			N => WIDTH
			)
			PORT MAP(
          CLK => L_CLK,
          RESET => L_RESET,
          LOAD => L_LOAD,
			 ENABLE => L_ENABLE,
          PRESET => L_PRESET,
          XP => L_XP,
          Y => L_Y
        );

   -- Clock process definitions
   CLK_process :process
   begin
		L_CLK <= '0';
		wait for CLK_period/2;
		L_CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process comportamento non sintetizzabile e in sequenza 
   inputs: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;	
		L_ENABLE<='1';
		L_XP<="1111100000";
		L_LOAD<='1';
		wait for CLK_period;
		
		L_LOAD<='0';
		
		
		wait for 10*CLK_period;
		
		L_PRESET <= '1';
		
		wait for CLK_period;
		
		L_PRESET<='0';
		
		wait for CLK_period;
		
		L_RESET <='1';

		wait for CLK_period;
		
		L_RESET <='0';
		
		wait for CLK_period;

		L_XP<="1000000000";
		L_LOAD<='1';
		
		wait for CLK_period;
		
		L_LOAD<='0';
		
		wait for CLK_period;
		
		wait for 10*CLK_period;
		
      
		-- insert stimulus here 

      wait;
   end process;

END;
