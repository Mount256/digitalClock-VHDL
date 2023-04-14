LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 时计时器

entity count_hour is
	port(
		clk, rst, en: in std_logic;				
		q0, q1: buffer std_logic_vector(3 downto 0); 
		cout: out std_logic
	);
end count_hour;

architecture a of count_hour is
	signal m_clk: std_logic;
	signal num0, num1: std_logic_vector(3 downto 0);
begin
	cout <= '1' when (num0 = "0011" and num1 = "0010" and en = '1') else '0';
	process (rst, clk)
	begin
		m_clk <= clk;
		if (rst = '1') then
			num0 <= "0000";
			num1 <= "0000";
		elsif (m_clk'event and m_clk = '0') then
			if (en = '1') then
				if (num0 = "0011") then
					num0 <= "0000";
					if (num1 = "0010") then
						num1 <= "0000";
					else
						num1 <= num1 + 1;
					end if;
				else
					num0 <= num0 + 1;
				end if;
			end if;
		end if;
	end process;
	q0 <= num0;
	q1 <= num1;
end a;
		
