--------------------------------------------------------------------------------
-- Title         : 7-bit Register
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : sevenBitRegister.vhd
-- Author        : Louis Marleau  
-- Created       : 2024/05/16

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sevenBitRegister IS
	PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(6 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(6 downto 0));
END sevenBitRegister;

ARCHITECTURE rtl OF sevenBitRegister IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(6 downto 0);

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

msb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_Value(6), 
			  i_enable => i_load,
			  i_clock => i_clock,
			  o_q => int_Value(6),
	          o_qBar => int_notValue(6));
				 
bit6: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_Value(5),
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(5),
	          o_qBar => int_notValue(5));
				 
bit5: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_Value(4),
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(4),
	          o_qBar => int_notValue(4));

bit4: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_Value(3),
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(3),
	          o_qBar => int_notValue(3));				 

bit3: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_Value(2),
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(2),
	          o_qBar => int_notValue(2));

bit2: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_Value(1),
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(1),
	          o_qBar => int_notValue(1));

lsb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_Value(0), 
			  i_enable => i_load,
			  i_clock => i_clock,
			  o_q => int_Value(0),
	          o_qBar => int_notValue(0));

	-- Output Driver
	o_Value		<= int_Value;

END rtl;
