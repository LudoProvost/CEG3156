library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FPAcontrol_TB is -- no defined ports
end FPAcontrol_TB;

Architecture testbench of FPAcontrol_TB IS

COMPONENT FPAcontrol IS
	PORT(g_clock, g_resetBar : IN STD_LOGIC;
		  a_Greater, b_Greater, equal : IN STD_LOGIC;
		  counterDone, normalizedDone : IN STD_LOGIC;
		  o_controlSignal : OUT STD_LOGIC_VECTOR(5 downto 0)
		  );
		  
END COMPONENT;

	SIGNAL clk_tb, resetBar : STD_LOGIC;
	SIGNAL a_GT, b_GT, eq, c_done, n_done : STD_LOGIC;
	SIGNAL outControl : STD_LOGIC_VECTOR(5 downto 0);
	SIGNAL sim_end : boolean := false;

BEGIN

ControlPath: FPAcontrol
	PORT MAP( g_clock => clk_tb, 
				 g_resetBar => resetBar,
				 a_Greater => a_GT,
				 b_Greater => b_GT,
				 equal  => eq,
				 counterDone => c_done,
				 normalizedDone => n_done,
				 o_controlSignal => outControl
	
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
		resetBar <= '0';
		a_GT <= '0';
		b_GT <= '0';
		eq <= '0';
		c_done <= '0';
		n_done <= '0';
		wait for 50ns;
		
		resetBar <= '1';
		a_GT <= '1';
		wait for 300ns;
		
		c_done <= '1';
		wait for 50ns;
		c_done <= '0';
		
		wait for 300ns;
		
		n_done <= '1';
		
		wait for 100ns;
		resetBar <= '0';
		
		wait for 50ns;
		sim_end <= true;
		wait;
		
		end process;	
		
END testbench;