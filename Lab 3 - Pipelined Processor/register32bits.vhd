LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY register32bits IS
	PORT(input : IN STD_LOGIC_VECTOR(31 downto 0);
		  Clk, G_Reset, enable : IN STD_LOGIC;
		  output : OUT STD_LOGIC_VECTOR(31 downto 0)
		  );
END register32bits;

ARCHITECTURE structure OF register32bits IS

	COMPONENT reg_8b is
		 port(
			  i_reset, SEL, LOAD, CLK: in std_logic;
			  INPUT: in std_logic_vector(7 downto 0);
			  OUTPUT: out std_logic_vector(7 downto 0)
		 );
	END COMPONENT;


BEGIN

Reg31to24: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => enable,
			  CLK => Clk,
			  INPUT => input(31 downto 24),
			  OUTPUT => output(31 downto 24)
		 );

Reg23to16: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => enable,
			  CLK => Clk,
			  INPUT => input(23 downto 16),
			  OUTPUT => output(23 downto 16)
		 );
		 
Reg15to8: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => enable,
			  CLK => Clk,
			  INPUT => input(15 downto 8),
			  OUTPUT => output(15 downto 8)
		 );
		 
Reg7to0: reg_8b
		port MAP(
			  i_reset => G_Reset,
			  SEL => '1',
			  LOAD => enable,
			  CLK => Clk,
			  INPUT => input(7 downto 0),
			  OUTPUT => output(7 downto 0)
		 );

END structure;