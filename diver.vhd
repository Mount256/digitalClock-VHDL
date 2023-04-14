LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 分频器

entity diver is
	port(
		clk:	in std_logic;	-- 原始时钟频率
		clk0:	out std_logic;	-- 分频0
		clk1:	out std_logic	-- 分频1
	);
	end diver;
 
architecture a of diver is
	signal m_clk0: std_logic;
	signal m_clk1: std_logic;
	constant c_cnt_0: integer:= 3;
	constant c_cnt_1: integer:= 1;
begin
	clk0 <= m_clk0;
	clk1 <= m_clk1;
	process(clk)
		variable cnt_0: integer range 0 to c_cnt_0;	-- 分频
		variable cnt_1: integer range 0 to c_cnt_1; 	-- 分频
	begin
		if (clk'event and clk = '1') then
			cnt_0:= cnt_0 + 1;
			cnt_1:= cnt_1 + 1;
			if (cnt_0 = c_cnt_0) then
				m_clk0 <= not m_clk0;
				cnt_0:= 0;
			end if;
			if (cnt_1 = c_cnt_1) then
				m_clk1 <= not m_clk1;
				cnt_1:= 0;
			end if;
		end if;
	end process;
end a;
