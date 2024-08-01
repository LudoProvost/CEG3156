library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevelEntity_TB is -- no defined ports
end TopLevelEntity_TB;

Architecture testbench of TopLevelEntity_TB IS
	SIGNAL clk_tb, resetBar : STD_LOGIC;
	SIGNAL sim_end : boolean := false;
	SIGNAL a_sign, b_sign : STD_LOGIC;
	SIGNAL a_exponent, b_exponent : STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL a_mantissa, b_mantissa : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL o_V, o_Z, o_sign : STD_LOGIC;
	SIGNAL o_exponent : STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL o_mantissa : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL controlDebug, count_normal_shiftB_GTLTEQ : STD_LOGIC_VECTOR(5 downto 0);
	
COMPONENT TopLevel is 
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
		  otherDebug : OUT STD_LOGIC_VECTOR(5 downto 0)
		  );

END COMPONENT;

BEGIN

Test: TopLevel
	PORT MAP(GClock => clk_tb,
				GReset => resetBar,
				SignA => a_sign,
				SignB => b_sign,
				ExponentA => a_exponent,
				ExponentB => b_exponent,
				MantissaA => a_mantissa,
				MantissaB => b_mantissa,
				Overflow => o_V,
				SignOut => o_sign,
				Zero => o_Z,
				ExponentOut => o_exponent,
				MantissaOut => o_mantissa,
				controlDebg => controlDebug,
				otherDebug => count_normal_shiftB_GTLTEQ
				);

clk_process : process
    begin
        while(not sim_end) loop
            clk_tb <= '1';
            wait for 25ns;
            clk_tb <= '0';
            wait for 25ns;
        end loop;
    end process;

testbench: process
	begin
		resetBar <= '0';
		a_sign <= '0';
		b_sign <= '1';
		a_exponent <= "0000010";
		b_exponent <= "0000100";
		a_mantissa <= "01000100";
		b_mantissa <= "00101000";
		wait for 100ns;
		
		resetBar <= '1';
		wait for 900ns;
		
		resetBar <= '0';
		sim_end <= true;
		wait;
		
		end process;

END testbench;