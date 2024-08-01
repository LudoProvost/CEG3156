library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder2to4 is
  Port (
    input: in std_logic_vector(1 downto 0);
    output: out std_logic_vector(3 downto 0)
  );
end Decoder2to4;

architecture struct of Decoder2to4 is

begin
    output(3) <= input(1) and input(0);
    output(2) <= input(1) and not(input(0));
    output(1) <= not(input(1)) and input(0);
    output(0) <= not(input(1)) and not(input(0));

end struct;
