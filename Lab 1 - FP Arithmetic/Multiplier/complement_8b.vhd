library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity complement_8b is
 Port (
    IN1: in std_logic_vector(7 downto 0);
    OUT1: out std_logic_vector(7 downto 0)
 );
end complement_8b;

architecture struct of complement_8b is
    signal XOROUT: std_logic_vector(7 downto 0);
    signal cout: std_logic;
begin
    XORGATE: entity work.XORGATE_8b(struct)
        port map("11111111", IN1, XOROUT);
    
    adder: entity work.adder_8b(struct)
        port map("00000000", XOROUT, '1', OUT1, cout);
end ;
