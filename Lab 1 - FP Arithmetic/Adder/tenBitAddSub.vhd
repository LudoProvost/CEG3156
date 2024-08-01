-- 10 bit Adder/Subtracter
-- Written by: Louis Marleau
-- 05/16/2024

library IEEE;
use IEEE.std_logic_1164.all;

entity tenBitAddSub is
	port( i_X, i_Y : in std_logic_vector(9 downto 0);
				carryIn, addSubIn : in std_logic;
				sum : out std_logic_vector(9 downto 0);
				carryOut: out std_logic);
end tenBitAddSub;

ARCHITECTURE rtl of tenBitAddSub is

	SIGNAL carry : std_logic_vector (9 downto 0); -- Ripple carry

	COMPONENT OneBitAddSub
		port( Xin : in std_logic;
				Yin : in std_logic;
				i_carry : in std_logic;
				addSub : in std_logic;
				somme : out std_logic;
				o_carry: out std_logic);
	END COMPONENT;

BEGIN
MSB: OneBitAddSub
	port map( Xin => i_X(9),
				 Yin => i_Y(9),
				 i_carry => carry(8),
				 addSub => addSubIn,
				 somme => sum(9),
				 o_carry => carryOut
				 );
				 
bit9: OneBitAddSub
	port map( Xin => i_X(8),
				 Yin => i_Y(8),
				 i_carry => carry(7),
				 addSub => addSubIn,
				 somme => sum(8),
				 o_carry => carry(8)
				 );
				 
bit8: OneBitAddSub
	port map( Xin => i_X(7),
				 Yin => i_Y(7),
				 i_carry => carry(6),
				 addSub => addSubIn,
				 somme => sum(7),
				 o_carry => carry(7)
				 );
				 
bit7: OneBitAddSub
	port map( Xin => i_X(6),
				 Yin => i_Y(6),
				 i_carry => carry(5),
				 addSub => addSubIn,
				 somme => sum(6),
				 o_carry => carry(6)
				 );

bit6: OneBitAddSub
	port map( Xin => i_X(5),
				 Yin => i_Y(5),
				 i_carry => carry(4),
				 addSub => addSubIn,
				 somme => sum(5),
				 o_carry => carry(5)
				 );

bit5: OneBitAddSub
	port map( Xin => i_X(4),
				 Yin => i_Y(4),
				 i_carry => carry(3),
				 addSub => addSubIn,
				 somme => sum(4),
				 o_carry => carry(4)
				 );
				 
bit4: OneBitAddSub
	port map( Xin => i_X(3),
				 Yin => i_Y(3),
				 i_carry => carry(2),
				 addSub => addSubIn,
				 somme => sum(3),
				 o_carry => carry(3)
				 );

bit3: OneBitAddSub
	port map( Xin => i_X(2),
				 Yin => i_Y(2),
				 i_carry => carry(1),
				 addSub => addSubIn,
				 somme => sum(2),
				 o_carry => carry(2)
				 );

bit2: OneBitAddSub
	port map( Xin => i_X(1),
				 Yin => i_Y(1),
				 i_carry => carry(0),
				 addSub => addSubIn,
				 somme => sum(1),
				 o_carry => carry(1)
				 );

LSB: OneBitAddSub
	port map( Xin => i_X(0),
				 Yin => i_Y(0),
				 i_carry => addSubIn,
				 addSub => addSubIn,
				 somme => sum(0),
				 o_carry => carry(0)
				 );


end rtl;