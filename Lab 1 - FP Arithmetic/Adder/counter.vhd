LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter IS
	PORT(
		i_rst, i_load	: IN	STD_LOGIC;
		i_enabled 		: IN STD_LOGIC;
		i_up				: IN STD_LOGIC;
		input 			: in std_LOGIC_VECTOR(6 downto 0);
		g_clock			: IN	STD_LOGIC;
		o_expired 		: out std_logic;
		o_Value			: OUT	STD_LOGIC_VECTOR(6 downto 0));
END counter;

ARCHITECTURE rtl OF counter IS
	SIGNAL int_a, int_na, int_b, int_nb, int_c, int_nc, int_d, int_nd : STD_LOGIC;
	SIGNAL int_1, int_n1, int_2, int_n2, int_3, int_n3, int_4, int_n4 : STD_LOGIC;
	SIGNAL int_n1_up, int_n2_up, int_n3_up, int_n4_up : STD_LOGIC;
	SIGNAL int_na_up, int_nb_up, int_nc_up, int_nd_up : STD_LOGIC;
	SIGNAL int_not1, int_not2, int_not3, int_not4, int_notA, int_notB, int_notc, int_notd, enabled : STD_LOGIC;
	SIGNAL d_in, int_next, int_next_up, int_next_down : std_logic_vector(6 downto 0);

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

	-- Concurrent Signal Assignment
	-- Count down
	int_n2 <= int_2 xor (not(int_3 or int_4 or int_a or int_b or int_c or int_d));
	int_n3 <= int_3 xor (not(int_4 or int_a or int_b or int_c or int_d));
	int_n4 <= int_4 xor (not(int_a or int_b or int_c or int_d));
	int_na <= int_a xor (not(int_b or int_c or int_d));
	int_nb <= int_b xor (not(int_c or int_d));
	int_nc <= int_c xor not(int_d);
	int_nd <= not(int_d);
	int_next_down <= int_n2 & int_n3 & int_n4 & int_na & int_nb & int_nc & int_nd;
	
	-- Count up 
	int_n2_up <= int_2 xor (int_3 and int_4 and int_a and int_b and int_c and int_d);
	int_n3_up <= int_3 xor (int_4 and int_a and int_b and int_c and int_d);
	int_n4_up <= int_4 xor (int_a and int_b and int_c and int_d);
	int_na_up <= int_a xor (int_b and int_c and int_d);
	int_nb_up <= int_b xor (int_c and int_d);
	int_nc_up <= int_c xor int_d;
	int_nd_up <= not(int_d);
	int_next_up <= int_n2_up & int_n3_up & int_n4_up & int_na_up & int_nb_up & int_nc_up & int_nd_up;
	
	int_next <= int_next_down when (i_up = '0') else int_next_up when (i_up = '1');
	d_in <= int_next when (i_load = '0') else input when (i_load = '1');
	

msb: enARdFF_2
	PORT MAP (i_resetBar => i_rst,
			  i_d => d_in(6),
			  i_enable => enabled, 
			  i_clock => g_clock,
			  o_q => int_2,
	          o_qBar => int_not2);
				 
bit5: enARdFF_2
	PORT MAP (i_resetBar => i_rst,
			  i_d => d_in(5), 
			  i_enable => enabled,
			  i_clock => g_clock,
			  o_q => int_3,
	          o_qBar => int_not3);
				 
bit4: enARdFF_2
	PORT MAP (i_resetBar => i_rst,
			  i_d => d_in(4), 
			  i_enable => enabled,
			  i_clock => g_clock,
			  o_q => int_4,
	          o_qBar => int_not4);
				 
bit3: enARdFF_2
	PORT MAP (i_resetBar => i_rst,
			  i_d => d_in(3), 
			  i_enable => enabled,
			  i_clock => g_clock,
			  o_q => int_a,
	          o_qBar => int_notA);
				 
bit2: enARdFF_2
	PORT MAP (i_resetBar => i_rst,
			  i_d => d_in(2), 
			  i_enable => enabled,
			  i_clock => g_clock,
			  o_q => int_b,
	          o_qBar => int_notB);

bit1: enARdFF_2
	PORT MAP (i_resetBar => i_rst,
			  i_d => d_in(1), 
			  i_enable => enabled,
			  i_clock => g_clock,
			  o_q => int_c,
	          o_qBar => int_notc);

lsb: enARdFF_2
	PORT MAP (i_resetBar => i_rst,
			  i_d => d_in(0), 
			  i_enable => enabled,
			  i_clock => g_clock,
			  o_q => int_d,
	          o_qBar => int_notd);

	-- Output Driver
	enabled <= i_enabled;
	o_expired <= not(int_2 or int_3 or int_4 or int_a or int_b or int_c or int_d);
	o_Value <= int_2 & int_3 & int_4 & int_a & int_b & int_c & int_d;

END rtl;
