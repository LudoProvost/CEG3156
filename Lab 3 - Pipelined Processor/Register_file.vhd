library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_file is
    port(
        CLK, RegWrite, reset: in std_logic;
        ReadReg1, ReadReg2, WriteReg: in std_logic_vector(4 downto 0);
        WriteData: in std_logic_vector(7 downto 0);
        ReadData1, ReadData2: out std_logic_vector(7 downto 0)
    );
end Register_file;

architecture struct OF Register_file is
    signal DecIn: std_logic_vector(1 downto 0);
    signal DecOut: std_logic_vector(3 downto 0);
    signal Reg0out, Reg1out, Reg2out, Reg3out: std_logic_vector(7 downto 0);
begin
    DecIn <= WriteReg(1 downto 0); --Since we only use 4 registers, only the first 2 bits are important for decoding
    
    Decoder: entity work.Decoder2to4(struct)
        port map(DecIn, DecOut);
        
    MuxData1: entity work.mux4to1_8b(struct)
        port map(Reg0out, Reg2out, Reg1out, Reg3out, ReadReg1(1), ReadReg1(0), ReadData1);
        
    MuxData2: entity work.mux4to1_8b(struct)
        port map(Reg0out, Reg2out, Reg1out, Reg3out, ReadReg2(1), ReadReg2(0), ReadData2);
        
    Reg0: entity work.reg_8b(struct)
        port map(reset, DecOut(0), RegWrite, CLK, WriteData, Reg0out);
    
    Reg1: entity work.reg_8b(struct)
        port map(reset, DecOut(1), RegWrite, CLK, WriteData, Reg1out);
        
    Reg2: entity work.reg_8b(struct)
        port map(reset, DecOut(2), RegWrite, CLK, WriteData, Reg2out);
        
    Reg3: entity work.reg_8b(struct)
        port map(reset, DecOut(3), RegWrite, CLK, WriteData, Reg3out);
end struct;