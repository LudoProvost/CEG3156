library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity complementer_10b is
 Port (
    A: in std_logic_vector(9 downto 0);
    OUT1: out std_logic_vector(9 downto 0)
 );
end complementer_10b;

architecture struct of complementer_10b is
begin
    OUT1(0) <= A(0) xor '1';
    OUT1(1) <= A(1) xor '1';
    OUT1(2) <= A(2) xor '1';
    OUT1(3) <= A(3) xor '1';
    OUT1(4) <= A(4) xor '1';
    OUT1(5) <= A(5) xor '1';
    OUT1(6) <= A(6) xor '1';
    OUT1(7) <= A(7) xor '1';
    OUT1(8) <= A(8) xor '1';
    OUT1(9) <= A(9) xor '1';
end ;