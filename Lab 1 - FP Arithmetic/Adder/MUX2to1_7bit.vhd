-- 7 bit 2-to-1 MUX
-- Written by: Louis Marleau
-- 05/16/2024

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MUX2to1_7bit IS
    PORT( x : IN STD_LOGIC_VECTOR(6 downto 0);
        y : IN STD_LOGIC_VECTOR(6 downto 0);
        s : IN STD_LOGIC;
        m : OUT STD_LOGIC_VECTOR(6 downto 0));
END MUX2to1_7bit;

ARCHITECTURE Structure OF MUX2to1_7bit IS
BEGIN
    m(0) <= (NOT(s) AND x(0)) OR (s AND y(0));
    m(1) <= (NOT(s) AND x(1)) OR (s AND y(1));
    m(2) <= (NOT(s) AND x(2)) OR (s AND y(2));
    m(3) <= (NOT(s) AND x(3)) OR (s AND y(3));
	 m(4) <= (NOT(s) AND x(4)) OR (s AND y(4));
	 m(5) <= (NOT(s) AND x(5)) OR (s AND y(5));
	 m(6) <= (NOT(s) AND x(6)) OR (s AND y(6));

END Structure;