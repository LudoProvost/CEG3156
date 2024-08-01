library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor_8b is
  Port ( 
    B: in std_logic_vector(7 downto 0);
    comparator: in std_logic;
    xorout: out std_logic_vector(7 downto 0)
  );
end xor_8b;

architecture struct of xor_8b is
    
begin
    xorout(7) <= B(7) xor comparator;
    xorout(6) <= B(6) xor comparator;
    xorout(5) <= B(5) xor comparator;
    xorout(4) <= B(4) xor comparator;
    xorout(3) <= B(3) xor comparator;
    xorout(2) <= B(2) xor comparator;
    xorout(1) <= B(1) xor comparator;
    xorout(0) <= B(0) xor comparator;
    
end struct;
