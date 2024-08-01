-- Sign ALU
-- Written by: Louis Marleau
-- 05/16/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY signALU IS
	PORT( i_sign_A, i_sign_B, i_select, i_equal : IN STD_LOGIC;
			i_mantissa_A, i_mantissaB : IN STD_LOGIC_VECTOR (7 downto 0);
			o_sign, o_z : OUT STD_LOGIC
			);

END signALU;

ARCHITECTURE rtl OF signALU IS

	SIGNAL z, o_left_1, o_bottom, o_right_1, o_right_2, o_greater, o_less, xorSel : STD_LOGIC;

	COMPONENT MUX2to1bit IS
		 PORT( x : IN STD_LOGIC;
			  y : IN STD_LOGIC;
			  s : IN STD_LOGIC;
			  m : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT eightBitComparator IS
		PORT(
			i_Ai			: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Bi			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_GT, o_LT, o_EQ		: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

	xorSel <= i_sign_A xor i_sign_B;
	
CompareMantissas: eightBitComparator
	PORT MAP(  i_Ai => i_mantissa_A,
				  i_Bi => i_mantissaB,
				  o_GT => o_greater,
				  o_LT => o_less,
				  o_EQ => z);

MUXleft1: MUX2to1bit
	PORT MAP( x => i_sign_A,
				 y => i_sign_B,
				 s => i_select,
				 m => o_left_1);
MUXbottom: MUX2to1bit
	PORT MAP( x => o_left_1,
				 y => o_right_2,
				 s => i_equal,
				 m => o_bottom);
				 
MUXright1: MUX2to1bit
	PORT MAP( x => i_sign_B,
				 y => i_sign_A,
				 s => o_greater,
				 m => o_right_1);

MUXright2: MUX2to1bit
	PORT MAP( x => i_sign_B,
				 y => o_right_1,
				 s => xorSel,
				 m => o_right_2);

-- output
	o_sign <=  o_bottom and not(z);
	o_z <= z;

END rtl;