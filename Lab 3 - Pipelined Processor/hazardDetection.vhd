-- Pipeline Processor Hazard Detection Unit
-- Written by: Louis Marleau
-- 07/07/2024

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY hazardDetection IS
	PORT(Rs_IF_ID, Rt_ID_EX, Rt_IF_ID : IN	STD_LOGIC_VECTOR(4 downto 0);
		  MemRead_ID_EX 					 : IN STD_LOGIC;
		  o_Hazard							 : OUT	STD_LOGIC);
END hazardDetection;

ARCHITECTURE structure OF hazardDetection IS
	SIGNAL equal_Rs_Rt, equal_Rt_MemRead, equals : STD_LOGIC;
	
	COMPONENT fiveBitComparator IS
		PORT(
			i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(4 downto 0);
			o_EQ		: OUT	STD_LOGIC);
	END COMPONENT;
	
BEGIN

RsRtComparator: fiveBitComparator
	PORT MAP(
				i_Ai => Rs_IF_ID,
				i_Bi => Rt_ID_EX,
				o_EQ => equal_Rs_Rt);

RtMemReadComparator: fiveBitComparator
	PORT MAP(
				i_Ai => Rt_ID_EX,
				i_Bi => Rt_IF_ID,
				o_EQ => equal_Rt_MemRead);
				
	equals <= equal_Rs_Rt or equal_Rt_MemRead;
	o_Hazard <= equals nand MemRead_ID_EX;



END structure;