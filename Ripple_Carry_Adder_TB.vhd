LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Ripple_Carry_Adder_TB IS
	GENERIC(
		WIDTH: integer:= 4
	);
END Ripple_Carry_Adder_TB;
 
ARCHITECTURE behavior OF Ripple_Carry_Adder_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Ripple_Carry_Adder
		GENERIC(
			N: integer
		);
		PORT(
			OP: IN std_logic;
			A : IN  std_logic_vector(N-1 downto 0);
			B : IN  std_logic_vector(N-1 downto 0);
			S : OUT  std_logic_vector(N downto 0)
		);
    END COMPONENT;
    

   --Inputs
   signal L_OP : std_logic;
   signal L_A  : std_logic_vector(WIDTH-1 downto 0);
   signal L_B  : std_logic_vector(WIDTH-1 downto 0);

 	--Outputs
   signal L_S : std_logic_vector(WIDTH downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Ripple_Carry_Adder 
		GENERIC MAP(
			N => WIDTH
		)
		PORT MAP (
			OP => L_OP,
			A => L_A,
			B => L_B,
			S => L_S
		); 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		L_OP <= '0'; -- add
		
		L_A <= "0001";
		L_B <= "0101";
		
		wait for 20 ns;
		
		L_A <= "1011";
		L_B <= "0101";
		
		wait for 20 ns;
		
		L_OP <= '1'; -- sub (7-5=2)
		L_A <= "1011"; -- 7
		L_B <= "0101"; -- 5
		
		wait for 20 ns;
		
		L_OP <= '1'; -- sub (3-7=-4)
		L_A <= "0011"; -- 3
		L_B <= "0111"; -- 7
		
      wait;
   end process;

END;
