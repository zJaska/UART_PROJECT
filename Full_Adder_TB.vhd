LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Full_Adder_TB IS
END Full_Adder_TB;
 
ARCHITECTURE behavior OF Full_Adder_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Full_Adder
    PORT(
         A : IN  std_logic;
         B : IN  std_logic;
         Cin : IN  std_logic;
         S : OUT  std_logic;
         Cout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal L_A : std_logic;
   signal L_B : std_logic;
   signal L_Cin : std_logic;

 	--Outputs
   signal L_S : std_logic;
   signal L_Cout : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Full_Adder PORT MAP (
          A => L_A,
          B => L_B,
          Cin => L_Cin,
          S => L_S,
          Cout => L_Cout
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		L_Cin <= '0';
		
		L_A <= '1';
		L_B <= '0';
		
		wait for 20 ns;
		
		L_A <= '0';
		L_B <= '1';
		
		wait for 20 ns;
		
		L_A <= '0';
		L_B <= '0';
		
		wait for 20 ns;
		
		L_A <= '1';
		L_B <= '1';
		
		wait for 20 ns;
		
		L_Cin <= '1';
		
		L_A <= '1';
		L_B <= '0';
		
		wait for 20 ns;
		
		L_A <= '0';
		L_B <= '1';
		
		wait for 20 ns;
		
		L_A <= '0';
		L_B <= '0';
		
		wait for 20 ns;
		
		L_A <= '1';
		L_B <= '1';
		
		wait for 20 ns;
      wait;
   end process;

END;
