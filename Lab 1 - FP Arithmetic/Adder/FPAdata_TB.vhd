library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FPAdata_TB is -- no defined ports
end FPAdata_TB;

Architecture testbench of FPAdata_TB IS

Component FPAdata IS
	PORT( G_Clock, G_Reset : IN STD_LOGIC;
			Sign_A, Sign_B : IN STD_LOGIC;
			Exponent_A, Exponent_B : IN STD_LOGIC_VECTOR(6 downto 0);
			Mantissa_A, Mantissa_B : IN STD_LOGIC_VECTOR(7 downto 0);
			ControlState : IN STD_LOGIC_VECTOR(5 downto 0);
			Sign_Out : OUT STD_LOGIC;
			v, z : OUT STD_LOGIC;
			o_aGT, o_bGT, o_EQ, countDone, normalized : OUT STD_LOGIC;
			Mantissa_Out : OUT STD_LOGIC_VECTOR(7 downto 0);
			Exponent_Out : OUT STD_LOGIC_VECTOR(6 downto 0);
			--dummyOut : OUT STD_LOGIC_VECTOR (6 downto 0); --additional
			outShiftB : OUT STD_LOGIC; -- temp
			outOperands : OUT STD_LOGIC_VECTOR(19 downto 0) -- temp
		);
END Component;

	SIGNAL clk_tb, resetBar, signA, signB, zero, overflow, equal, aGT, bGT, count, normal, signOut : STD_LOGIC;
	SIGNAL exponentA, exponentB, exponentOut : STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL mantissaA, mantissaB, mantissaOut : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL exponentCounter : STD_LOGIC_VECTOR(6 downto 0); --additional
	SIGNAL shiftB : STD_LOGIC; -- temp 
	SIGNAL operandA_operandB : STD_LOGIC_VECTOR(19 downto 0); --temp
	SIGNAL controlIn : STD_LOGIC_VECTOR(5 downto 0);
	SIGNAL sim_end : boolean := false;

BEGIN

Datapath: FPAdata
	PORT MAP(G_Clock => clk_tb,
				G_Reset => resetBar,
				Sign_A => signA,
				Sign_B => signB,
				Exponent_A => exponentA,
				Exponent_B => exponentB,
				Mantissa_A => mantissaA,
				Mantissa_B => mantissaB,
				ControlState => controlIn,
				Sign_Out => signOut,
				v => overflow,
				z => zero,
				o_aGT => aGT,
				o_bGT => bGT,
				o_EQ => equal,
				countDone => count,
				normalized => normal,
				Mantissa_Out => mantissaOut,
				Exponent_Out => exponentOut,
				outOperands => operandA_operandB,
				outShiftB => shiftB
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
		signA <= '0';
		signB <= '0';
		exponentA <= "0000101";
		exponentB <= "0000101";
		mantissaA <= "11100111";
		mantissaB <= "10010100";
		controlIn <= "000000";
		
		wait for 50ns;
		
		resetBar <= '1';
		
		wait for 50ns;
		controlIn <= "000010";
		wait for 100ns;
		
		controlIn <= "000100";
		wait for 100ns;
		
		controlIn <= "001000";
		wait for 50ns;
		--wait until (count='1');
		wait for 50ns;
		
		controlIn <= "010000";
		wait for 50ns;
		--wait until (normal='1');
		wait for 50ns;
		
		
		controlIn <= "100000";
		
		wait for 50ns;
		
		controlIn <= "000001";
		wait for 100ns;
		
		resetBar <= '0';
		
		wait for 50ns;
		sim_end <= true;
		wait;
		
		end process;	
		
END testbench;