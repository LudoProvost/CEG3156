-- Full-Adder
-- Written by: Louis Marleau
-- 11/10/2023
library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdd1bit is
		port( X : in std_logic;
				Y : in std_logic;
				carryIn : in std_logic;
				sum : out std_logic;
				carryOut: out std_logic);
				
end fullAdd1bit;

ARCHITECTURE Addition of fullAdd1bit is
	SIGNAL carry1, carry2, carry3 : std_logic;
BEGIN	

		carry1 <= carryIn xor X;
		carry2 <= carry1 and Y;
		carry3 <= carryIn and X;
		
		sum <= carry1 xor Y;
		carryOut <= carry2 or carry3;
		
end Addition;

				