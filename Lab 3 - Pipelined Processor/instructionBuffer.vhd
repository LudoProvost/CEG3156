LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY instructionBuffer IS
	PORT(i_instruction : IN STD_LOGIC_VECTOR(31 downto 0);
		  Clock, Reset, i_enable : IN STD_LOGIC;
		  o_instruction1, o_instruction2, o_instruction3, o_instruction4, o_instruction5 : OUT STD_LOGIC_VECTOR(31 downto 0)
		  );
			
END instructionBuffer;

ARCHITECTURE struct OF instructionBuffer IS
	SIGNAL instruction1, instruction2, instruction3, instruction4, instruction5 : STD_LOGIC_VECTOR(31 downto 0);

	COMPONENT register32bits
		PORT(input : IN STD_LOGIC_VECTOR(31 downto 0);
			  Clk, G_Reset, enable : IN STD_LOGIC;
			  output : OUT STD_LOGIC_VECTOR(31 downto 0)
			  );
	END COMPONENT;

BEGIN

Inst1: register32bits
	PORT MAP(input =>  i_instruction,
			  Clk => Clock,
			  G_Reset => reset,
			  enable => i_enable,
			  output => instruction1
			  );
			  
Inst2: register32bits
	PORT MAP(input =>  instruction1,
			  Clk => Clock,
			  G_Reset => reset,
			  enable => i_enable,
			  output => instruction2
			  );
			  
Inst3: register32bits
	PORT MAP(input =>  instruction2,
			  Clk => Clock,
			  G_Reset => reset,
			  enable => i_enable,
			  output => instruction3
			  );
			  
Inst4: register32bits
	PORT MAP(input =>  instruction3,
			  Clk => Clock,
			  G_Reset => reset,
			  enable => i_enable,
			  output => instruction4
			  );
			  
Inst5: register32bits
	PORT MAP(input =>  instruction4,
			  Clk => Clock,
			  G_Reset => reset,
			  enable => i_enable,
			  output => instruction5
			  );
			  
	o_instruction1 <= instruction1;
	o_instruction2 <= instruction2;
	o_instruction3 <= instruction3;
	o_instruction4 <= instruction4;
	o_instruction5 <= instruction5;
			  
			  
END struct;