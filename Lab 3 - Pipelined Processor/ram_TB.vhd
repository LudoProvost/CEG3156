LIBRARY ieee;
LIBRARY lpm;

USE ieee.std_logic_1164.ALL;
USE lpm.lpm_components.all;

ENTITY ram_TB is 
END ram_TB;

Architecture testbench of ram_TB IS
	
	SIGNAL addressIn, dataOut, dataIn : STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL clk_tb, writeEnable : STD_LOGIC;
	SIGNAL sim_end : boolean := false;

	COMPONENT dataMem is 
		PORT( data : IN STD_LOGIC_VECTOR(7 downto 0);
				addr : IN STD_LOGIC_VECTOR(7 downto 0);
				i_clock : IN STD_LOGIC;
				writeEn : IN STD_LOGIC;
				o_data : OUT STD_LOGIC_VECTOR(7 downto 0)
				);

	END COMPONENT;

BEGIN

ram: dataMem
		PORT MAP( data => dataIn,
					addr  => addressIn,
					i_clock => clk_tb,
					writeEn => writeEnable,
					o_data => dataOut
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
		writeEnable <= '0';
		wait for 50ns;
		addressIn <= "00000001";
		wait for 100ns;
		
		sim_end <= true;
		wait;
		
		end process;	
	 
END testbench;