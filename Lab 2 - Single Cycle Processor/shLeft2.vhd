LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY shLeft2 is
	PORT(input : IN STD_LOGIC_VECTOR(7 downto 0);
		  output : OUT STD_LOGIC_VECTOR(7 downto 0)
			);
			
END shLeft2;

ARCHITECTURE struct OF shLeft2 IS

BEGIN

	output(7) <= input(5);
	output(6) <= input(4);
	output(5) <= input(3);
	output(4) <= input(2);
	output(3) <= input(1);
	output(2) <= input(0);
	output(1) <= '0';
	output(0) <= '0';

END struct;