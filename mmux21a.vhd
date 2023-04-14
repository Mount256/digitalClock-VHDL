LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mmux21a IS
	PORT ( a, b: in std_LOGIC_vector (3 downto 0);
			s: IN  STD_LOGIC;
			y : OUT std_LOGIC_vector (3 downto 0)  
		);
END ENTITY mmux21a;

ARCHITECTURE one OF mmux21a IS
BEGIN
	PROCESS (a,b,s)
	BEGIN
		IF s = '0'  THEN  y <= a ; ELSE y <= b ;
		END IF;
	END PROCESS;
END ARCHITECTURE one ;
