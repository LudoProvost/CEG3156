library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_10b is
 Port (
    A, B: in std_logic_vector(9 downto 0);
    Cin: in std_logic;
    sum: out std_logic_vector(9 downto 0)
 );
end adder_10b;

architecture struct of adder_10b is
    signal Csignal: std_logic_vector(9 downto 0);
begin
    FA0: entity work.FullAdder(structural)
        port map(A(0), B(0), Cin, sum(0), Csignal(0));
    FA1: entity work.FullAdder(structural)
        port map(A(1), B(1), Csignal(0), sum(1), Csignal(1));
    FA2: entity work.FullAdder(structural)
        port map(A(2), B(2), Csignal(1), sum(2), Csignal(2));
    FA3: entity work.FullAdder(structural)
        port map(A(3), B(3), Csignal(2), sum(3), Csignal(3));
    FA4: entity work.FullAdder(structural)
        port map(A(4), B(4), Csignal(3), sum(4), Csignal(4));
    FA5: entity work.FullAdder(structural)
        port map(A(5), B(5), Csignal(4), sum(5), Csignal(5));
    FA6: entity work.FullAdder(structural)
        port map(A(6), B(6), Csignal(5), sum(6), Csignal(6));
    FA7: entity work.FullAdder(structural)
        port map(A(7), B(7), Csignal(6), sum(7), Csignal(7));
    FA8: entity work.FullAdder(structural)
        port map(A(8), B(8), Csignal(7), sum(8), Csignal(8));
    FA9: entity work.FullAdder(structural)
        port map(A(9), B(9), Csignal(8), sum(9), Csignal(9));    
        
end ;
