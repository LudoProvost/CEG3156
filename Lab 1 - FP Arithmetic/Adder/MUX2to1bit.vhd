LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Simple module that connects the SW switches to the LEDR lights
ENTITY MUX2to1bit IS
    PORT( x : IN STD_LOGIC;
        y : IN STD_LOGIC;
        s : IN STD_LOGIC;
        m : OUT STD_LOGIC);
END MUX2to1bit;

ARCHITECTURE Behavior OF MUX2to1bit IS
BEGIN
    m <= (NOT(s) AND x) OR (s AND y);

END Behavior;