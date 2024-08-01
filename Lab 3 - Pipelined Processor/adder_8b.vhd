library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_8b is
 Port (
    A, B: in std_logic_vector(7 downto 0);
    Cin: in std_logic;
    sum: out std_logic_vector(7 downto 0)
 );
end adder_8b;

architecture struct of adder_8b is
    signal Csignal: std_logic_vector(7 downto 0);
    signal SumSignal: std_logic_vector(7 downto 0);
begin
    FA0: entity work.FullAdder(structural)
        port map(A(0), B(0), Cin, SumSignal(0), Csignal(0));
    FA1: entity work.FullAdder(structural)
        port map(A(1), B(1), Csignal(0), SumSignal(1), Csignal(1));
    FA2: entity work.FullAdder(structural)
        port map(A(2), B(2), Csignal(1), SumSignal(2), Csignal(2));
    FA3: entity work.FullAdder(structural)
        port map(A(3), B(3), Csignal(2), SumSignal(3), Csignal(3));
    FA4: entity work.FullAdder(structural)
        port map(A(4), B(4), Csignal(3), SumSignal(4), Csignal(4));
    FA5: entity work.FullAdder(structural)
        port map(A(5), B(5), Csignal(4), SumSignal(5), Csignal(5));
    FA6: entity work.FullAdder(structural)
        port map(A(6), B(6), Csignal(5), SumSignal(6), Csignal(6));
    FA7: entity work.FullAdder(structural)
        port map(A(7), B(7), Csignal(6), SumSignal(7), Csignal(7));  
        
    sum <= SumSignal;
end ;