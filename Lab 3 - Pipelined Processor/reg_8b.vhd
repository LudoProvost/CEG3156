library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- input and output are 7 bit std_logic_vectors
-- LOAD is given as the EN signal for the enARdFF_2
-- SEL signal is on when the register is selected to be loaded, as load input is shared by all registers
entity reg_8b is
    port(
        i_reset, SEL, LOAD, CLK: in std_logic;
        INPUT: in std_logic_vector(7 downto 0);
        OUTPUT: out std_logic_vector(7 downto 0)
    );
end reg_8b;

architecture struct OF reg_8b is
    signal signalENARDFF: std_logic_vector(7 downto 0);
    signal loadSelect: std_logic;
begin
    loadSelect <= SEL and LOAD;

    ENARDFF_0: entity work.enARdFF_2(rtl)
        port map(i_reset, INPUT(0), loadSelect, CLK, signalENARDFF(0));
     ENARDFF_1: entity work.enARdFF_2(rtl)
        port map(i_reset, INPUT(1), loadSelect, CLK, signalENARDFF(1));
     ENARDFF_2: entity work.enARdFF_2(rtl)
        port map(i_reset, INPUT(2), loadSelect, CLK, signalENARDFF(2));
     ENARDFF_3: entity work.enARdFF_2(rtl)
        port map(i_reset, INPUT(3), loadSelect, CLK, signalENARDFF(3));
     ENARDFF_4: entity work.enARdFF_2(rtl)
        port map(i_reset, INPUT(4), loadSelect, CLK, signalENARDFF(4));
     ENARDFF_5: entity work.enARdFF_2(rtl)
        port map(i_reset, INPUT(5), loadSelect, CLK, signalENARDFF(5));
     ENARDFF_6: entity work.enARdFF_2(rtl)
        port map(i_reset, INPUT(6), loadSelect, CLK, signalENARDFF(6));
     ENARDFF_7: entity work.enARdFF_2(rtl)
        port map(i_reset, INPUT(7), loadSelect, CLK, signalENARDFF(7));
    OUTPUT <= signalENARDFF;
end struct;