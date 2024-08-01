LIBRARY ieee;
LIBRARY lpm;

USE ieee.std_logic_1164.ALL;
USE lpm.lpm_components.all;

ENTITY instrMem is 
	PORT( addr : IN STD_LOGIC_VECTOR(7 downto 0);
			i_clock : IN STD_LOGIC;
			instr : OUT STD_LOGIC_VECTOR(31 downto 0)
			);

END instrMem;

ARCHITECTURE struct OF instrMem IS

	COMPONENT lpm_rom
		GENERIC (LPM_WIDTH: POSITIVE := 32;
			LPM_WIDTHAD: POSITIVE:= 8;
			LPM_NUMWORDS: NATURAL := 256;
			LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
			LPM_OUTDATA: STRING := "REGISTERED";
			LPM_FILE: STRING := "romMif.mif"; 	
			LPM_TYPE: STRING := "LPM_ROM";
			LPM_HINT: STRING := "UNUSED");
		PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
			inclock, outclock: IN STD_LOGIC := '0';
			memenab: IN STD_LOGIC := '1';
			q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
	END COMPONENT;
	
BEGIN

rom: lpm_rom
	PORT MAP(address => addr,
				inclock => i_clock,
				outclock => i_clock,
				q => instr
				 );
	
END struct;