-- Pipeline Processor Forwarding Unit
-- Written by: Louis Marleau
-- 07/07/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY forwardingUnit IS
	PORT(IDEX_rs, IDEX_rt, EXMEM_rd, MEMWB_rd : IN	STD_LOGIC_VECTOR(4 downto 0);
		  EXMEM_regwrite, MEMWB_regwrite 			 : IN STD_LOGIC;
		  o_rsSel, o_rtSel									    : OUT	STD_LOGIC_VECTOR(1 downto 0));
END forwardingUnit;

ARCHITECTURE structure OF forwardingUnit IS
	SIGNAL equal_A, equal_B, equal_C, equal_D, notZero_EX_MEM, notZero_MEM_WB : STD_LOGIC;
	SIGNAL output1, output2, output3, output4 : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL ForwardSel_Rs, ForwardSel_Rd : STD_LOGIC_VECTOR(1 downto 0);
	
	COMPONENT fiveBitComparator IS
		PORT(
			i_Ai, i_Bi : IN	STD_LOGIC_VECTOR(4 downto 0);
			o_EQ		: OUT	STD_LOGIC);
	END COMPONENT;
	
BEGIN
		  
CompareA: fiveBitComparator
		PORT MAP(
				i_Ai => IDEX_rs,
				i_Bi => MEMWB_rd,
				o_EQ => equal_A
				);

CompareB: fiveBitComparator
		PORT MAP(
				i_Ai => IDEX_rs,
				i_Bi => EXMEM_rd,
				o_EQ => equal_B
				);	
				
CompareC: fiveBitComparator
		PORT MAP(
				i_Ai => IDEX_rt,
				i_Bi => MEMWB_rd,
				o_EQ => equal_C
				);	
				
CompareD: fiveBitComparator
		PORT MAP(
				i_Ai => IDEX_rt,
				i_Bi => EXMEM_rd,
				o_EQ => equal_D
				);		
				
	  o_rsSel(1) <= equal_B and EXMEM_regwrite;
	  o_rsSel(0) <= equal_A and MEMWB_regwrite;

	  o_rtSel(1) <= equal_D and EXMEM_regwrite;
	  o_rtSel(0) <= equal_C and MEMWB_regwrite;
	
END structure;