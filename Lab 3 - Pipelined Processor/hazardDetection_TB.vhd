LIBRARY ieee;
LIBRARY lpm;

USE ieee.std_logic_1164.ALL;
USE lpm.lpm_components.all;

ENTITY hazardDetection_TB is 
END hazardDetection_TB;

Architecture testbench of hazardDetection_TB IS

	COMPONENT hazardDetection IS
		PORT(Rs_IF_ID, Rt_ID_EX, Rt_IF_ID : IN	STD_LOGIC_VECTOR(4 downto 0);
		  MemRead_ID_EX 					 : IN STD_LOGIC;
		  o_Hazard							 : OUT	STD_LOGIC);
	END COMPONENT;
		
	SIGNAL i_Rs, i_Rt, i_Rt_2 : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL i_memRead, hazard, clk_tb : STD_LOGIC;
	SIGNAL sim_end : boolean := false;
	
BEGIN
	
hazardUnit: hazardDetection
		PORT MAP(  Rs_IF_ID => i_Rs,
					  Rt_ID_EX => i_Rt,
					  Rt_IF_ID => i_Rt_2,
					  MemRead_ID_EX => i_memRead,
					  o_Hazard => hazard
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
		
		wait for 50ns;
		
		i_Rs <= "00001";
		i_Rt <= "00001";
		i_Rt_2 <= "10001";
		i_memRead <= '1';
		
		wait for 50ns;
				
		i_Rs <= "00011";
		i_Rt <= "10001";
		i_Rt_2 <= "10001";
		i_memRead <= '1';
		
		wait for 50ns;
				
		i_Rs <= "00101";
		i_Rt <= "01001";
		i_Rt_2 <= "10001";
		i_memRead <= '1';
		
		wait for 50ns;
				
		i_Rs <= "01000";
		i_Rt <= "00001";
		i_Rt_2 <= "10001";
		i_memRead <= '0';
		
		wait for 50ns;
		
		sim_end <= true;
		wait;
		
		end process;	
	
END testbench;
	