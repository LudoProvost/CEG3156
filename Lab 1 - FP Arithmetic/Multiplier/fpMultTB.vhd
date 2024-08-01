
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fpMultTB is
end fpMultTB;

architecture Behavioral of fpMultTB is
    signal CLK: std_logic;
    signal Start: std_logic := '1';
    
    signal SignA, SignB, SignOut, Overflow: std_logic;
    signal MantissaA, MantissaB, MantissaOut: std_logic_vector(7 downto 0);
    signal ExponentA, ExponentB, ExponentOut: std_logic_vector(6 downto 0);
begin


    -- clock
    CLK_process: process is
    begin

        CLK <= '0';
        wait for 50 ns;
        CLK <= '1';
        wait for 50 ns;
    end process;

    Start <= '0' after 100 ns;
    
    SignA <= '1';
    SignB <= '0';
    -- (-0.375 * 0.40625 = -0.15234375)
--    MantissaA <= "10000000";
--    MantissaB <= "10100000";
--    ExponentA <= "0111101";
--    ExponentB <= "0111101";
    
    -- (0.125 * 0.625 = 0.078125)
--    MantissaA <= "00000000";
--    MantissaB <= "01000000";
--    ExponentA <= "0111100";
--    ExponentB <= "0111110";
    
    -- (-0.666015625 * -0.796875 = 0.53073120117) -> it will be rounded to 0.529296875 ==> (1 + .00001111) * 2^(62-63)
    MantissaA <= "01010101";
    MantissaB <= "10011000";
    ExponentA <= "0111110";
    ExponentB <= "0111110";
    
    fpMult: entity work.fpMult(struct)
        port map(CLK, Start, SignA, SignB, MantissaA, MantissaB, ExponentA, ExponentB, Signout, Overflow, MantissaOut, ExponentOut);
    
end Behavioral;
