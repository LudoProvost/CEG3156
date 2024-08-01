-- 20-bit shift register
-- Written by: Louis Marleau
-- 05/16/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY twentybitShiftRegister IS
	PORT(
		i_resetBar, in_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_shiftLeft, i_shiftRight : IN STD_LOGIC;
		i_ValueH, i_ValueL		  : IN	STD_LOGIC_VECTOR(9 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(19 downto 0));
END twentybitShiftRegister;

ARCHITECTURE rtl OF twentybitShiftRegister IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(19 downto 0);
	SIGNAL upperHalf,lowerHalf : STD_LOGIC_VECTOR (9 downto 0);

	COMPONENT tenbitShiftRegister
		PORT(
			i_resetBar, in_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_shiftLeft, i_shiftRight, i_loadLeft, i_loadRight : IN STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(9 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(9 downto 0));
	END COMPONENT;

BEGIN
Higher: tenbitShiftRegister
		PORT MAP(
			i_resetBar => i_resetBar, 
			in_load	=> in_load,
			i_clock => i_clock,
			i_shiftLeft => i_shiftLeft, 
			i_shiftRight => i_shiftRight,
			i_loadLeft => '0',
			i_loadRight => lowerHalf(0),
			i_Value => i_ValueH,
			o_Value => upperHalf);

Lower: tenbitShiftRegister
		PORT MAP(
			i_resetBar => i_resetBar, 
			in_load	=> in_load,
			i_clock => i_clock,
			i_shiftLeft => i_shiftLeft, 
			i_shiftRight => i_shiftRight,
			i_loadLeft => upperHalf(0),
			i_loadRight => '0',
			i_Value => i_ValueH,
			o_Value => lowerHalf);
			
	-- Output Driver
	int_Value <= upperHalf & lowerHalf;
	o_Value		<= int_Value;

END rtl;
