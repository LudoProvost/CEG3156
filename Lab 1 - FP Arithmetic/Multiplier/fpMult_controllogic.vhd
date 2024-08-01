library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fpMult_controllogic is
  Port (
    Start, CLK: in std_logic;
    Qout, M_R_LSB, M_R_MSB, count, V: in std_logic;
    Esel: out std_logic_vector(1 downto 0);
    Msel, M_Asel, Qsel: out std_logic;
    loadE_R, loadUH, loadLH, loadM_A, loadQ, loadC: out std_logic;
    shiftL, AshiftR, inc: out std_logic
  );
end fpMult_controllogic;

architecture struct of fpMult_controllogic is
    signal s0, s0_bar: std_logic;
	signal s1, s1_bar: std_logic;
	signal s2, s2_bar: std_logic;
	signal s3, s3_bar: std_logic;
	signal s4, s4_bar: std_logic;
	signal s5, s5_bar: std_logic;
	signal s6, s6_bar: std_logic;
    signal DFF0IN, DFF1IN, DFF2IN, DFF3IN, DFF4IN, DFF5IN, DFF6IN: std_logic;
begin
    DFF0IN <= Start;
    DFF1IN <= s0;
--    DFFBUFIN <= (Qout xor M_R_LSB) and ((s3 and not(count)) or (s1 and not(V)));
    DFF2IN <= (Qout xor M_R_LSB) and ((s3 and not(count)) or (s1 and not(V)));
    DFF3IN <= s2 or ((Qout xnor M_R_LSB) and ((s3 and not(count)) or (s1 and not(V))));
    DFF4IN <= not(M_R_MSB) and ((s3 and count) or s4);
    DFF5IN <= M_R_MSB and ((s3 and count) or s4);
    DFF6IN <= s5 or (s1 and V);

    DFF0: entity work.enARdFF_2(struct)
        port map(s0, DFF0IN, '1', CLK, s0, s0_bar);
    
    DFF1: entity work.enARdFF_2(struct)
        port map(s0, DFF1IN, '1', CLK, s1, s1_bar);
        
    DFF2: entity work.enARdFF_2(struct)
        port map(s0, DFF2IN, '1', CLK, s2, s2_bar);

    DFF3: entity work.enARdFF_2(struct)
        port map(s0, DFF3IN, '1', CLK, s3, s3_bar);

    DFF4: entity work.enARdFF_2(struct)
        port map(s0, DFF4IN, '1', CLK, s4, s4_bar);
    
    DFF5: entity work.enARdFF_2(struct)
        port map(s0, DFF5IN, '1', CLK, s5, s5_bar);

    DFF6: entity work.enARdFF_2(struct)
        port map(s0, DFF6IN, '1', CLK, s6, s6_bar);

    -- outputs
    Esel(1) <= s0;
    Esel(0) <= s0 or s4;
    Msel    <= s0 or s1;            -- s1 ADDED BECAUSE OF GLITCH (to see glitch, remove "or s1" and step at 100ns in sim.
    M_Asel  <= M_R_LSB and s2;
    Qsel    <= s0;
    loadE_R <= s0 or s1 or s4;
    loadUH  <= s0 or s2 or s3 or s4 or s5;
    loadLH  <= s0 or s3 or s4 or s5;
    loadM_A <= s0;
    loadQ   <= s0 or s3;
    loadC   <= s0 or s3;
    shiftL  <= s4 or s5;
    AshiftR <= s3;      -- added sbuf
    inc     <= s3;      -- added sbuf
    
end ;
