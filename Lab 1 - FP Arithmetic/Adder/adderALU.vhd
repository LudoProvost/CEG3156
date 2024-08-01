-- Arithmetic component for IEEE 16-bit Floating Point Adder
-- Written by: Louis Marleau
-- 05/16/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY adderALU IS
	PORT( MantissaA, MantissaB : IN STD_LOGIC_VECTOR(7 downto 0);
			SignA, SignB : IN STD_LOGIC;
			g_clock, g_resetBar, B_ShiftR, load_MA, load_MB, M_Sel: IN STD_LOGIC;
			o_MantissaS : OUT STD_LOGIC_VECTOR(9 downto 0);
			o_overflow : OUT STD_LOGIC;
			o_operandAoperandB : OUT STD_LOGIC_VECTOR(19 downto 0) -- TEMP
		  );
		
END adderALU;

ARCHITECTURE rtl OF adderALU IS
	SIGNAL M_A, M_B : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL operandA, operandB, M_S, HighValueB, ValueA, sumOut : STD_LOGIC_VECTOR(9 downto 0);
	SIGNAL out20 : STD_LOGIC_VECTOR(19 downto 0);
	SIGNAL v, addSub : STD_LOGIC;

COMPONENT MUX2to1_8bit IS
    PORT( x : IN STD_LOGIC_VECTOR(7 downto 0);
        y : IN STD_LOGIC_VECTOR(7 downto 0);
        s : IN STD_LOGIC;
        m : OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT tenbitShiftRegister IS
	PORT(
		i_resetBar, in_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_shiftLeft, i_shiftRight, i_loadLeft, i_loadRight : IN STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(9 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(9 downto 0));
END COMPONENT;

COMPONENT twentybitShiftRegister IS
	PORT(
		i_resetBar, in_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_shiftLeft, i_shiftRight : IN STD_LOGIC;
		i_ValueH, i_ValueL		  : IN	STD_LOGIC_VECTOR(9 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(19 downto 0));
END COMPONENT;

COMPONENT tenBitAddSub is
	port( i_X, i_Y : in std_logic_vector(9 downto 0);
				carryIn, addSubIn : in std_logic;
				sum : out std_logic_vector(9 downto 0);
				carryOut: out std_logic);
END COMPONENT;

BEGIN

	highValueB <= "01" & M_B;
	ValueA <= "01" & M_A;

BmantissaSelect: MUX2to1_8bit
	PORT MAP( x => MantissaB,
				 y => MantissaA,
				 s => M_Sel,
				 m => M_B
				);

AmantissaSelect: MUX2to1_8bit
	PORT MAP( x => MantissaA,
					 y => MantissaB,
					 s => M_Sel,
					 m => M_A
					);

Bregister: twentybitShiftRegister
	PORT MAP( i_resetBar => g_resetBar,
				 in_load => load_MB,
				 i_clock => g_clock,
				 i_shiftLeft => '0',
				 i_shiftRight => B_ShiftR,
				 i_ValueH => highValueB,
				 i_ValueL => "0000000000",
				 o_value => out20
				);

Aregister: tenbitShiftRegister
	PORT MAP( i_resetBar => g_resetBar,
				 in_load => load_MA,
				 i_clock => g_clock,
				 i_shiftLeft => '0',
				 i_shiftRight => '0',
				 i_loadLeft => '0',
				 i_loadRight => '0',
				 i_Value => ValueA,
				 o_value => operandA
				);
				
ALUadder: tenBitAddSub
	PORT MAP( i_X => operandA,
				 i_Y => operandB,
				 carryIn => addSub,
				 addSubIn => addSub,
				 sum => sumOut,
				 carryOut => v
				);
				
	addSub <= SignA xor SignB;
	operandB <= out20(19 downto 10);
	o_overflow <= v;
	o_MantissaS <= sumOut;
	o_operandAoperandB <= operandA & operandB; -- TEMP

END rtl;