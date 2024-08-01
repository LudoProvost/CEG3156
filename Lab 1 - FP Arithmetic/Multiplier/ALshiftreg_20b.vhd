library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Right shift register
-- If using this as a counter, SHIFTR is INC.
entity ARandLShiftReg_20b is
    port(
        LOADUH, LOADLH, ASHIFTR, SHIFTL, CLK: in std_logic;
        INPUTUH, INPUTLH: in std_logic_vector(9 downto 0);
        MSB, LSB: out std_logic;
        UH: out std_logic_vector(9 downto 0)
    );
end ARandLShiftReg_20b;

architecture struct of ARandLShiftReg_20b is
    signal signalENDFF: std_logic_vector(19 downto 0);
    signal signalMUX: std_logic_vector(19 downto 0);
    signal signalQAshiftR: std_logic_vector(19 downto 0);
    signal signalQshiftL: std_logic_vector(19 downto 0);
    signal signalInput: std_logic_vector(19 downto 0);
begin
    -- Arithmetic shift right signal logic
    signalQAshiftR(18 downto 0) <= signalENDFF(19 downto 1);
    signalQAshiftR(19) <= signalENDFF(19);

    -- Merge to 20 bit input
    signalInput(19 downto 10) <= INPUTUH;
    signalInput(9 downto 0) <= INPUTLH;

    -- Shift left signal logic
    signalQshiftL(19 downto 1) <= signalENDFF(18 downto 0);
    signalQshiftL(0) <= '0';

    ENDFF_0: entity work.ENDFF(struct)
        port map(signalMUX(0), LOADLH, CLK, signalENDFF(0));
    ENDFF_1: entity work.ENDFF(struct)
        port map(signalMUX(1), LOADLH, CLK, signalENDFF(1));
    ENDFF_2: entity work.ENDFF(struct)
        port map(signalMUX(2), LOADLH, CLK, signalENDFF(2));
    ENDFF_3: entity work.ENDFF(struct)
        port map(signalMUX(3), LOADLH, CLK, signalENDFF(3));
    ENDFF_4: entity work.ENDFF(struct)
        port map(signalMUX(4), LOADLH, CLK, signalENDFF(4));
    ENDFF_5: entity work.ENDFF(struct)
        port map(signalMUX(5), LOADLH, CLK, signalENDFF(5));
    ENDFF_6: entity work.ENDFF(struct)
        port map(signalMUX(6), LOADLH, CLK, signalENDFF(6));
    ENDFF_7: entity work.ENDFF(struct)
        port map(signalMUX(7), LOADLH, CLK, signalENDFF(7));
    ENDFF_8: entity work.ENDFF(struct)
        port map(signalMUX(8), LOADLH, CLK, signalENDFF(8));
    ENDFF_9: entity work.ENDFF(struct)
        port map(signalMUX(9), LOADLH, CLK, signalENDFF(9));
    ENDFF_10: entity work.ENDFF(struct)
        port map(signalMUX(10), LOADUH, CLK, signalENDFF(10));
    ENDFF_11: entity work.ENDFF(struct)
        port map(signalMUX(11), LOADUH, CLK, signalENDFF(11));
    ENDFF_12: entity work.ENDFF(struct)
        port map(signalMUX(12), LOADUH, CLK, signalENDFF(12));
    ENDFF_13: entity work.ENDFF(struct)
        port map(signalMUX(13), LOADUH, CLK, signalENDFF(13));
    ENDFF_14: entity work.ENDFF(struct)
        port map(signalMUX(14), LOADUH, CLK, signalENDFF(14));
    ENDFF_15: entity work.ENDFF(struct)
        port map(signalMUX(15), LOADUH, CLK, signalENDFF(15));
    ENDFF_16: entity work.ENDFF(struct)
        port map(signalMUX(16), LOADUH, CLK, signalENDFF(16));
    ENDFF_17: entity work.ENDFF(struct)
        port map(signalMUX(17), LOADUH, CLK, signalENDFF(17));
    ENDFF_18: entity work.ENDFF(struct)
        port map(signalMUX(18), LOADUH, CLK, signalENDFF(18));
    ENDFF_19: entity work.ENDFF(struct)
        port map(signalMUX(19), LOADUH, CLK, signalENDFF(19));
    
    
    -- SHIFTR is the select to determine the register's input
    -- OUTPUT <= right shifted signal if SHIFTR is 1
    -- OUTPUT <= INPUT signal if SHIFTR is 0
    MUX4to1_20b: entity work.MUX4to1_20b(struct)
        port map(signalInput, signalQAshiftR, signalQshiftL, "00000000000000000000", ASHIFTR, SHIFTL, signalMUX);
    
    MSB <= signalENDFF(19);
    LSB <= signalENDFF(0);
    UH <= signalENDFF(19 downto 10);
end struct;