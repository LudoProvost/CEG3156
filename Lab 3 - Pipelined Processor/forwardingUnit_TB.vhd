LIBRARY ieee;
LIBRARY lpm;

USE ieee.std_logic_1164.ALL;
USE lpm.lpm_components.all;

ENTITY forwardingUnit_TB is 
END forwardingUnit_TB;

Architecture testbench of forwardingUnit_TB IS

	COMPONENT forwardingUnit IS
		PORT(Rs_ID_EX, Rd_ID_EX, Rd_MEM_WB, Rd_EX_MEM : IN	STD_LOGIC_VECTOR(4 downto 0);
			  RegWrite_EX_MEM, RegWrite_MEM_WB 			 : IN STD_LOGIC;
			  o_forwardOut									    : OUT	STD_LOGIC_VECTOR(3 downto 0));
	END COMPONENT;
	
	SIGNAL i_Rs, i_Rd_1, i_Rd_2, i_Rd_3 : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL forward : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL rw_1, rw_2, clk_tb : STD_LOGIC;
	SIGNAL sim_end : boolean := false;
	
BEGIN

forwarding: forwardingUnit
	PORT MAP(Rs_ID_EX => i_Rs,
				Rd_ID_EX => i_Rd_1,
				Rd_MEM_WB => i_Rd_2,
				Rd_EX_MEM => i_Rd_3,
			   RegWrite_EX_MEM => rw_1,
				RegWrite_MEM_WB => rw_2,
			   o_forwardOut => forward
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
		i_Rd_1 <= "00001";
		i_Rd_2 <= "00001";
		i_RD_3 <= "00001";
		rw_1 <= '0';
		rw_2 <= '0';
		
		wait for 50ns;
		
		i_Rs <= "00001";
		i_Rd_1 <= "00001";
		i_Rd_2 <= "00010";
		i_RD_3 <= "00001";
		rw_1 <= '1';
		rw_2 <= '0';
		
		wait for 50ns;
		
		i_Rs <= "00010";
		i_Rd_1 <= "00001";
		i_Rd_2 <= "00010";
		i_RD_3 <= "00001";
		rw_1 <= '0';
		rw_2 <= '1';
		
		wait for 50ns;
		
		i_Rs <= "00001";
		i_Rd_1 <= "00001";
		i_Rd_2 <= "00001";
		i_RD_3 <= "00001";
		rw_1 <= '1';
		rw_2 <= '1';
		
		wait for 50ns;		
		sim_end <= true;
		wait;
		
		end process;	
				
END testbench;
	