LIBRARY ieee;
LIBRARY lpm;

USE ieee.std_logic_1164.ALL;
USE lpm.lpm_components.all;

ENTITY rom_TB is 
END rom_TB;

Architecture testbench of rom_TB IS
	
	SIGNAL addressIn : STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL clk_tb : STD_LOGIC;
	SIGNAL dataOut : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL sim_end : boolean := false;

	COMPONENT instrMem is 
		PORT( addr : IN STD_LOGIC_VECTOR(7 downto 0);
				i_clock : IN STD_LOGIC;
				instr : OUT STD_LOGIC_VECTOR(31 downto 0)
				);

	END COMPONENT;

BEGIN

ram: instrMem
	PORT MAP( addr => addressIn,
				i_clock => clk_tb,
				instr => dataOut
				);

clk_process : process
    begin
        while(not sim_end) loop
            clk_tb <= '1';
            wait for 25ns;
            clk_tb <= '0';
            wait for 25ns;
        end loop;
    end process;
	 
	 testbench: process
		begin
		addressIn <= "00000000";
		wait for 50ns;
		addressIn <= "00000100";
		wait for 50ns;
		addressIn <= "00001000";
		wait for 50ns;
		addressIn <= "00001100";
		wait for 50ns;
		addressIn <= "00010000";
		wait for 50ns;
		addressIn <= "00010100";
		wait for 50ns;
		
		sim_end <= true;
		wait;
		
		end process;	
	 
END testbench;