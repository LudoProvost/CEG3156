library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX8to1_32b is
    Port ( a : in  STD_LOGIC_VECTOR(31 downto 0);
           b : in  STD_LOGIC_VECTOR(31 downto 0);
           c : in  STD_LOGIC_VECTOR(31 downto 0);
           d : in  STD_LOGIC_VECTOR(31 downto 0);
           e : in  STD_LOGIC_VECTOR(31 downto 0);
           f : in  STD_LOGIC_VECTOR(31 downto 0);
           g : in  STD_LOGIC_VECTOR(31 downto 0);
           h : in  STD_LOGIC_VECTOR(31 downto 0);
           sel : in  STD_LOGIC_VECTOR(2 downto 0);
           y : out  STD_LOGIC_VECTOR(31 downto 0));
end MUX8to1_32b;

architecture struct of MUX8to1_32b is

    component MUX2to1_32b
        Port ( a : in  STD_LOGIC_VECTOR(31 downto 0);
               b : in  STD_LOGIC_VECTOR(31 downto 0);
               sel : in  STD_LOGIC;
               y : out  STD_LOGIC_VECTOR(31 downto 0));
    end component;

    signal mux_out0, mux_out1, mux_out2, mux_out3, mux_out4, mux_out5 : STD_LOGIC_VECTOR(31 downto 0);

begin

    in1: MUX2to1_32b port map (a => a, b => b, sel => sel(0), y => mux_out0);
    in2: MUX2to1_32b port map (a => c, b => d, sel => sel(0), y => mux_out1);
    in3: MUX2to1_32b port map (a => e, b => f, sel => sel(0), y => mux_out2);
    in4: MUX2to1_32b port map (a => g, b => h, sel => sel(0), y => mux_out3);

    in5: MUX2to1_32b port map (a => mux_out0, b => mux_out1, sel => sel(1), y => mux_out4);
    in6: MUX2to1_32b port map (a => mux_out2, b => mux_out3, sel => sel(1), y => mux_out5);

    in7: MUX2to1_32b port map (a => mux_out4, b => mux_out5, sel => sel(2), y => y);

end struct;