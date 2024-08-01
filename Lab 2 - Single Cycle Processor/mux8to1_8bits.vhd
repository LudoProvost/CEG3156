LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux8to1_8bits IS
	PORT( a, b, c, d, e, f, g, h : IN STD_LOGIC_VECTOR(7 downto 0);
			sel : IN STD_LOGIC_VECTOR(2 downto 0);
			output : OUT STD_LOGIC_VECTOR(7 downto 0)
			);
	
END mux8to1_8bits;

ARCHITECTURE structural OF mux8to1_8bits IS
	
	SIGNAL s, o : STD_LOGIC_VECTOR(7 downto 0);
		
BEGIN
	--- Select
	s(0) <=  not(sel(2) or sel(1) or sel(0));
	s(1) <=  not(sel(2)) and not(sel(1)) and sel(0);
	s(2) <=  not(sel(2)) and sel(1) and not(sel(0));
	s(3) <=  not(sel(2)) and sel(1) and sel(0);
	s(4) <=  sel(2) and not(sel(1)) and not(sel(0));
	s(5) <=  sel(2) and not(sel(1)) and sel(0);
	s(6) <=  sel(2) and sel(1) and not(sel(0));
	s(7) <=  sel(2) and sel(1) and sel(0);
	
	--- Multiplexer
	
	o(0) <= (a(0) and s(0)) or (b(0) and s(1)) or (c(0) and s(2)) or (d(0) and s(3)) or (e(0) and s(4)) or (f(0) and s(5)) or (g(0) and s(6)) or (h(0) and s(7));
	o(1) <= (a(1) and s(0)) or (b(1) and s(1)) or (c(1) and s(2)) or (d(1) and s(3)) or (e(1) and s(4)) or (f(1) and s(5)) or (g(1) and s(6)) or (h(1) and s(7));
	o(2) <= (a(2) and s(0)) or (b(2) and s(1)) or (c(2) and s(2)) or (d(2) and s(3)) or (e(2) and s(4)) or (f(2) and s(5)) or (g(2) and s(6)) or (h(2) and s(7));
	o(3) <= (a(3) and s(0)) or (b(3) and s(1)) or (c(3) and s(2)) or (d(3) and s(3)) or (e(3) and s(4)) or (f(3) and s(5)) or (g(3) and s(6)) or (h(3) and s(7));
	o(4) <= (a(4) and s(0)) or (b(4) and s(1)) or (c(4) and s(2)) or (d(4) and s(3)) or (e(4) and s(4)) or (f(4) and s(5)) or (g(4) and s(6)) or (h(4) and s(7));
	o(5) <= (a(5) and s(0)) or (b(5) and s(1)) or (c(5) and s(2)) or (d(5) and s(3)) or (e(5) and s(4)) or (f(5) and s(5)) or (g(5) and s(6)) or (h(5) and s(7));
	o(6) <= (a(6) and s(0)) or (b(6) and s(1)) or (c(6) and s(2)) or (d(6) and s(3)) or (e(6) and s(4)) or (f(6) and s(5)) or (g(6) and s(6)) or (h(6) and s(7));
	o(7) <= (a(7) and s(0)) or (b(7) and s(1)) or (c(7) and s(2)) or (d(7) and s(3)) or (e(7) and s(4)) or (f(7) and s(5)) or (g(7) and s(6)) or (h(7) and s(7));
	
	--- Output Driver
	
	output <= o;
	
END structural;