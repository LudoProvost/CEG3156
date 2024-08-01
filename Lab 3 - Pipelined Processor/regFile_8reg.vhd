library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regFile_8reg is
  Port (
    CLK, RegWrite, reset: in std_logic;
    ReadReg1, ReadReg2, WriteReg: in std_logic_vector(4 downto 0);
    WriteData: in std_logic_vector(7 downto 0);
    ReadData1, ReadData2: out std_logic_vector(7 downto 0)
  );
end regFile_8reg;

architecture struct of regFile_8reg is
    signal DecIn: std_logic_vector(2 downto 0);
    signal DecOut: std_logic_vector(7 downto 0);
    signal Reg0out, Reg1out, Reg2out, Reg3out, Reg4out, Reg5out, Reg6out, Reg7out: std_logic_vector(7 downto 0);
begin
    DecIn <= WriteReg(2 downto 0); --Since we only use 8 registers, only the first 3 bits are important for decoding
    
    Decoder: entity work.Decoder3to8(struct)
        port map(DecIn, DecOut);
        
    MuxData1: entity work.mux8to1_8bits(structural)
        port map(Reg0out, Reg1out, Reg2out, Reg3out, Reg4out, Reg5out, Reg6out, Reg7out, ReadReg1(2 downto 0), ReadData1);
        
    MuxData2: entity work.mux8to1_8bits(structural)
        port map(Reg0out, Reg1out, Reg2out, Reg3out, Reg4out, Reg5out, Reg6out, Reg7out, ReadReg2(2 downto 0), ReadData2);
        
    Reg0: entity work.reg_8b(struct)
        port map(reset, DecOut(0), RegWrite, CLK, WriteData, Reg0out);
    
    Reg1: entity work.reg_8b(struct)
        port map(reset, DecOut(1), RegWrite, CLK, WriteData, Reg1out);
        
    Reg2: entity work.reg_8b(struct)
        port map(reset, DecOut(2), RegWrite, CLK, WriteData, Reg2out);
        
    Reg3: entity work.reg_8b(struct)
        port map(reset, DecOut(3), RegWrite, CLK, WriteData, Reg3out);

    Reg4: entity work.reg_8b(struct)
        port map(reset, DecOut(4), RegWrite, CLK, WriteData, Reg4out);
    
    Reg5: entity work.reg_8b(struct)
        port map(reset, DecOut(5), RegWrite, CLK, WriteData, Reg5out);
        
    Reg6: entity work.reg_8b(struct)
        port map(reset, DecOut(6), RegWrite, CLK, WriteData, Reg6out);
        
    Reg7: entity work.reg_8b(struct)
        port map(reset, DecOut(7), RegWrite, CLK, WriteData, Reg7out);

end struct;
