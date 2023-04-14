LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
Use IEEE.STD_LOGIC_ARITH.ALL;
Use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY trigger IS
	port (t, clk: in std_logic;
			q: out std_logic);
end entity;

architecture bhv of trigger is
	signal temp: std_logic;
begin
	process(clk, t)
	begin
		if clk'event and clk='1' then
			if t='1' then
				temp <= not temp;
			else 
				temp <= temp;
			end if;
		end if;
		q <= temp;
	end process;
end bhv;
