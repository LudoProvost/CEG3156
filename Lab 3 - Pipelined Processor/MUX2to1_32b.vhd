library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX2to1_32b is
    Port ( a : in  STD_LOGIC_VECTOR(31 downto 0);
           b : in  STD_LOGIC_VECTOR(31 downto 0);
           sel : in  STD_LOGIC;
           y : out  STD_LOGIC_VECTOR(31 downto 0));
end MUX2to1_32b;

architecture RTL of MUX2to1_32b is
begin
    y <= a when sel = '0' else b;
end RTL;