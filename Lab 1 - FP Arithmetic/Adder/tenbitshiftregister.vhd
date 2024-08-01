-- 10-bit shift register
-- Written by: Louis Marleau
-- 05/16/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tenbitShiftRegister IS
	PORT(
		i_resetBar, in_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_shiftLeft, i_shiftRight, i_loadLeft, i_loadRight : IN STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(9 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(9 downto 0));
END tenbitShiftRegister;

ARCHITECTURE rtl OF tenbitShiftRegister IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(9 downto 0);
	SIGNAL msbIn, bit8in, bit7in, bit6in, bit5in, bit4in, bit3in, bit2in, bit1in, lsbIn, i_load : STD_LOGIC;

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN
	
	i_load <= in_load;
	
	msbIn <= (((i_loadLeft AND i_shiftRight) OR 
			  (int_Value(8) AND i_shiftLeft) OR
			  (int_Value(9) AND NOT(i_shiftLeft or i_shiftRight))) and not in_load) or (i_Value(9) AND in_load);
	
	bit8in <= (((int_value(9) AND i_shiftRight) OR 
			  (int_Value(7) AND i_shiftLeft) OR 
			  (int_Value(8) AND NOT(i_shiftLeft or i_shiftRight))) and not in_load) or (i_Value(8) AND in_load);
			  
	bit7in <= (((int_value(8) AND i_shiftRight) OR 
			  (int_Value(6) AND i_shiftLeft) OR 
			  (int_Value(7) AND NOT(i_shiftLeft or i_shiftRight)))and not in_load) or (i_Value(7) AND in_load);
			  
	bit6in <= (((int_value(7) AND i_shiftRight) OR 
			  (int_Value(5) AND i_shiftLeft) OR 
			  (int_Value(6) AND NOT(i_shiftLeft or i_shiftRight)))and not in_load) or (i_Value(6) AND in_load);
			  
	bit5in <= (((int_value(6) AND i_shiftRight) OR 
			  (int_Value(4) AND i_shiftLeft) OR 
			  (int_Value(5) AND NOT(i_shiftLeft or i_shiftRight)))and not in_load) or (i_Value(5) AND in_load);
			  
	bit4in <= (((int_value(5) AND i_shiftRight) OR 
			  (int_Value(3) AND i_shiftLeft) OR 
			  (int_Value(4) AND NOT(i_shiftLeft or i_shiftRight)))and not in_load) or (i_Value(4) AND in_load);
			  
	bit3in <= (((int_value(4) AND i_shiftRight) OR 
			  (int_Value(2) AND i_shiftLeft) OR 
			  (int_Value(3) AND NOT(i_shiftLeft or i_shiftRight)))and not in_load) or (i_Value(3) AND in_load);

	bit2in <= (((int_value(3) AND i_shiftRight) OR 
			  (int_Value(1) AND i_shiftLeft) OR 
			  (int_Value(2) AND NOT(i_shiftLeft or i_shiftRight)))and not in_load) or (i_Value(2) AND in_load);
	
	bit1in <= (((int_value(2) AND i_shiftRight) OR 
			  (int_Value(0) AND i_shiftLeft) OR 
			  (int_Value(1) AND NOT(i_shiftLeft or i_shiftRight)))and not in_load) or (i_Value(1) AND in_load);
	
	lsbIn <= (((int_value(1) AND i_shiftRight) OR 
			  (i_loadRight AND i_shiftLeft) OR 
			  (int_Value(0) AND NOT(i_shiftLeft or i_shiftRight)))and not in_load) or (i_Value(0) AND in_load);
			  
msb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => msbIn, 
			  i_enable => '1',
			  i_clock => i_clock,
			  o_q => int_value(9),
	          o_qBar => int_notValue(9));
				 
bit8: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit8in,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_value(8),
	          o_qBar => int_notValue(8));
				 
bit7: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit7in,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_value(7),
	          o_qBar => int_notValue(7));				 
				 
bit6: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit6in,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_value(6),
	          o_qBar => int_notValue(6));

bit5: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit5in,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_value(5),
	          o_qBar => int_notValue(5));
				 
bit4: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit4in,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_value(4),
	          o_qBar => int_notValue(4));
		
bit3: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit3in,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_value(3),
	          o_qBar => int_notValue(3));
				 
bit2: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit2in,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_value(2),
	          o_qBar => int_notValue(2));
				 
bit1: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit1in,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_value(1),
	          o_qBar => int_notValue(1));

lsb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => lsbIn, 
			  i_enable => '1',
			  i_clock => i_clock,
			  o_q => int_value(0),
			  	  o_qBar => int_notValue(0));

	-- Output Driver
	o_Value		<= int_value;

END rtl;
