-- Exponent counter component for IEEE 16-bit Floating Point Adder
-- Written by: Louis Marleau
-- 05/16/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY exponentCounter IS
	PORT ( ExponentA, ExponentB : IN STD_LOGIC_VECTOR (6 downto 0);
			 controlIn : IN STD_LOGIC_VECTOR(5 downto 0);
			 Esel, Equal, ld_E_c, clk, resetBar : IN STD_LOGIC;
			 o_done, o_shiftR, o_overflow : OUT STD_LOGIC;
			 dumOut : OUT STD_LOGIC_VECTOR (6 downto 0) --Additional
			);

END exponentCounter;

ARCHITECTURE rtl OF exponentCounter IS

	SIGNAL notReset, zero, customClock, loadCounter, countEnabled : STD_LOGIC;
	SIGNAL difference,operand1, operand2, dummyOut : STD_LOGIC_VECTOR(6 downto 0);

COMPONENT MUX2to1_7bit IS
    PORT( x : IN STD_LOGIC_VECTOR(6 downto 0);
        y : IN STD_LOGIC_VECTOR(6 downto 0);
        s : IN STD_LOGIC;
        m : OUT STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;

COMPONENT sevenBitAddSub is
	PORT( i_X, i_Y : in std_logic_vector(6 downto 0);
				carryIn, addSubIn : in std_logic;
				sum : out std_logic_vector(6 downto 0);
				carryOut: out std_logic);
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

	notReset <= not(resetBar);

operand1MUX: MUX2to1_7bit
	PORT MAP( x => ExponentA,
				 y => ExponentB,
				 s => Esel,
				 m => operand1
				 );
	
operand2MUX: MUX2to1_7bit
	PORT MAP( x => ExponentB,
					 y => ExponentA,
					 s => Esel,
					 m => operand2
					 );
					 
DifferenceMaker: sevenBitAddSub
	PORT MAP( i_X => operand1,
				 i_Y => operand2,
				 carryIn => '1',
				 addSubIn => '1',
				 sum => difference,
				 carryOut => o_overflow
				);

sevenBitCounter: counter
	PORT MAP( i_rst => resetBar,
				 i_load => loadCounter,
				 i_up	=> '0',
				 input => difference,
				 i_enabled => '1',
				 g_clock => customClock,
				 o_expired => zero,
				 o_Value => dummyOut
				);
					
	o_done <= zero and not(controlIn(1) or controlIn(2) or controlIn(4) or controlIn(5) or controlIn(0));
	o_shiftR <= not(zero) and controlIn(3) and not(Equal);
	loadCounter <= controlIn(1) or controlIn(2);
	customClock <= clk and controlIn(3);
	dumOut <= dummyOut; --Additional

END rtl;