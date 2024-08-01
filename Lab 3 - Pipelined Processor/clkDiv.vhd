-- library IEEE;
-- use IEEE.STD_LOGIC_1164.ALL;

-- entity clkDiv is
--   Port (
--     clk: in std_logic;
--     reset: in std_logic;
--     clk_out: out std_logic
--   );
-- end clkDiv;

-- architecture struct of clkDiv is
--     signal q, d : std_logic;
-- begin
--     ENDFF: entity work.enARdFF_2(rtl)
--         port map(reset, d, '1', clk, q);

--     d <= not q;
    
--     clk_out <= q;
-- end struct;

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
    signal q1, d1, q2, d2 : std_logic;
begin
    -- First clock divider instance
    ENDFF1: entity work.enARdFF_2(rtl)
        port map(reset, d1, '1', clk, q1);

    d1 <= not q1;

    -- Second clock divider instance
    ENDFF2: entity work.enARdFF_2(rtl)
        port map(reset, d2, '1', q1, q2);

    d2 <= not q2;

    clk_out <= q2;
end struct;