LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alarm is
	port(
		--sec0, sec1: in std_logic_vector(3 downto 0); 
		min0, min1: in std_logic_vector(3 downto 0); 
		hour0, hour1: in std_logic_vector(3 downto 0); 
		--asec0, asec1: in std_logic_vector(3 downto 0); 
		amin0, amin1: in std_logic_vector(3 downto 0); 
		ahour0, ahour1: in std_logic_vector(3 downto 0); 
		speak: out std_logic
	);
end alarm;

architecture a of alarm is
begin
	speak <= '1' when(min0=amin0 and min1=amin1 
						and hour0=ahour0 and hour1=ahour1)
		else '0';
end a;
		


