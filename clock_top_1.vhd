LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_top_1 is
	port(
		clk: in std_LOGIC;  --时钟源
		key_sec, key_min, key_hour: in std_LOGIC;  --校时设置/闹铃设置按键
		sec0, sec1: buffer std_logic_vector(3 downto 0); --显示时
		min0, min1: buffer std_logic_vector(3 downto 0); --显示分
		hour0, hour1: buffer std_logic_vector(3 downto 0); --显示秒
		key_shift: in std_LOGIC; --切换功能
		speak: out std_LOGIC --整点响铃/闹铃响铃
	);
end clock_top_1;


architecture cml of clock_top_1 is

component diver is --分频器
	port(
		clk:	in std_logic;	-- 原始时钟频率
		clk0:	out std_logic;	-- 分频（正常速度）
		clk1:	out std_logic	-- 分频（校时速度）
	);
end component diver;

component count_hour is --时计数器
	port(
		clk, rst, en: in std_logic;				
		q0, q1: buffer std_logic_vector(3 downto 0); 
		cout: out std_logic
	);
end component count_hour;

component count_min is --分计数器
	port(
		clk, rst, en: in std_logic;				
		q0, q1: buffer std_logic_vector(3 downto 0); 
		cout: out std_logic
	);
end component count_min;

component count_sec is --秒计数器
	port(
		clk, rst, en: in std_logic;				
		q0, q1: buffer std_logic_vector(3 downto 0); 
		cout: out std_logic
	);
end component count_sec;

component mux21a IS --二选一
	PORT ( a, b, s: IN  STD_LOGIC;
			y : OUT STD_LOGIC  );
END component mux21a;

component mmux21a IS --多路二选一
	PORT ( a, b: in std_LOGIC_vector (3 downto 0);
			s: IN  STD_LOGIC;
			y : OUT std_LOGIC_vector (3 downto 0)  
		);
END component mmux21a;

component baoshi is --整点检测
	port ( min0 ,min1 , sec0, sec1 :in std_logic_vector ( 3 downto 0 );
			speak: out std_logic );
end component baoshi;

component alarm is --闹铃检测
	port(
		--sec0, sec1: in std_logic_vector(3 downto 0); 
		min0, min1: in std_logic_vector(3 downto 0); 
		hour0, hour1: in std_logic_vector(3 downto 0); 
		--asec0, asec1: in std_logic_vector(3 downto 0); 
		amin0, amin1: in std_logic_vector(3 downto 0); 
		ahour0, ahour1: in std_logic_vector(3 downto 0); 
		speak: out std_logic
	);
end component alarm;

component switch is --模式切换
	port(
		key, s: in std_logic;
		s1, s2: out std_logic
	);
end component switch;

component trigger IS
	port (t, clk: in std_logic;
			q: out std_logic);
end component;

signal sec_cout, min_cout: std_LOGIC;
signal normal_clk, fast_clk : std_LOGIC;
signal min_clk, hour_clk : std_LOGIC;
signal sec0_n, sec1_n, min0_n, min1_n, hour0_n, hour1_n: std_logic_vector(3 downto 0);
signal sec0_a, sec1_a, min0_a, min1_a, hour0_a, hour1_a: std_logic_vector(3 downto 0);
signal key_sec_n, key_min_n, key_hour_n: std_LOGIC;
signal key_sec_a, key_min_a, key_hour_a: std_LOGIC;
signal key_shift1: std_LOGIC;
signal speak_a, speak_zd: std_LOGIC;

begin 
	--------分频---------
	U1: diver port map (clk=>clk, clk0=>normal_clk, clk1=>fast_clk);
	--------时间计数器和显示---------
	U2: count_sec port map (clk=>normal_clk, rst=>key_sec_n, en=>'1', q0=>sec0_n, q1=>sec1_n, cout=>sec_cout);
	U3: count_min port map (clk=>min_clk, rst=>'0', en=>'1', q0=>min0_n, q1=>min1_n, cout=>min_cout);
	U4: count_hour port map (clk=>hour_clk, rst=>'0', en=>'1', q0=>hour0_n, q1=>hour1_n);
	--------校时---------
	U5: mux21a port map (a=>sec_cout, b=>fast_clk, s=>key_min_n, y=>min_clk);
	U6: mux21a port map (a=>min_cout, b=>fast_clk, s=>key_hour_n, y=>hour_clk);
	--------报时---------
	U7: baoshi port map (min0=>min0, min1=>min1, sec0=>sec0, sec1=>sec1, speak=>speak_zd);
	--------模式切换（三按键复用）---------
	U8: switch port map (key=>key_sec, s=>key_shift1, s1=>key_sec_n, s2=>key_sec_a);
	U9: switch port map (key=>key_min, s=>key_shift1, s1=>key_min_n, s2=>key_min_a);
	U10: switch port map (key=>key_hour, s=>key_shift1, s1=>key_hour_n, s2=>key_hour_a);
	--------数码管显示切换（二选一）---------
	U11: mmux21a port map (s=>key_shift1, a=>sec0_n, b=>sec0_a, y=>sec0);
	U12: mmux21a port map (s=>key_shift1, a=>sec1_n, b=>sec1_a, y=>sec1);
	U13: mmux21a port map (s=>key_shift1, a=>min0_n, b=>min0_a, y=>min0);
	U14: mmux21a port map (s=>key_shift1, a=>min1_n, b=>min1_a, y=>min1);
	U15: mmux21a port map (s=>key_shift1, a=>hour0_n, b=>hour0_a, y=>hour0);
	U16: mmux21a port map (s=>key_shift1, a=>hour1_n, b=>hour1_a, y=>hour1);
	--------闹钟计数器和显示---------
	U17: count_sec port map (clk=>fast_clk, rst=>'0', en=>key_sec_a, q0=>sec0_a, q1=>sec1_a);
	U18: count_min port map (clk=>fast_clk, rst=>'0', en=>key_min_a, q0=>min0_a, q1=>min1_a);
	U19: count_hour port map (clk=>fast_clk, rst=>'0', en=>key_hour_a, q0=>hour0_a, q1=>hour1_a);
	--------闹铃---------
	U20: alarm port map (min0=>min0_n, min1=>min1_n, hour0=>hour0_n, hour1=>hour1_n,
								amin0=>min0_a, amin1=>min1_a, ahour0=>hour0_a, ahour1=>hour1_a,
								speak=>speak_a );
	--------模式状态保持--------
	U21: trigger port map (clk=>clk, t=>key_shift, q=>key_shift1);
	--------扬声器--------
	speak <= speak_a or speak_zd;
	
end architecture cml;
