-- ID/EX Buffer
-- Written by: Louis Marleau
-- 07/07/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ID_EX IS
	PORT( i_A, i_B, i_Rt2 : IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Rs, i_Rt1, i_Rd: IN	STD_LOGIC_VECTOR(4 downto 0);
		  	i_WB : IN STD_LOGIC_VECTOR(1 downto 0);
			i_M, i_EX : IN STD_LOGIC_VECTOR(2 downto 0);
			G_Reset, G_clock, i_ALUSrc_ID : IN STD_LOGIC;
			o_WB : OUT STD_LOGIC_VECTOR(1 downto 0);
			o_M, o_EX : OUT STD_LOGIC_VECTOR(2 downto 0);
		   o_A, o_B, o_Rt2  : OUT	STD_LOGIC_VECTOR(7 downto 0);
			o_Rs, o_Rd, o_Rt1: OUT	STD_LOGIC_VECTOR(4 downto 0);
			o_ALUSrc_EX : OUT STD_LOGIC);
END ID_EX;

ARCHITECTURE structure OF ID_EX IS
	SIGNAL controlReg, controlRegOut, outRs, outRt1, outRd, rsReg_reginput, rt1Reg_reginput, rdReg_reginput : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL notALUSrc_EX : STD_LOGIC;
	
	COMPONENT reg_8b is
		 port(
			  i_reset, SEL, LOAD, CLK: in std_logic;
			  INPUT: in std_logic_vector(7 downto 0);
			  OUTPUT: out std_logic_vector(7 downto 0)
		 );
	END COMPONENT;
	
			 
	COMPONENT enARdFF_2 IS
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

rsReg_reginput <= "000" & i_Rs;
rt1Reg_reginput <= "000" & i_Rt1;
rdReg_reginput <= "000" & i_Rd;

sourceRegA: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => i_A,
			  OUTPUT => o_A
		 );
		 
sourceRegB: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => i_B,
			  OUTPUT => o_B
		 );
		 
rsReg: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => rsReg_reginput,
			  OUTPUT => outRs
		 );
		 
rt1Reg: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => rt1Reg_reginput,
			  OUTPUT => outRt1
		 );
		 
rt2Reg: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => i_Rt2,
			  OUTPUT => o_Rt2
		 );
		 
rdReg: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => '1',
			  CLK => G_clock,
			  INPUT => rdReg_reginput,
			  OUTPUT => outRd
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

ALUSrcBuffer: enaRdFF_2
		PORT MAP(
			i_resetBar => G_Reset,
			i_d => i_ALUSrc_ID,
			i_enable	=> '1',
			i_clock	=> G_clock,
			o_q => o_ALUSrc_EX,
			o_qBar => notALUSrc_EX);

	controlReg <= i_WB & i_M & i_EX;
	o_WB <= controlRegOut(7 downto 6);
	o_M  <= controlRegOut(5 downto 3);
	o_EX <= controlRegOut(2 downto 0);
	o_Rs <= outRs(4 downto 0);
	o_Rt1 <= outRt1(4 downto 0);
	o_Rd <= outRd(4 downto 0);
	
END structure;