library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ripple_Carry_Adder is
	generic (
		N : integer
	);
	port (
		OP: 			in std_logic;
		A: 			in std_logic_vector(N-1 downto 0);
		B: 			in std_logic_vector(N-1 downto 0);
		S: 			out std_logic_vector(N downto 0)
	);
end Ripple_Carry_Adder;

architecture rtl of Ripple_Carry_Adder is
	component Full_Adder is
		port (
			A: 		in std_logic;
			B: 		in std_logic;
			Cin: 		in std_logic;
			S: 		out std_logic;
			Cout: 	out std_logic
		);
	end component Full_Adder;

	signal T_CARRY : std_logic_vector(N downto 0);
	signal T_SUM   : std_logic_vector(N-1 downto 0);
	signal T_B		: std_logic_vector(N-1 downto 0);
	signal T_OP		: std_logic_vector(N-1 downto 0);
begin
	T_CARRY(0) <= OP;
   T_OP<= (others => OP);
	T_B <= B xor T_OP;
	SET_WIDTH : for ii in 0 to N-1 generate
		FULL_ADDER_INST : Full_Adder
		port map (
			A  => A(ii),
			B  => T_B(ii),
			Cin => T_CARRY(ii),
			S   => T_SUM(ii),
			Cout => T_CARRY(ii+1)
		);
	end generate SET_WIDTH;

	S <= T_CARRY(N) & T_SUM;  -- VHDL Concatenation

end rtl;

