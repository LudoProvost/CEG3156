library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2to1_2Sel_5b is
  Port (
    IN1, IN2: in std_logic_vector(4 downto 0);
    Sel1, Sel2: in std_logic;
    OUT1: out std_logic_vector(4 downto 0)
  );
end MUX2to1_2Sel_5b;

architecture struct of MUX2to1_2Sel_5b is

begin
	 OUT1(4) <= (Sel1 and IN1(4)) or (Sel2 and IN2(4));
    OUT1(3) <= (Sel1 and IN1(3)) or (Sel2 and IN2(3));
    OUT1(2) <= (Sel1 and IN1(2)) or (Sel2 and IN2(2));
    OUT1(1) <= (Sel1 and IN1(1)) or (Sel2 and IN2(1));
    OUT1(0) <= (Sel1 and IN1(0)) or (Sel2 and IN2(0));
end struct;