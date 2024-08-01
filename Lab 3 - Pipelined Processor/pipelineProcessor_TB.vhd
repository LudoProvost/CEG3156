LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pipelineProcessor_TB IS
END pipelineProcessor_TB;

ARCHITECTURE testbench OF pipelineProcessor_TB IS

	COMPONENT pipelineProcessor IS
		PORT(GClock, GReset : IN STD_LOGIC;
			  ValueSelect, InstrSelect : IN STD_LOGIC_VECTOR(2 downto 0);
			  MuxOut : OUT STD_LOGIC_VECTOR(7 downto 0);
			  InstructionOut : OUT STD_LOGIC_VECTOR(31 downto 0);
			  BranchOut, ZeroOut, MemWriteOut, RegWriteOut : OUT STD_LOGIC
			  );
				
	END COMPONENT;
	
	SIGNAL clk, reset, branch_out, zero_out, memwrite_out, regwrite_out : STD_LOGIC;
	SIGNAL value_select, instr_select : STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL mux_out : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL instruction_out : STD_LOGIC_VECTOR(31 downto 0);	
	SIGNAL sim_end : boolean := false;
	
BEGIN

topLevel: pipelineProcessor
		PORT MAP(GClock => clk,
				   GReset => reset, 
				   ValueSelect => value_select,
                   InstrSelect => instr_select,
				   MuxOut => mux_out,
				   InstructionOut => instruction_out,
				   BranchOut => branch_out,
					ZeroOut => zero_out,
					MemWriteOut => memwrite_out,
					RegWriteOut => regwrite_out
					);
					
clk_process : process
    begin
        while(not sim_end) loop
            clk <= '1';
            wait for 25ns;
            clk <= '0';
            wait for 25ns;
        end loop;
    end process;
	 
testbench: process
		 begin
		 reset <= '0';
		 value_select <= "001";
         instr_select <= "000";
		 wait for 100ns;
		 reset <= '1';
		 wait for 70000ns;
		 
		 sim_end <= true;
		 wait;
	 end process;
		
END testbench;