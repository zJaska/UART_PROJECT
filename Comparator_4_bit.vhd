library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Comparator_4_bit is
	port(
		A: 		in std_logic_vector(3 downto 0);
		B: 		in std_logic_vector(3 downto 0);
		EQ: 		out std_logic;
		A_GT_B:	out std_logic;
		A_LT_B:	out std_logic
	);
end Comparator_4_bit;

architecture Gates of Comparator_4_bit is
	signal T_S: std_logic_vector(5 downto 0);
	signal T_A: std_logic_vector(4 downto 0);
	signal T_B: std_logic_vector(4 downto 0);
	
	component Ripple_Carry_Adder is
		generic (
			N : integer
		);
		port (
			OP: 			in std_logic;
			A: 			in std_logic_vector(N-1 downto 0);
			B: 			in std_logic_vector(N-1 downto 0);
			S: 			out std_logic_vector(N downto 0)
		);
	end component;
begin
	T_A <= '0' & A;
	T_B <= '0' & B;

	U1: Ripple_Carry_Adder
		generic map(
			N => 5
		)
		port map(
			OP => '1',
			A => T_A,
			B => T_B,
			S => T_S
		);
	
	EQ <= not(T_S(0)) AND not(T_S(1)) AND not(T_S(2)) AND not(T_S(3)) AND not(T_S(4));
	A_GT_B <= not(T_S(4)) AND (T_S(0) or T_S(1) or T_S(2) or T_S(3));
	A_LT_B <= T_S(4);

end Gates;

