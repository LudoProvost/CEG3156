-- MEM/WB Buffer
-- Written by: Louis Marleau
-- 07/07/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MEM_WB IS
		PORT( 	i_Data, i_aluBypass, i_Rd : IN	STD_LOGIC_VECTOR(7 downto 0);
					G_Reset, G_clock : IN STD_LOGIC;
					i_WB : IN STD_LOGIC_VECTOR(1 downto 0);
					o_Rd : OUT STD_LOGIC_VECTOR(4 downto 0);
					o_WB : OUT STD_LOGIC_VECTOR(1 downto 0);
					o_Data, o_aluBypass : OUT	STD_LOGIC_VECTOR(7 downto 0));
END MEM_WB;

ARCHITECTURE struct OF MEM_WB IS
	SIGNAL controlReg, controlRegOut, writeBackReg : STD_LOGIC_VECTOR(7 downto 0);
	
	COMPONENT reg_8b is
		 port(
			  i_reset, SEL, LOAD, CLK: in std_logic;
			  INPUT: in std_logic_vector(7 downto 0);
			  OUTPUT: out std_logic_vector(7 downto 0)
		 );
	END COMPONENT;


BEGIN

dataReg: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => i_Data,
			  OUTPUT => o_Data
		 );
		 
bypassReg: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => i_aluBypass,
			  OUTPUT => o_aluBypass
		 );
		 
rdReg: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => i_Rd,
			  OUTPUT => writeBackReg
		 );
		 
controlSignals: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => controlReg,
			  OUTPUT => controlRegOut
		 );

	controlReg <= i_WB & "000000";
	o_WB <= controlRegOut(7 downto 6);
	o_Rd <= writeBackReg(4 downto 0);
	
		 
END struct;