library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tenBitAddSub_TB is -- no defined ports
end tenBitAddSub_TB;

Architecture testbench of tenBitAddSub_TB IS

	SIGNAL sumOut : STD_logic_vector(9 downto 0);
	SIGNAL clk_tb, carryOut : STD_logic;
	SIGNAL sim_end : boolean := false;
	
COMPONENT tenBitAddSub is
	port( i_X, i_Y : in std_logic_vector(9 downto 0);
				carryIn, addSubIn : in std_logic;
				sum : out std_logic_vector(9 downto 0);
				carryOut: out std_logic);
END COMPONENT;

BEGIN

clk_process : process
    begin
        while(not sim_end) loop
            clk_tb <= '1';
            wait for 25ns;
            clk_tb <= '0';
            wait for 25ns;
        end loop;
    end process;
	 
adder: tenBitAddSub
	PORT MAP(i_X => "0110101001",
			   i_Y => "0100101101",
				carryIn => '0',
				addSubIn => '0',
				sum => sumOut,
				carryOut => carryOut
				
				);
				
testbench: process
	begin
		
		
	
		wait for 100ns;
		sim_end <= true;
		wait;
		
		end process;	
				
END testbench;