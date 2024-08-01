LIBRARY ieee;
LIBRARY lpm;

USE ieee.std_logic_1164.ALL;
USE lpm.lpm_components.all;

ENTITY dataMem is 
	PORT( data : IN STD_LOGIC_VECTOR(7 downto 0);
			addr : IN STD_LOGIC_VECTOR(7 downto 0);
			i_clock : IN STD_LOGIC;
			writeEn : IN STD_LOGIC;
			o_data : OUT STD_LOGIC_VECTOR(7 downto 0)
			);

END dataMem;

ARCHITECTURE struct OF dataMem IS

	COMPONENT lpm_ram_dq
   GENERIC (LPM_WIDTH: POSITIVE := 8;
      LPM_WIDTHAD: POSITIVE := 8;
      LPM_NUMWORDS: NATURAL := 256;
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_FILE: STRING := "C:\Users\Ludovic Provost\Desktop\2024 SUMMER\CEG3156\Labs\Lab2\modelsim_try1\work\ramMif.mif";
      LPM_TYPE: STRING := "LPM_RAM_DQ";
      LPM_HINT: STRING := "UNUSED");
    PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      inclock, outclock: IN STD_LOGIC := '0';
      we: IN STD_LOGIC;
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
	
BEGIN

ram: lpm_ram_dq
	PORT MAP(data => data,
				address => addr,
				inclock => i_clock,
				outclock => i_clock,
				we => writeEn,
				q => o_data
				 );
	
END struct;