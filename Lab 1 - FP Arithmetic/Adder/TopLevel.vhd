library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevel is
	PORT(GClock, GReset : IN STD_LOGIC;
		  SignA, SignB : 	 IN STD_LOGIC;
		  ExponentA : 		 IN STD_LOGIC_VECTOR(6 downto 0);
		  ExponentB : 		 IN STD_LOGIC_VECTOR(6 downto 0);
		  MantissaA : 		 IN STD_LOGIC_VECTOR(7 downto 0);
		  MantissaB : 		 IN STD_LOGIC_VECTOR(7 downto 0);
		  Overflow, Zero : OUT STD_LOGIC;
		  SignOut : 		 OUT STD_LOGIC;
		  ExponentOut :	 OUT STD_LOGIC_VECTOR(6 downto 0);
		  MantissaOut : 	 OUT STD_LOGIC_VECTOR(7 downto 0);
		  controlDebg : 	 OUT STD_LOGIC_VECTOR(5 downto 0);
		  otherDebug : OUT STD_LOGIC_VECTOR(5 downto 0)  -- count_normal_shiftB_GTLTEQ
		  );
		  
end TopLevel;

ARCHITECTURE rtl OF TopLevel IS
	SIGNAL resetBar : STD_LOGIC;
	SIGNAL internal_count_done, internal_normal_done, internal_a_GT, internal_b_GT, internal_equal, shift : STD_LOGIC;
	SIGNAL control_state : STD_LOGIC_VECTOR(5 downto 0);

	COMPONENT FPAcontrol IS
		PORT(g_clock, g_resetBar : IN STD_LOGIC;
			  a_Greater, b_Greater, equal : IN STD_LOGIC;
			  counterDone, normalizedDone : IN STD_LOGIC;
			  o_controlSignal : OUT STD_LOGIC_VECTOR(5 downto 0)
			  );
			  
	END COMPONENT;

	COMPONENT FPAdata IS
	PORT( G_Clock, G_Reset : IN STD_LOGIC;
			Sign_A, Sign_B : IN STD_LOGIC;
			Exponent_A, Exponent_B : IN STD_LOGIC_VECTOR(6 downto 0);
			Mantissa_A, Mantissa_B : IN STD_LOGIC_VECTOR(7 downto 0);
			ControlState : IN STD_LOGIC_VECTOR(5 downto 0);
			Sign_Out : OUT STD_LOGIC;
			v, z : OUT STD_LOGIC;
			--outShiftB : OUT STD_LOGIC;
			o_aGT, o_bGT, o_EQ, countDone, normalized : OUT STD_LOGIC;
			Mantissa_Out : OUT STD_LOGIC_VECTOR(7 downto 0);
			Exponent_Out : OUT STD_LOGIC_VECTOR(6 downto 0)
		);
		
	END COMPONENT;	
		
BEGIN

datapath: FPAdata
	PORT MAP(G_Clock => GClock,
			   G_Reset => GReset,
				Sign_A => SignA,
				Sign_B => SignB,
				Exponent_A => ExponentA,
				Exponent_B => ExponentB,
				Mantissa_A => MantissaA,
				Mantissa_B => MantissaB,
				ControlState => control_state,
				Sign_Out => SignOut,
				v => Overflow,
				z => Zero,
				o_aGT => internal_a_GT,
				o_bGT => internal_b_GT,
				o_EQ => internal_equal,
				countDone => internal_count_done,
				normalized => internal_normal_done,
				Mantissa_Out => MantissaOut,
				Exponent_Out => ExponentOut
				--outShiftB => shift
			  );
			  
Controlpath: FPAcontrol
	PORT MAP(g_clock => GClock,
				g_resetBar => resetBar,
			   a_Greater => internal_a_GT,
				b_Greater => internal_b_GT,
				equal => internal_equal,
			   counterDone => internal_count_done,
				normalizedDone => internal_normal_done,
			   o_controlSignal => control_state
			  );

	resetBar <= not(GReset);
	controlDebg <= control_state;
	otherDebug <= internal_count_done & internal_normal_done & shift & internal_a_GT & internal_b_GT & internal_equal; -- count_normal_shiftB_GTLTEQ


END rtl;