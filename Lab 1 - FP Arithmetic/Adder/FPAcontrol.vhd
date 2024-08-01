-- IEEE 16-bit Floating Point Adder Control Path
-- Written by: Louis Marleau
-- 05/16/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
	
ENTITY FPAcontrol IS
	PORT(g_clock, g_resetBar : IN STD_LOGIC;
		  a_Greater, b_Greater, equal : IN STD_LOGIC;
		  counterDone, normalizedDone : IN STD_LOGIC;
		  o_controlSignal : OUT STD_LOGIC_VECTOR(5 downto 0)
		  );
		  
END FPAcontrol;

ARCHITECTURE rtl OF FPAcontrol IS
	SIGNAL reset : STD_LOGIC;
	SIGNAL d, d_q, d_qBar : STD_LOGIC_VECTOR(5 downto 0);
	
COMPONENT enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC
		);
END COMPONENT;

BEGIN
	reset <= not(g_resetBar);
	
S1: enARdFF_2
	PORT MAP(i_resetBar => reset,
				i_d => d(1),
				i_enable => '1',
				i_clock => g_clock,
				o_q => d_q(1),
				o_qBar => d_qBar(1)
				);
	
S2: enARdFF_2
	PORT MAP(i_resetBar => reset,
				i_d => d(2),
				i_enable => '1',
				i_clock => g_clock,
				o_q => d_q(2),
				o_qBar => d_qBar(2)
				);

S3: enARdFF_2
	PORT MAP(i_resetBar => reset,
				i_d => d(3),
				i_enable => '1',
				i_clock => g_clock,
				o_q => d_q(3),
				o_qBar => d_qBar(3)
				);
				
S4: enARdFF_2
	PORT MAP(i_resetBar => reset,
				i_d => d(4),
				i_enable => '1',
				i_clock => g_clock,
				o_q => d_q(4),
				o_qBar => d_qBar(4)
				);
				
S5: enARdFF_2
	PORT MAP(i_resetBar => reset,
				i_d => d(5),
				i_enable => '1',
				i_clock => g_clock,
				o_q => d_q(5),
				o_qBar => d_qBar(5)
				);
	
	d(5) <= d_q(4) or (d_q(5) and not(normalizedDone));
	d(4) <= (d_q(3) and counterDone) or (d_q(3) and equal);
	d(3) <= d_q(2) or (d_q(3) and not(counterDone) and not(equal));
	d(2) <= d_q(1); 
	d(1) <= not(d_q(0)) and (not(d_q(1)) and not(d_q(2)) and not(d_q(3)) and not(d_q(4)) and not(d_q(5)));
	d(0) <= '0';
	d_q(0) <= not(d_q(1)) and (d_q(5) and normalizedDone);
	
	-- control output (for debug purposes)
	o_controlSignal <= d_q;	
	
END rtl;