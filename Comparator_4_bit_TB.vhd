LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Comparator_4_bit_TB IS
END Comparator_4_bit_TB;
 
ARCHITECTURE behavior OF Comparator_4_bit_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	COMPONENT Comparator_4_bit
		PORT(
			A : IN  std_logic_vector(3 downto 0);
			B : IN  std_logic_vector(3 downto 0);
			EQ : OUT  std_logic
		);
	END COMPONENT;
    

   --Inputs
   signal L_A : std_logic_vector(3 downto 0);
   signal L_B : std_logic_vector(3 downto 0);

 	--Outputs
   signal L_EQ : std_logic;
   signal L_A_GT_B : std_logic;
   signal L_A_LT_B : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Comparator_4_bit 
		PORT MAP (
			A => L_A,
			B => L_B,
			EQ => L_EQ,
			A_GT_B => L_A_GT_B,
			A_LT_B => L_A_LT_B
		);
		
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		
		L_A <= "0000";
		L_B <= "0010";
		
		wait for 20 ns;
		
		L_A <= "1010";
		L_B <= "1010";
		
		wait for 20 ns;
		
		L_A <= "1011";
		L_B <= "1010";
		
      wait;
   end process;

END;
