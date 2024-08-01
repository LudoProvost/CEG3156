-- IF/ID Buffer
-- Written by: Louis Marleau
-- 07/07/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IF_ID IS
	PORT( i_instruction : IN	STD_LOGIC_VECTOR(31 downto 0);
			i_instructionCount: IN	STD_LOGIC_VECTOR(7 downto 0);
		  	if_flush, i_hazard, G_Reset, G_clock : IN STD_LOGIC;					-- if_Flush still not functional
		   o_instruction : OUT	STD_LOGIC_VECTOR(31 downto 0);
			o_instructionCount: OUT	STD_LOGIC_VECTOR(7 downto 0));
END IF_ID;

ARCHITECTURE structure OF IF_ID IS

	COMPONENT reg_8b is
		 port(
			  i_reset, SEL, LOAD, CLK: in std_logic;
			  INPUT: in std_logic_vector(7 downto 0);
			  OUTPUT: out std_logic_vector(7 downto 0)
		 );
	END COMPONENT;

	-- signal flushReset: std_logic;
BEGIN
-- flushReset <= G_reset or not(if_flush); -- resets when either G_reset is 0, 


instructionReg31to24: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => i_hazard,
			  CLK => G_clock,
			  INPUT => i_instruction(31 downto 24),
			  OUTPUT => o_instruction(31 downto 24)
		 );

instructionReg23to16: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => i_hazard,
			  CLK => G_clock,
			  INPUT => i_instruction(23 downto 16),
			  OUTPUT => o_instruction(23 downto 16)
		 );
		 
instructionReg15to8: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => i_hazard,
			  CLK => G_clock,
			  INPUT => i_instruction(15 downto 8),
			  OUTPUT => o_instruction(15 downto 8)
		 );
		 
instructionReg7to0: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => i_hazard,
			  CLK => G_clock,
			  INPUT => i_instruction(7 downto 0),
			  OUTPUT => o_instruction(7 downto 0)
		 );
		 
instructionCountReg: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => i_hazard,
			  CLK => G_clock,
			  INPUT => i_instructionCount,
			  OUTPUT => o_instructionCount
		 );


END structure;