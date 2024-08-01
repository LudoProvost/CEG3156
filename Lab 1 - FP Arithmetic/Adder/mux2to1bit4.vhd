LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Simple module that connects the SW switches to the LEDR lights
ENTITY mux2to1bit4 IS
    PORT( x : IN STD_LOGIC_VECTOR(3 downto 0);
        y : IN STD_LOGIC_VECTOR(3 downto 0);
        s : IN STD_LOGIC;
        m : OUT STD_LOGIC_VECTOR(3 downto 0));
END mux2to1bit4;

ARCHITECTURE Behavior OF mux2to1bit4 IS
BEGIN
    m(0) <= (NOT(s) AND x(0)) OR (s AND y(0));
    m(1) <= (NOT(s) AND x(1)) OR (s AND y(1));
    m(2) <= (NOT(s) AND x(2)) OR (s AND y(2));
    m(3) <= (NOT(s) AND x(3)) OR (s AND y(3));

END Behavior;