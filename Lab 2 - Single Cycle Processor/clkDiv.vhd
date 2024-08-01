library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clkDiv is
  Port (
    clk: in std_logic;
    reset: in std_logic;
    clk_out: out std_logic
  );
end clkDiv;

architecture struct of clkDiv is
    signal q, d : std_logic;
begin
    ENDFF: entity work.enARdFF_2(rtl)
        port map(reset, d, '1', clk, q);

    d <= not q;
    
    clk_out <= q;
end struct;
