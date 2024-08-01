-- Exponent check component for IEEE 16-bit Floating Point Adder
-- Written by: Louis Marleau
-- 05/16/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY exponentCheck IS
	PORT( g_clock, g_resetBar : IN STD_LOGIC;
		   ld_E_a, ld_E_b, Esel : IN STD_LOGIC;
			exponentA, exponentB : IN STD_LOGIC_VECTOR (6 downto 0);
			exponentOut : OUT STD_LOGIC_VECTOR (6 downto 0);
			o_aIsGreater, o_bIsGreater, equal : OUT STD_LOGIC
			);
			
END exponentCheck;

ARCHITECTURE rtl OF exponentCheck IS
	SIGNAL e_a, e_b : STD_LOGIC_VECTOR(6 downto 0);

COMPONENT MUX2to1_7bit IS
    PORT( x : IN STD_LOGIC_VECTOR(6 downto 0);
        y : IN STD_LOGIC_VECTOR(6 downto 0);
        s : IN STD_LOGIC;
        m : OUT STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;

COMPONENT sevenBitComparator IS
	PORT(
		i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(6 downto 0);
		o_GT, o_LT, o_EQ		: OUT	STD_LOGIC);
END COMPONENT;

COMPONENT sevenBitRegister IS
	PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(6 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;

BEGIN

registerA: sevenBitRegister
	PORT MAP( i_resetBar => g_resetBar,
				 i_load => '1',
				 i_clock => g_clock,
				 i_Value => exponentA,
				 o_Value => e_a
				 );
				 
registerB: sevenBitRegister
	PORT MAP( i_resetBar => g_resetBar,
				 i_load => '1',
				 i_clock => g_clock,
				 i_Value => exponentB,
				 o_Value => e_b
				 );
				 
exponentSelector: MUX2to1_7bit
	PORT MAP( x => e_a,
				 y => e_b,
				 s => Esel,
				 m => exponentOut
				);
compare: sevenBitComparator
	PORT MAP( i_Ai => e_a,
				 i_Bi => e_b,
				 o_GT => o_aIsGreater,
				 o_LT => o_bIsGreater,
				 O_EQ => equal
				);
	

END rtl;
			