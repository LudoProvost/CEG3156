library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Right shift register
-- If using this as a counter, SHIFTR is INC.
entity RShiftReg_10b is
    port(
        LOAD, SHIFTR, CLK: in std_logic;
        INPUT: in std_logic_vector(9 downto 0);
        OUTPUT: out std_logic
    );
end RShiftReg_10b;

architecture struct of RShiftReg_10b is
    signal signalENDFF: std_logic_vector(9 downto 0);
    signal signalMUX: std_logic_vector(9 downto 0);
    signal signalQshift: std_logic_vector(9 downto 0);
begin
    -- Shift signal logic
    signalQshift(8 downto 0) <= signalENDFF(9 downto 1);
    signalQshift(9) <= '0';

    ENDFF_0: entity work.ENDFF(struct)
        port map(signalMUX(0), LOAD, CLK, signalENDFF(0));
    ENDFF_1: entity work.ENDFF(struct)
        port map(signalMUX(1), LOAD, CLK, signalENDFF(1));
    ENDFF_2: entity work.ENDFF(struct)
        port map(signalMUX(2), LOAD, CLK, signalENDFF(2));
    ENDFF_3: entity work.ENDFF(struct)
        port map(signalMUX(3), LOAD, CLK, signalENDFF(3));
    ENDFF_4: entity work.ENDFF(struct)
        port map(signalMUX(4), LOAD, CLK, signalENDFF(4));
    ENDFF_5: entity work.ENDFF(struct)
        port map(signalMUX(5), LOAD, CLK, signalENDFF(5));
    ENDFF_6: entity work.ENDFF(struct)
        port map(signalMUX(6), LOAD, CLK, signalENDFF(6));
    ENDFF_7: entity work.ENDFF(struct)
        port map(signalMUX(7), LOAD, CLK, signalENDFF(7));
    ENDFF_8: entity work.ENDFF(struct)
        port map(signalMUX(8), LOAD, CLK, signalENDFF(8));
    ENDFF_9: entity work.ENDFF(struct)
        port map(signalMUX(9), LOAD, CLK, signalENDFF(9));
    
    -- SHIFTR is the select to determine the register's input
    -- OUTPUT <= right shifted signal if SHIFTR is 1
    -- OUTPUT <= INPUT signal if SHIFTR is 0
    MUX2to1_10b: entity work.MUX2to1_10b(struct)
        port map(INPUT, signalQshift, SHIFTR, signalMUX);
    OUTPUT <= signalENDFF(0);
end struct;

----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Right shift register
-- If using this as a counter, SHIFTR is INC.
entity RShiftReg_11b is
    port(
        LOAD, SHIFTR, CLK: in std_logic;
        INPUT: in std_logic_vector(10 downto 0);
        OUTPUT: out std_logic
    );
end RShiftReg_11b;

architecture struct of RShiftReg_11b is
    signal signalENDFF: std_logic_vector(10 downto 0);
    signal signalMUX: std_logic_vector(10 downto 0);
    signal signalQshift: std_logic_vector(10 downto 0);
begin
    -- Shift signal logic
    signalQshift(9 downto 0) <= signalENDFF(10 downto 1);
    signalQshift(10) <= '0';

    ENDFF_0: entity work.ENDFF(struct)
        port map(signalMUX(0), LOAD, CLK, signalENDFF(0));
    ENDFF_1: entity work.ENDFF(struct)
        port map(signalMUX(1), LOAD, CLK, signalENDFF(1));
    ENDFF_2: entity work.ENDFF(struct)
        port map(signalMUX(2), LOAD, CLK, signalENDFF(2));
    ENDFF_3: entity work.ENDFF(struct)
        port map(signalMUX(3), LOAD, CLK, signalENDFF(3));
    ENDFF_4: entity work.ENDFF(struct)
        port map(signalMUX(4), LOAD, CLK, signalENDFF(4));
    ENDFF_5: entity work.ENDFF(struct)
        port map(signalMUX(5), LOAD, CLK, signalENDFF(5));
    ENDFF_6: entity work.ENDFF(struct)
        port map(signalMUX(6), LOAD, CLK, signalENDFF(6));
    ENDFF_7: entity work.ENDFF(struct)
        port map(signalMUX(7), LOAD, CLK, signalENDFF(7));
    ENDFF_8: entity work.ENDFF(struct)
        port map(signalMUX(8), LOAD, CLK, signalENDFF(8));
    ENDFF_9: entity work.ENDFF(struct)
        port map(signalMUX(9), LOAD, CLK, signalENDFF(9));
    ENDFF_10: entity work.ENDFF(struct)
        port map(signalMUX(10), LOAD, CLK, signalENDFF(10));
    
    -- SHIFTR is the select to determine the register's input
    -- OUTPUT <= right shifted signal if SHIFTR is 1
    -- OUTPUT <= INPUT signal if SHIFTR is 0
    MUX2to1_11b: entity work.MUX2to1_11b(struct)
        port map(INPUT, signalQshift, SHIFTR, signalMUX);
    OUTPUT <= signalENDFF(0);
end struct;