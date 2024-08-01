library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_control is
  Port (
    ALUop: in std_logic_vector (1 downto 0);
    instr: in std_logic_vector(5 downto 0);
    ALUopOut: out std_logic_vector(2 downto 0)
  );
end ALU_control;

architecture struct of ALU_control is

begin
    ALUopOut(0) <= ALUop(1) and (instr(3) or instr(0));
    ALUopOut(1) <= not(ALUop(1)) or not(instr(2));
    ALUopOut(2) <= ALUop(0) or (ALUop(1) and instr(1));

end struct;
