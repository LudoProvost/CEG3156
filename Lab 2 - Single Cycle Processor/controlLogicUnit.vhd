library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controlLogicUnit is
  Port (
    op: in std_logic_vector(5 downto 0);
    regDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump: out std_logic;
    ALUOp: out std_logic_vector(1 downto 0)
  );
end controlLogicUnit;

architecture struct of controlLogicUnit is
    signal R, lw, sw,beq,j: std_logic;
begin
    R <= not(op(5) or op(4) or op(3) or op(2) or op(1) or op(0));                               -- "000000"
    lw <= op(5) and not(op(4)) and not(op(3)) and not(op(2)) and op(1) and op(0);               -- "100011"
    sw <= op(5) and not(op(4)) and op(3) and not(op(2)) and op(1) and op(0);                    -- "101011"
    beq <= not(op(5)) and not(op(4)) and not(op(3)) and op(2) and not(op(1)) and not(op(0));    -- "000100"
    j <= not(op(5)) and not(op(4)) and not(op(3)) and not(op(2)) and op(1) and not(op(0));      -- "000010"

    RegDst <= R;
    ALUSrc <= lw or sw;
    MemtoReg <= lw;
    RegWrite <= R or lw;
    MemRead <= lw;
    MemWrite <= sw;
    Branch <= beq;
    ALUOp(1) <= R;
    ALUOp(0) <= beq;
    Jump <= j;
    
end struct;
