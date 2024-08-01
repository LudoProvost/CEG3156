library ieee;    
use ieee.std_logic_1164.all;    
--simple one bit full adder with carry lookahead implementation
ENTITY ALU_8b is
	port (
		A, B: in std_logic_vector(7 downto 0);
		ctrl: in std_logic_vector(2 downto 0);
		ALUout: out std_logic_vector(7 downto 0);
		Z: out std_logic
		);
end ALU_8b;
	
ARCHITECTURE struct OF ALU_8B is
    signal XORout, XOR2out: std_logic_vector(7 downto 0);
    signal FAout: std_logic_vector(7 downto 0);
    signal Cin: std_logic;
    signal ANDout: std_logic_vector(7 downto 0);
    signal ORout: std_logic_vector(7 downto 0);
    signal signalZ, sel0: std_logic;
begin
	sel0 <= ctrl(2) or ctrl(0);

	XOR1: entity work.xor_8b(struct)
	   port map(B, ctrl(2), XORout);
	
   XOR2: entity work.xor_8b(struct)
	   port map(FAout, '1', XOR2out);
	 
	 FA: entity work.adder_8b_withZero(struct)
	   port map(A, XORout, '0', FAout, signalZ);	--cin = ctrl(2), changed to '0'
	   
	 ANDout <= A and B;
	 ORout <= A or B;
	 
	 MUX: entity work.mux4to1_8b(struct)
	 -- changed sel0 (was: ctrl(0)) to ctrl(2) or ctrl(0) because we now need different signals for add and sub
	   port map(ANDout, FAout, ORout, XOR2out, ctrl(1), sel0, ALUout); 
	   
	 Z <= signalZ and ctrl(1); --make sure only outputs when doing arithmetic and not logic
	 
end struct;
	

	
