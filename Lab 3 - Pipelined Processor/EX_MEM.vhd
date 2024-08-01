-- ID/EX Buffer
-- Written by: Louis Marleau
-- 07/07/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY EX_MEM IS
		PORT( 	i_ALU, i_Rt : IN	STD_LOGIC_VECTOR(7 downto 0);
					G_Reset, G_clock : IN STD_LOGIC;
					i_WB_MEM, i_Rd : IN STD_LOGIC_VECTOR(4 downto 0);
					o_WB_MEM, o_Rd: OUT STD_LOGIC_VECTOR(4 downto 0);
					o_ALU, o_Rt  : OUT	STD_LOGIC_VECTOR(7 downto 0));
END EX_MEM;

ARCHITECTURE structure OF EX_MEM IS
	SIGNAL controlReg, output_WB_MEM : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL RdRegIn, RtRegIn : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL outRd, outRt : STD_LOGIC_VECTOR(7 downto 0);
	
	COMPONENT reg_8b is
		 port(
			  i_reset, SEL, LOAD, CLK: in std_logic;
			  INPUT: in std_logic_vector(7 downto 0);
			  OUTPUT: out std_logic_vector(7 downto 0)
		 );
	END COMPONENT;


BEGIN

	RdRegIn <= "000" & i_Rd;
	RtRegIn <= i_Rt;

aluReg: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => i_ALU,
			  OUTPUT => o_ALU
		 );
		 
rdReg: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => RdRegIn,
			  OUTPUT => outRd
		 );
		 
rtReg: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => RtRegIn,
			  OUTPUT => outRt
		 );
		 
controlSignals: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => controlReg,
			  OUTPUT => output_WB_MEM
		 );

	controlReg <= i_WB_MEM & "000";
	o_WB_MEM <= output_WB_MEM(7 downto 3);
	o_Rt <= outRt;
	o_Rd <= outRd(4 downto 0);
		 
END structure;