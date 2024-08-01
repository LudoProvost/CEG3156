-- Normalization component for IEEE 16-bit Floating Point Adder
-- Written by: Louis Marleau
-- 05/16/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY normalizeALU IS
	PORT ( i_MantissaS : IN STD_LOGIC_VECTOR(9 downto 0);
		    clk, g_resetBar, load_MS, loadCount, state : IN STD_LOGIC;
			 i_E : IN STD_LOGIC_VECTOR(6 downto 0);
			 o_Oveflow : OUT STD_LOGIC;
			 o_firstTwoBits : OUT STD_LOGIC_VECTOR(1 downto 0);
			 o_MS : OUT STD_LOGIC_VECTOR(7 downto 0);
			 o_ES : OUT STD_LOGIC_VECTOR(6 downto 0)
			);
	
END normalizeALU;

ARCHITECTURE rtl OF normalizeALU IS
	SIGNAL MantissaOut : STD_LOGIC_VECTOR(9 downto 0);
	SIGNAL reset, leftShift, rightShift, customClock, zero : STD_LOGIC;

COMPONENT tenbitShiftRegister IS
	PORT(
		i_resetBar, in_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_shiftLeft, i_shiftRight, i_loadLeft, i_loadRight : IN STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(9 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(9 downto 0));
END COMPONENT;

COMPONENT counter IS
	PORT(
		i_rst, i_load	: IN	STD_LOGIC;
		input 			: in std_LOGIC_VECTOR(6 downto 0);
		i_up				: IN STD_LOGIC;
		i_enabled 		: IN STD_LOGIC;
		g_clock			: IN	STD_LOGIC;
		o_expired 		: out std_logic;
		o_Value			: OUT	STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;

BEGIN
	
	reset <= not(g_resetBar);
	customClock <= (rightShift or loadCount or leftShift) and clk;

MantissaShiftReg: tenbitShiftRegister
	PORT MAP( i_resetBar => g_resetBar,
				 in_load => load_MS,
				 i_clock => clk,
				 i_shiftLeft => leftShift,
				 i_shiftRight => rightShift,
				 i_loadLeft => '0',
				 i_loadRight => '0',
				 i_value => i_MantissaS, --"1000111001"
				 o_value => MantissaOut
				 );

ExponentIncrement: counter
	PORT MAP( i_Rst => g_resetBar,
				 i_load => loadCount,
				 i_up	=> rightShift,
				 input => i_E,
				 i_enabled => state, 
				 g_clock => customClock,
				 o_expired => zero,
				 o_value => o_ES
				 );

	rightShift <= MantissaOut(9);
	leftShift <= (not(MantissaOut(8)) and not(MantissaOut(9)));

 -- Truncated Mantissa OUT
	o_MS <= MantissaOut(7 downto 0);
	o_Oveflow <= zero and (i_E(6) and i_E(5) and i_E(4) and i_E(3) and i_E(2) and i_E(1) and i_E(0));
	o_firstTwoBits <= MantissaOut(9 downto 8);

END rtl;