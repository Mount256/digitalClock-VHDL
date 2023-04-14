LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity switch is
	port(
		key, s: in std_logic;
		s1, s2: out std_logic
	);
end switch;

architecture a of switch is
begin
	s1 <= key and (not s);
	s2 <= key and s;
end a;

