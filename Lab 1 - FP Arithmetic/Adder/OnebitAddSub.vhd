-- One bit Adder/Subtracter
-- Written by: Louis Marleau
-- 11/10/2023
library IEEE;
use IEEE.std_logic_1164.all;

entity OnebitAddSub is
		port( Xin : in std_logic;
				Yin : in std_logic;
				i_carry : in std_logic;
				addSub : in std_logic;
				somme : out std_logic;
				o_carry: out std_logic);
				
end OnebitAddSub;

ARCHITECTURE Behavior of OnebitAddSub is
	SIGNAL yinput : std_logic;
	
	COMPONENT fullAdd1bit
		port ( X : in std_logic;
				Y : in std_logic;
				carryIn : in std_logic;
				sum : out std_logic;
				carryOut: out std_logic);
				
	END COMPONENT;
	
BEGIN	

		yinput <= Yin xor addSub;
		
Adder: fullAdd1bit
	port map( X => Xin,
				  Y => yinput,
				  carryIn => i_carry,
				  sum => somme,
				  carryOut => o_carry
					);
		
end Behavior;