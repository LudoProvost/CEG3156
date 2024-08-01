library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fpMult_datapath is
  Port (
    CLK: in std_logic;
    SignA, SignB: in std_logic;
    MantissaA, MantissaB: in std_logic_vector(7 downto 0);
    ExponentA, ExponentB: in std_logic_vector(6 downto 0);
    Esel: in std_logic_vector(1 downto 0);
    Msel, M_Asel, Qsel: in std_logic;
    loadE_R, loadUH, loadLH, loadM_A, loadQ, loadC: in std_logic;
    shiftL, AshiftR, inc: in std_logic;
    Qout, M_R_LSB, M_R_MSB, count, V: out std_logic;
    SignOut: out std_logic;
    ExponentOut: out std_logic_vector(6 downto 0);
    MantissaOut: out std_logic_vector(7 downto 0)
  );
end fpMult_datapath;

architecture struct of fpMult_datapath is
    signal ExponentRegOut, ExpAdderMuxOut1, ExpAdderMuxOut2, ExpAdderOut: std_logic_vector(7 downto 0);     -- CHANGED SIZE OF VECTOR 
    signal MSelOut, MantissaResultRegOut, MantissaARegOut, CompOut, M_ASelOut, MantissaAdderOut, ImplicitMantissaB, ImplicitMantissaA: std_logic_vector(9 downto 0);
    signal QSelOut, MantissaResultMSB, MantissaResultLSB, CountLSB, QRegOut, Vout: std_logic;
    
    signal SignExtendedExponentA, SignExtendedExponentB: std_logic_vector(7 downto 0);
begin
    -- define sign extended exponents
    SignExtendedExponentA(7) <= ExponentA(6);
    SignExtendedExponentA(6 downto 0) <= ExponentA(6 downto 0);
    SignExtendedExponentB(7) <= ExponentB(6);
    SignExtendedExponentB(6 downto 0) <= ExponentB(6 downto 0);

    -- define implicit mantissa signals
    ImplicitMantissaB(9 downto 8) <= "01";
    ImplicitMantissaB(7 downto 0) <= MantissaB;
    ImplicitMantissaA(9 downto 8) <= "01";
    ImplicitMantissaA(7 downto 0) <= MantissaA;
    
    ExponentReg: entity work.reg_8b(struct)                 --CHANGED
        port map(loadE_R, CLK, ExpAdderOut, ExponentRegOut);
        
    MantissaResultReg: entity work.ARandLShiftReg_20b(struct)
        port map(loadUH, loadLH, AshiftR, shiftL, CLK, MSelOut, ImplicitMantissaB, MantissaResultMSB, MantissaResultLSB, MantissaResultRegOut);
        
    MantissaAReg: entity work.reg_10b(struct)
        port map(loadM_A, CLK, ImplicitMantissaA, MantissaARegOut);
    
    Counter: entity work.RShiftReg_11b(struct)
        port map(loadC, inc, CLK, "10000000000", CountLSB);
        
    QReg: entity work.ENDFF(struct)
        port map(QSelOut, loadQ, CLK, QRegOut);
    
    MSelMUX: entity work.MUX2to1_10b(struct)
        port map(MantissaAdderOut, "0000000000", Msel, MSelOut);
    
    M_ASelMUX: entity work.MUX2to1_10b(struct)
        port map(MantissaARegOut, CompOut, M_Asel, M_ASelOut);
    
    QSelMUX: entity work.MUX2to1_1b(struct)
        port map(MantissaResultLSB, '0', Qsel, QSelOut);
    
    Complementer: entity work.complementer_10b(struct)
        port map(MantissaARegOut, CompOut);
        
    ExpAdderMux1: entity work.MUX2to1_8b(struct)                  --CHANGED   
        port map(ExponentRegOut, SignExtendedExponentA, Esel(1), ExpAdderMuxOut1);
        
    -- 1000001 = -63
    -- 0000001 = +1
    -- second input is place holder, should never be used.
    ExpAdderMux2: entity work.MUX4to1_8b(struct)                 --CHANGED
        port map("11000010", "00000000", "11111111", SignExtendedExponentB, Esel(1), Esel(0), ExpAdderMuxOut2);     -- changed -63 => -62 and +1 => -1
        
    ExpAdder: entity work.adder_8b(struct)                 --CHANGED
        port map(ExpAdderMuxOut1, ExpAdderMuxOut2, '0', ExpAdderOut, Vout);
    
    MantissaAdder: entity work.adder_10b(struct)
        port map(MantissaResultRegOut, M_ASelOut, M_Asel, MantissaAdderOut);

    -- outputs
    SignOut <= SignA xor SignB;
    
    Qout        <= QRegOut;
    M_R_LSB     <= MantissaResultLSB;
    M_R_MSB     <= MantissaResultRegOut(7);                   --CHANGED, was MantissaResultMSB
    count       <= CountLSB;
    V           <= Vout;
    ExponentOut <= ExponentRegOut(6 downto 0);
    MantissaOut <= MantissaResultRegOut(7 downto 0);    --CHANGED, was MantissaResultRegOut(9 downto 2)
    
end ;
