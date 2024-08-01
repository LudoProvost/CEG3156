--------------------------------------------------------------------------------
-- Title         : 8-bit Shift Register
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : eightBitShiftRegister.vhd
-- Author        : Rami Abielmona  <rabielmo@site.uottawa.ca>, Louis Marleau <lmarl090@uottawa.ca>.
-- Created       : 2003/05/17
-- Last modified : 2023/09/29
-------------------------------------------------------------------------------
-- Description : This file creates a 8-bit shift register as defined in the VHDL 
--		 Synthesis lecture. The architecture is done at the RTL 
--		 abstraction level and the implementation is done in structural
--		 VHDL.
-------------------------------------------------------------------------------
-- Modification history :
-- 2003.05.17 	R. Abielmona		Creation
-- 2004.09.22 	R. Abielmona		Ported for CEG 3550
-- 2007.09.25 	R. Abielmona		Modified copyright notice
-- 2023.09.28  L. Marleau        Modified for 8 bit use
-------------------------------------------------------------------------------
-- This file is copyright material of Rami Abielmona, Ph.D., P.Eng., Chief Research
-- Scientist at Larus Technologies.  Permission to make digital or hard copies of part
-- or all of this work for personal or classroom use is granted without fee
-- provided that copies are not made or distributed for profit or commercial
-- advantage and that copies bear this notice and the full citation of this work.
-- Prior permission is required to copy, republish, redistribute or post this work.
-- This notice is adapted from the ACM copyright notice.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitShiftRegister IS
	PORT(
		i_resetBar, in_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_shiftLeft, i_shiftRight, i_loadLeft, i_loadRight : IN STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
END eightBitShiftRegister;

ARCHITECTURE rtl OF eightBitShiftRegister IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL msbIn, bit6in, bit5in, bit4in, bit3in, bit2in, bit1in, lsbIn, i_load : STD_LOGIC;

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN
	
	i_load <= '1';
	
	msbIn <= ((i_loadLeft AND i_shiftRight) OR 
			  (int_Value(6) AND i_shiftLeft) OR (i_value(7) AND in_load) OR
			  (int_Value(7) AND NOT(i_shiftLeft) AND NOT(i_shiftRight)));
			  
	bit6in <= ((int_value(7) AND i_shiftRight) OR 
			  (int_Value(5) AND i_shiftLeft) OR (i_value(6) AND in_load) OR
			  (int_Value(6) AND NOT(i_shiftLeft) AND NOT(i_shiftRight)));
			  
	bit5in <= ((int_value(6) AND i_shiftRight) OR 
			  (int_Value(4) AND i_shiftLeft) OR (i_value(5) AND in_load) OR
			  (int_Value(5) AND NOT(i_shiftLeft) AND NOT(i_shiftRight)));
			  
	bit4in <= ((int_value(5) AND i_shiftRight) OR 
			  (int_Value(4) AND i_shiftLeft) OR (i_value(4) AND in_load) OR
			  (int_Value(3) AND NOT(i_shiftLeft) AND NOT(i_shiftRight)));
			  
	bit3in <= ((int_value(4) AND i_shiftRight) OR 
			  (int_Value(2) AND i_shiftLeft) OR (i_value(3) AND in_load) OR
			  (int_Value(3) AND NOT(i_shiftLeft) AND NOT(i_shiftRight)));

	bit2in <= ((int_value(3) AND i_shiftRight) OR 
			  (int_Value(1) AND i_shiftLeft) OR (i_value(2) AND in_load) OR
			  (int_Value(2) AND NOT(i_shiftLeft) AND NOT(i_shiftRight)));
	
	bit1in <= ((int_value(2) AND i_shiftRight) OR 
			  (int_Value(0) AND i_shiftLeft) OR (i_value(1) AND in_load) OR
			  (int_Value(1) AND NOT(i_shiftLeft) AND NOT(i_shiftRight)));
	
	lsbIn <= ((int_value(1) AND i_shiftRight) OR 
			  (i_loadRight AND i_shiftLeft) OR (i_value(0) AND in_load) OR
			  (int_Value(0) AND NOT(i_shiftLeft) AND NOT(i_shiftRight)));
			  
msb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => msbIn, 
			  i_enable => i_load ,
			  i_clock => i_clock,
			  o_q => int_value(7),
	          o_qBar => int_notValue(7));
				 
bit6: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit6in,
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_value(6),
	          o_qBar => int_notValue(6));

bit5: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit5in,
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_value(5),
	          o_qBar => int_notValue(5));
				 
bit4: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit4in,
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_value(4),
	          o_qBar => int_notValue(4));
		
bit3: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit3in,
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_value(3),
	          o_qBar => int_notValue(3));
				 
bit2: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit2in,
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_value(2),
	          o_qBar => int_notValue(2));
				 
bit1: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => bit1in,
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_value(1),
	          o_qBar => int_notValue(1));

lsb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => lsbIn, 
			  i_enable => i_load,
			  i_clock => i_clock,
			  o_q => int_value(0),
			  	  o_qBar => int_notValue(0));

	-- Output Driver
	o_Value		<= int_Value;

END rtl;
