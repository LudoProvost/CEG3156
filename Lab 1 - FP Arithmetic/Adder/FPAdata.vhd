-- IEEE 16-bit Floating Point Adder Datapath
-- Written by: Louis Marleau
-- 05/16/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FPAdata IS
	PORT( G_Clock, G_Reset : IN STD_LOGIC;
			Sign_A, Sign_B : IN STD_LOGIC;
			Exponent_A, Exponent_B : IN STD_LOGIC_VECTOR(6 downto 0);
			Mantissa_A, Mantissa_B : IN STD_LOGIC_VECTOR(7 downto 0);
			ControlState : IN STD_LOGIC_VECTOR(5 downto 0);
			Sign_Out : OUT STD_LOGIC;
			v, z : OUT STD_LOGIC;
			o_aGT, o_bGT, o_EQ, countDone, normalized : OUT STD_LOGIC;
			Mantissa_Out : OUT STD_LOGIC_VECTOR(7 downto 0);
			Exponent_Out : OUT STD_LOGIC_VECTOR(6 downto 0)
			--outShiftB : OUT STD_LOGIC; --TEMP
			--outOperands : OUT STD_LOGIC_VECTOR(19 downto 0) --TEMP
		);
			
END FPAdata;

ARCHITECTURE rtl OF FPAdata IS
	SIGNAL mantissaOutAdder, mantissaAdderOutDEBUG : STD_LOGIC_VECTOR(9 downto 0);
	SIGNAL overflow : STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL outExponent, dummyOut : STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL normFirst2bits : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL expSel, a_GT, b_GT, a_equals_b, ShiftB, done, customState  : STD_LOGIC;
	SIGNAL adderOperands : STD_LOGIC_VECTOR(19 downto 0); --TEMP
	
COMPONENT exponentCheck IS
	PORT( g_clock, g_resetBar : IN STD_LOGIC;
		   ld_E_a, ld_E_b, Esel : IN STD_LOGIC;
			exponentA, exponentB : IN STD_LOGIC_VECTOR (6 downto 0);
			exponentOut : OUT STD_LOGIC_VECTOR (6 downto 0);
			o_aIsGreater, o_bIsGreater, equal : OUT STD_LOGIC
			);
			
END COMPONENT;

COMPONENT exponentCounter IS
	PORT ( ExponentA, ExponentB : IN STD_LOGIC_VECTOR (6 downto 0);
			 controlIn : IN STD_LOGIC_VECTOR(5 downto 0);
			 Esel, Equal, ld_E_c, clk, resetBar : IN STD_LOGIC;
			 o_done, o_shiftR, o_overflow : OUT STD_LOGIC;
			 dumOut : OUT STD_LOGIC_VECTOR (6 downto 0) --Additional
			);

END COMPONENT;

COMPONENT adderALU IS
	PORT( MantissaA, MantissaB : IN STD_LOGIC_VECTOR(7 downto 0);
			SignA, SignB : IN STD_LOGIC;
			g_clock, g_resetBar, B_ShiftR, load_MA, load_MB, M_Sel: IN STD_LOGIC;
			o_MantissaS : OUT STD_LOGIC_VECTOR(9 downto 0);
			o_overflow : OUT STD_LOGIC;
			o_operandAoperandB : OUT STD_LOGIC_VECTOR(19 downto 0)
		  );
		
END COMPONENT;

COMPONENT normalizeALU IS
	PORT ( i_MantissaS : IN STD_LOGIC_VECTOR(9 downto 0);
		    clk, g_resetBar, load_MS, loadCount, state : IN STD_LOGIC;
			 i_E : IN STD_LOGIC_VECTOR(6 downto 0);
			 o_Oveflow : OUT STD_LOGIC;
			 o_firstTwoBits : OUT STD_LOGIC_VECTOR(1 downto 0);
			 o_MS : OUT STD_LOGIC_VECTOR(7 downto 0);
			 o_ES : OUT STD_LOGIC_VECTOR(6 downto 0)
			);
	
END COMPONENT;

COMPONENT signALU IS
	PORT( i_sign_A, i_sign_B, i_select, i_equal : IN STD_LOGIC;
			i_mantissa_A, i_mantissaB : IN STD_LOGIC_VECTOR (7 downto 0);
			o_sign, o_z : OUT STD_LOGIC
			);

END COMPONENT;

BEGIN

ComputeSign: signALU
	PORT MAP(i_sign_A => Sign_A,
				i_sign_B => Sign_B,
				i_select => expSel,
				i_equal=> a_equals_b,
				i_mantissa_A => Mantissa_A,
				i_mantissaB => Mantissa_B,
				o_sign => Sign_Out,
				o_z => z
				);

CheckExponent: exponentCheck
	PORT MAP(g_clock => G_Clock,
			   g_resetBar => G_Reset,
				ld_E_a => ControlState(1),
				ld_E_b => ControlState(1),
				Esel => expSel,
				exponentA => Exponent_A,
				exponentB => Exponent_B,
				exponentOut => outExponent,
				o_aIsGreater => a_GT,
				o_bIsGreater => b_GT,
				equal => a_equals_b
				);
				
ExponentCount: exponentCounter
	PORT MAP(ExponentA => Exponent_A,
				ExponentB => Exponent_B,
				controlIn => ControlState,
				Esel => expSel,
				Equal => a_equals_b,
				ld_E_c => ControlState(2),
				clk => G_Clock,
				resetBar => G_Reset,
				o_done => done,
				o_shiftR => ShiftB,
				o_overflow => overflow(0),
				dumOut => dummyOut --Additional
				);

AddSubMantissa: adderALU
	PORT MAP(MantissaA => Mantissa_A,
				MantissaB => Mantissa_B,
				SignA => Sign_A,
				SignB => Sign_B,
				g_clock => G_Clock,
				g_resetBar => G_Reset,
				B_ShiftR => ShiftB, 
				load_MA => ControlState(2),
				load_MB => ControlState(2),
				M_Sel => expSel,
				o_MantissaS => mantissaOutAdder, -- mantissaAdderOutDEBUG, -- 
				o_overflow => overflow(1),
				o_operandAoperandB => adderOperands -- TEMP
			  );

NormalizeMantissa:normalizeALU
	PORT MAP(i_MantissaS => mantissaOutAdder, -- mantissaAdderOutDEBUG,-- 
				 clk => G_Clock,
				 g_resetBar => G_Reset,
				 load_MS => ControlState(4),
				 loadCount => ControlState(4), 
				 i_E => outExponent,
				 state => customState,
				 o_Oveflow => overflow(2),
				 o_firstTwoBits => normFirst2bits,
				 o_MS => Mantissa_Out, --mantissaOutAdder(7 downto 0), -- 
				 o_ES => Exponent_Out
				);
				
	-- Drivers			
	normalized <= not(normFirst2bits(1)) and normFirst2bits(0);
	v <= overflow(2);
	expSel <= not(a_GT);
	o_aGT <= a_GT;
	o_bGT <= b_GT;
	o_EQ <= a_equals_b;
	countDone <= done;
	customState <= ControlState(4) or ControlState(5);
	-- Mantissa_Out <= mantissaAdderOutDEBUG(7 downto 0);
	--outShiftB <= ShiftB;
	--outOperands <= adderOperands;
	
END rtl;