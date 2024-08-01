
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fpMult is
  Port (
    CLK, Start: in std_logic;
    SignA, SignB: in std_logic;
    MantissaA, MantissaB: in std_logic_vector(7 downto 0);
    ExponentA, ExponentB: in std_logic_vector(6 downto 0);
    SignOut, Overflow: out std_logic;
    MantissaOut: out std_logic_vector(7 downto 0);
    ExponentOut: out std_logic_vector(6 downto 0)
  );
end fpMult;

architecture struct of fpMult is
    signal Esel: std_logic_vector(1 downto 0);
    signal Msel, M_Asel, Qsel: std_logic;
    signal loadE_R, loadUH, loadLH, loadM_A, loadQ, loadC: std_logic;
    signal shiftL, AshiftR, inc: std_logic;
    signal Qout, M_R_LSB, M_R_MSB, count, V: std_logic;
    
    signal invertedCLK: std_logic;

begin
    invertedCLK <= not(CLK);


    Datapath: entity work.fpMult_datapath(struct)
        port map(invertedCLK, 
                SignA, SignB, MantissaA, MantissaB, ExponentA, ExponentB, 
                Esel, Msel, M_Asel, Qsel, 
                loadE_R, loadUH, loadLH, loadM_A, loadQ, loadC, 
                shiftL, AshiftR, inc,
                Qout, M_R_LSB, M_R_MSB, count, V,
                SignOut, ExponentOut, MantissaOut);

    ControlLogic: entity work.fpMult_controllogic(struct)
        port map(Start, CLK,
                Qout, M_R_LSB, M_R_MSB, count, V,
                Esel, Msel, M_Asel, Qsel,
                loadE_R, loadUH, loadLH, loadM_A, loadQ, loadC, 
                shiftL, AshiftR, inc);
    
    Overflow <= V;
        
end ;
