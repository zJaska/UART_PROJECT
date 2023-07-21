library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Full_Adder is
	port (
		A: 		in std_logic;
		B: 		in std_logic;
		Cin: 		in std_logic;
		S: 		out std_logic;
		Cout: 	out std_logic
	);
end Full_Adder;

architecture Gates of Full_Adder is

begin
	S <= A xor B xor Cin ;
	Cout <= (A and B) or (Cin and A) or (Cin and B) ;

end Gates;

