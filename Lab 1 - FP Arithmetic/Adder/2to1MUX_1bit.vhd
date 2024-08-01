-- 1 bit 2-to-1 MUX
-- Written by: Louis Marleau
-- 05/16/2024

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY 2to1MUX_1bit IS
    PORT( x : IN STD_LOGIC;
        y : IN STD_LOGIC;
        s : IN STD_LOGIC;
        m : OUT STD_LOGIC);
END 2to1MUX_1bit;

ARCHITECTURE Structure OF 2to1MUX_1bit IS
BEGIN
    m <= (NOT(s) AND x) OR (s AND y);

END Structure;