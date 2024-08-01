LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pipelineProcessor IS
	PORT(GClock, GReset : IN STD_LOGIC;
		  ValueSelect, InstrSelect : IN STD_LOGIC_VECTOR(2 downto 0);
		  MuxOut : OUT STD_LOGIC_VECTOR(7 downto 0);
		  InstructionOut : OUT STD_LOGIC_VECTOR(31 downto 0);
		  BranchOut, ZeroOut, MemWriteOut, RegWriteOut : OUT STD_LOGIC
		  );
			
END pipelineProcessor;

ARCHITECTURE struct OF pipelineProcessor IS

-- Components

	COMPONENT controlLogicUnit IS
	  PORT(
		 op: in std_logic_vector(5 downto 0);
		 regDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump: out std_logic;
		 ALUOp: out std_logic_vector(1 downto 0)
	  );
	END COMPONENT;
	
	COMPONENT ALU_control is
	  PORT(
		 ALUop: in std_logic_vector (1 downto 0);
		 instr: in std_logic_vector(5 downto 0);
		 ALUopOut: out std_logic_vector(2 downto 0)
	  );
	END COMPONENT;
	
	COMPONENT dataMem is 
		PORT( data : IN STD_LOGIC_VECTOR(7 downto 0);
				addr : IN STD_LOGIC_VECTOR(7 downto 0);
				i_clock : IN STD_LOGIC;
				writeEn : IN STD_LOGIC;
				o_data : OUT STD_LOGIC_VECTOR(7 downto 0)
				);
	END COMPONENT;

	COMPONENT instrMem is 
		PORT( addr : IN STD_LOGIC_VECTOR(7 downto 0);
				i_clock : IN STD_LOGIC;
				instr : OUT STD_LOGIC_VECTOR(31 downto 0)
				);
	END COMPONENT;
	
	COMPONENT regFile_8reg is
    	PORT(
       		CLK, RegWrite, reset : in std_logic;
        	ReadReg1, ReadReg2, WriteReg: in std_logic_vector(4 downto 0);
        	WriteData: in std_logic_vector(7 downto 0);
        	ReadData1, ReadData2: out std_logic_vector(7 downto 0)
    	);
	END COMPONENT;
	
	COMPONENT MUX2to1_8b is
		 port(
			  IN1, IN2: in std_logic_vector(7 downto 0);
			  Sel: in std_logic;
			  OUT1: out std_logic_vector(7 downto 0)
		 );
	end COMPONENT;
	
	COMPONENT reg_8b IS
		 PORT(
			  i_reset, SEL, LOAD, CLK: in std_logic;
			  INPUT: in std_logic_vector(7 downto 0);
			  OUTPUT: out std_logic_vector(7 downto 0)
		 );
	END COMPONENT;
	
	COMPONENT MUX2to1_5b IS
	  PORT(
		 IN1, IN2: in std_logic_vector(4 downto 0);
		 Sel: in std_logic;
		 OUT1: out std_logic_vector(4 downto 0)
	  );
	END COMPONENT;
	
	COMPONENT shLeft2 is
		PORT(input : IN STD_LOGIC_VECTOR(7 downto 0);
			  output : OUT STD_LOGIC_VECTOR(7 downto 0)
				);
			
	END COMPONENT;
	
	COMPONENT ALU_8b is
		PORT(
			A, B: in std_logic_vector(7 downto 0);
			ctrl: in std_logic_vector(2 downto 0);
			ALUout: out std_logic_vector(7 downto 0);
			Z: out std_logic
			);
	END COMPONENT;
	
	COMPONENT mux8to1_8bits IS
		PORT( a, b, c, d, e, f, g, h : IN STD_LOGIC_VECTOR(7 downto 0);
			sel : IN STD_LOGIC_VECTOR;
			output : OUT STD_LOGIC_VECTOR(7 downto 0)
			);
	END COMPONENT;
	
	COMPONENT adder_8b is
		 Port (
			 A, B: in std_logic_vector(7 downto 0);
			 Cin: in std_logic;
			 sum: out std_logic_vector(7 downto 0)
		 );
	END COMPONENT;
	
	COMPONENT hazardDetection IS
		PORT(Rs_IF_ID, Rt_ID_EX, Rt_IF_ID : IN	STD_LOGIC_VECTOR(4 downto 0);
			  MemRead_ID_EX 					 : IN STD_LOGIC;
			  o_Hazard							 : OUT	STD_LOGIC);
	END COMPONENT;
	
	COMPONENT IF_ID IS
		PORT( i_instruction : IN	STD_LOGIC_VECTOR(31 downto 0);
			i_instructionCount: IN	STD_LOGIC_VECTOR(7 downto 0);
		  	if_flush, i_hazard, G_Reset, G_clock : IN STD_LOGIC;
		   o_instruction : OUT	STD_LOGIC_VECTOR(31 downto 0);
			o_instructionCount: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT eightBitComparator IS
		PORT(
			i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_EQ		: OUT	STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT ID_EX IS
		PORT( i_A, i_B, i_Rt2 : IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Rs, i_Rt1, i_Rd: IN	STD_LOGIC_VECTOR(4 downto 0);
		  	i_WB : IN STD_LOGIC_VECTOR(1 downto 0);
			i_M, i_EX : IN STD_LOGIC_VECTOR(2 downto 0);
			G_Reset, G_clock, i_ALUSrc_ID : IN STD_LOGIC;
			o_WB : OUT STD_LOGIC_VECTOR(1 downto 0);
			o_M, o_EX : OUT STD_LOGIC_VECTOR(2 downto 0);
		   o_A, o_B, o_Rt2  : OUT	STD_LOGIC_VECTOR(7 downto 0);
			o_Rs, o_Rd, o_Rt1: OUT	STD_LOGIC_VECTOR(4 downto 0);
			o_ALUSrc_EX : OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT MUX4to1_8b is
    	port(
        	IN0, IN1, IN2, IN3: in std_logic_vector(7 downto 0);
        	Sel1, Sel2: in std_logic;
        	OUTPUT: out std_logic_vector(7 downto 0)
		);
	end COMPONENT;
	
	COMPONENT EX_MEM IS
		PORT( 	
			i_ALU, i_Rt : IN	STD_LOGIC_VECTOR(7 downto 0);
			G_Reset, G_clock : IN STD_LOGIC;
			i_WB_MEM, i_Rd : IN STD_LOGIC_VECTOR(4 downto 0);
			o_WB_MEM, o_Rd: OUT STD_LOGIC_VECTOR(4 downto 0);
			o_ALU, o_Rt  : OUT	STD_LOGIC_VECTOR(7 downto 0)
			);
	END COMPONENT;
	
	COMPONENT MEM_WB IS
		PORT( 	i_Data, i_aluBypass, i_Rd : IN	STD_LOGIC_VECTOR(7 downto 0);
					G_Reset, G_clock : IN STD_LOGIC;
					i_WB : IN STD_LOGIC_VECTOR(1 downto 0);
					o_Rd : OUT STD_LOGIC_VECTOR(4 downto 0);
					o_WB : OUT STD_LOGIC_VECTOR(1 downto 0);
					o_Data, o_aluBypass : OUT	STD_LOGIC_VECTOR(7 downto 0));
	END COMPONENT;
	
	COMPONENT forwardingUnit IS
		PORT(IDEX_rs, IDEX_rt, EXMEM_rd, MEMWB_rd : IN	STD_LOGIC_VECTOR(4 downto 0);
		EXMEM_regwrite, MEMWB_regwrite 			 : IN STD_LOGIC;
		o_rsSel, o_rtSel									    : OUT	STD_LOGIC_VECTOR(1 downto 0));
	END COMPONENT;
	
	COMPONENT MUX8to1_32b is
		Port (
			a : in  STD_LOGIC_VECTOR(31 downto 0);
			b : in  STD_LOGIC_VECTOR(31 downto 0);
			c : in  STD_LOGIC_VECTOR(31 downto 0);
			d : in  STD_LOGIC_VECTOR(31 downto 0);
			e : in  STD_LOGIC_VECTOR(31 downto 0);
			f : in  STD_LOGIC_VECTOR(31 downto 0);
			g : in  STD_LOGIC_VECTOR(31 downto 0);
			h : in  STD_LOGIC_VECTOR(31 downto 0);
			sel : in  STD_LOGIC_VECTOR(2 downto 0);
			y : out  STD_LOGIC_VECTOR(31 downto 0)
		);
	end COMPONENT;
		
	COMPONENT instructionBuffer IS
		PORT(
			i_instruction : IN STD_LOGIC_VECTOR(31 downto 0);
			Clock, Reset, i_enable : IN STD_LOGIC;
			o_instruction1, o_instruction2, o_instruction3, o_instruction4, o_instruction5 : OUT STD_LOGIC_VECTOR(31 downto 0)
		);
				
	END COMPONENT;
	
-- Signals
	
	SIGNAL nextAddr, fetchAddr8bit, PCplus4, branchAddr, branchEffAddr, instructionCount_IF, ID_instructionCount, o_Other : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL ALU_OP_CTRL : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL ALU_OP : STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL out_A, out_B, controls_ID, src_A, src_B, input_B_ALU, ALUresult_MEM, EX_Controls, MEM_ALUresult, MemReadMUXOut : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL EX_A, EX_B, MEM_dataIn, dataOut_WB, WB_Data, WB_Bypass, write_data, WB_M_EX, EX_Rt2, MEM_WB_i_Rd  : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL MEM_srcReg, srcReg_WB, srcReg_EX, WB_srcReg : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL EX_Rs, EX_Rd, EX_Rt1, MEM_Controls, MEM_Rd : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL decodedInstr32bit_IF, ID_decodedInstr32bit : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL CLKdiv2, PCLoadSel, PCwrite, jump, write_Reg, equals, hazard_NOT, Zero, ALU_Src_EX, dummysig : STD_LOGIC;
	SIGNAL BranchSel, flush_IF, hazard, reg_write, mem_to_reg, Branch, Mem_Read, Mem_Write, Reg_dst, ALU_Src  : STD_LOGIC;
	SIGNAL Forward : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL WB_Controls, rsSel, rtSel : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL instructionBuff_1, instructionBuff_2, instructionBuff_3, instructionBuff_4, instructionBuff_5 : STD_LOGIC_VECTOR(31 downto 0);

	
BEGIN

clockdiv: entity work.clkDiv(struct)
	port map(GClock, GReset, CLKdiv2);
	
--=====--============================================================--=====--

--= IF Stage =--
	
pc: reg_8b
	PORT MAP( 
				i_reset => GReset,
				SEL => GReset,		-- set to GReset instead of 1 because it would load undefined values at the very beginning.
				LOAD => PCwrite,					-- PCwrite = 0(Stall) / 1(send next instruction) 
				CLK => CLKdiv2,			
				INPUT => nextAddr,
				OUTPUT => fetchAddr8bit
			 );
			 
	PCLoadSel <= jump or (branch and equals);	-- Take branch/jump
	
ROM: instrMem
	PORT MAP( 
				addr => fetchAddr8bit,
				i_clock => GClock,
				instr => decodedInstr32bit_IF
				);	
				
PCLoadMux: MUX2to1_8b	
	PORT MAP(
		IN1 => PCplus4,
		IN2 => branchEffAddr,
		Sel => PCLoadSel,
		OUT1 => nextAddr
	);
	
seqInstrAdd: adder_8b
	PORT MAP(
		 A => fetchAddr8bit,
		 B => "00000100",
		 Cin => '0', 
		 sum => PCplus4
	 );
	 
	 instructionCount_IF <= PCplus4;
--=====--============================================================--=====--

IF_ID_Buffer: IF_ID
	PORT MAP(
				i_instruction => decodedInstr32bit_IF,
				i_instructionCount => instructionCount_IF,
				if_flush => flush_IF,
				i_hazard => hazard_NOT,
				
				G_Reset => GReset, 
				G_clock => clkdiv2,
				
					o_instruction => ID_decodedInstr32bit,
					o_instructionCount => ID_instructionCount
				);
				
--= ID Stage =--

controlUnit: controlLogicUnit 											-- Control unit needs to send IF.Flush
	PORT MAP(
				 op => ID_decodedInstr32bit(31 downto 26),
				 regDst => reg_dst,
				 ALUSrc => ALU_Src,
				 MemtoReg => Mem_to_reg,
				 RegWrite => reg_write,
				 MemRead => mem_read,
				 MemWrite => mem_write,
				 Branch => branch,
				 Jump => jump,
				 ALUOp => ALU_OP_CTRL
			  );	
			  
Registers: regFile_8reg	
    PORT MAP(
				  CLK => CLKdiv2,								-- clk div2
				  RegWrite => WB_Controls(1),
				  reset => GReset,
				  ReadReg1 => ID_decodedInstr32bit(25 downto 21),
				  ReadReg2 => ID_decodedInstr32bit(20 downto 16),
				  WriteReg => WB_srcReg,
				  WriteData => write_data,
				  ReadData1 => out_A,
				  ReadData2 => out_B
			  );
			  
	WB_M_EX <= reg_write & Mem_to_reg & branch & Mem_Read & mem_write & reg_dst & ALU_OP_CTRL;
	hazard <= not(hazard_NOT);		-- CHANGED
	
controlBufferMux: MUX2to1_8b
	PORT MAP(
				 IN1 => WB_M_EX,
				 IN2 => "00000000",
				 Sel => hazard,
				 OUT1 => controls_ID
			  );
			  
branchJumpShiftL2: shLeft2
	PORT MAP(input => ID_decodedInstr32bit(7 downto 0),
			   output => branchAddr
				);
				
ALUBranchJump: adder_8b
	PORT MAP(
				A => ID_instructionCount,
				B => branchAddr,
				Cin => '0',
				sum => branchEffAddr
				);			

compEqual: eightBitComparator
	PORT MAP(
				i_Ai => out_A,
				i_Bi => out_B,		
				o_EQ => equals
			);
				
--=====--============================================================--=====--
	
ID_EX_Buffer: ID_EX
	PORT MAP( i_A => out_A,
				 i_B => out_B,
				 i_Rs => ID_decodedInstr32bit(25 downto 21),
				 i_Rt1 => ID_decodedInstr32bit(20 downto 16),
				 i_Rt2 => ID_decodedInstr32bit(7 downto 0),
				 i_Rd => ID_decodedInstr32bit(15 downto 11),
				 i_WB => controls_ID(7 downto 6),
				 i_M => controls_ID(5 downto 3),
				 i_EX => controls_ID(2 downto 0),
				 
				 G_Reset => GReset,
				 G_clock => clkdiv2,
				 i_ALUSrc_ID => ALU_Src,
				 
					o_WB => EX_Controls(7 downto 6),
					o_M  => EX_Controls(5 downto 3),
					o_EX => EX_Controls(2 downto 0),
					o_A => EX_A,
					o_B => EX_B,
					o_Rs => EX_Rs,
					o_Rd => EX_Rd,
					o_Rt1 => EX_Rt1,
					o_Rt2 => EX_Rt2,
					o_ALUSrc_EX => ALU_Src_EX
					);
					
--= EX Stage =--
	
sourceRegMux: MUX2to1_5b
	PORT MAP(
				 IN1 => EX_Rt1,
				 IN2 => EX_Rd,
				 Sel => EX_Controls(2),
				 OUT1 => srcReg_EX
			  );
			  
sourceA: mux4to1_8b
	PORT MAP(
        IN0 => EX_A,
		IN1 => MemReadMUXOut,
		IN2 => write_data,
		IN3 => "11100111", -- NON REACHABLE STATE; debug data
        Sel1 => rsSel(1),
		Sel2 => rsSel(0),
        OUTPUT => src_A
		 );
		 
sourceB: mux4to1_8b
	PORT MAP(
        IN0 => EX_B,
		IN1 => MemReadMUXOut,
		IN2 => write_data,
		IN3 => "11100111", -- NON REACHABLE STATE; debug data
        Sel1 => rtSel(1),
		Sel2 => rtSel(0),
        OUTPUT => src_B
		 );

sourceBmux: MUX2to1_8b
		PORT MAP(
			  IN1 => src_B,
			  IN2 => EX_Rt2, 
			  Sel => ALU_Src_EX,
			  OUT1 => input_B_ALU
		 );
		 
ALUcontroller: ALU_control
		PORT MAP(
			 ALUop => EX_Controls(1 downto 0),
			 instr => EX_Rt2(5 downto 0),
			 ALUopOut => ALU_OP
		  );

ExALU: ALU_8b
		PORT MAP(
			A => src_A,
			B => input_B_ALU,
			ctrl => ALU_OP,
			ALUout => ALUresult_MEM,
			Z => Zero
			);
			  
--=====--============================================================--=====--		
	  			
HazardUnit: hazardDetection
	PORT MAP( Rs_IF_ID => ID_decodedInstr32bit(25 downto 21),
			Rt_ID_EX => EX_Rt1,
			Rt_IF_ID => ID_decodedInstr32bit(20 downto 16),
			MemRead_ID_EX => EX_Controls(4),
			o_Hazard	=> dummysig -- changed to dummy signal, so that i can manually set hazard_NOT to a constant 1 to test without stalling.
			);		
			
hazard_NOT <=  '1'; --TODO remove and change dummysig for hazard_NOT (only occurence is in hazardunit)
PCwrite <= hazard_NOT;	
	
EX_MEM_Buffer: EX_MEM			
	PORT MAP( 	i_ALU => ALUresult_MEM,
					i_Rd => srcReg_EX,
					i_Rt => src_B,		-- WAS EX_Rt2, changed to src_B
					G_Reset => GReset,
					G_clock => clkdiv2,
					i_WB_MEM => EX_Controls(7 downto 3),
					
					
					o_WB_MEM => MEM_Controls,
					o_ALU => MEM_ALUresult,
					o_Rd => MEM_Rd,
					o_Rt => MEM_dataIn
			);
			
Forwarding: forwardingUnit			
	PORT MAP(IDEX_rs => EX_Rs,
				IDEX_rt => EX_Rt1,
				EXMEM_rd => MEM_Rd,
				MEMWB_rd => WB_srcReg,
				EXMEM_regwrite => MEM_Controls(4),
				MEMWB_regwrite => WB_Controls(1),
				o_rsSel => rsSel,
				o_rtSel => rtSel
			  );		
			  
--= MEM Stage =--
			
RAM: dataMem
		PORT MAP( 	data => MEM_dataIn,
						addr => MEM_ALUresult,
						i_clock => GClock,
						writeEn => MEM_Controls(0),
						o_data => dataOut_WB
				);

MemReadMUX: MUX2to1_8b	-- mem read mux used to forward either ram data out OR alu result
		PORT MAP(
			IN1 => MEM_ALUresult,
			IN2 => dataOut_WB, 
			Sel => MEM_Controls(1),	-- memRead
			OUT1 => MemReadMUXOut
		);
--=====--============================================================--=====--	

	MEM_WB_i_Rd <= "000" & MEM_Rd;

MEM_WB_Buffer: MEM_WB 
	PORT MAP( 	i_Data => dataOut_WB,
				   i_aluBypass => MEM_ALUresult,
					i_Rd => MEM_WB_i_Rd,
					G_Reset => GReset,
					G_clock => clkdiv2,
					i_WB => MEM_Controls(4 downto 3),
					
						o_WB => WB_Controls,
						o_Data => WB_Data,
						o_aluBypass => WB_Bypass,
						o_Rd => WB_srcReg
				);
				
--= WB Stage =--
			
wbRegMux: MUX2to1_8b
	PORT MAP(
				 IN1 => WB_Bypass,
				 IN2 => WB_Data,
				 Sel => WB_Controls(0),
				 OUT1 => write_data
			  );
			
--=====--============================================================--=====--	
	
ValueSelector: mux8to1_8bits			-- MUX data export selector
	 PORT MAP( a => fetchAddr8bit,	-- PC out
				  b => ALUresult_MEM, 			-- ALU out Data
				  c => out_A,					-- Register file Operator A
				  d => out_B,					-- Register file Operator B
				  e => write_data,		-- Register file Write Data
				  f => o_Other,			-- Control Data
				  g => o_Other,
				  h  => o_Other,
				  sel => ValueSelect,
				  output => MuxOut
				);
				
o_Other <= '0' & reg_dst & jump & mem_read & Mem_to_reg & ALU_OP_CTRL (1) & ALU_OP_CTRL(0) & ALU_Src;

InstructBuffer: InstructionBuffer
			PORT MAP( i_instruction => decodedInstr32bit_IF,
						  Clock => clkdiv2,	-- changed to clkdiv2
						  Reset => GReset,
						  i_enable => '1',
						  o_instruction1 => instructionBuff_1,
						  o_instruction2 => instructionBuff_2,
						  o_instruction3 => instructionBuff_3,
						  o_instruction4 => instructionBuff_4,
						  o_instruction5 => instructionBuff_5
						  );
			  
InstructionSelect: MUX8to1_32b
	    Port MAP( a => instructionBuff_1,
					  b => instructionBuff_2,
					  c => instructionBuff_3,
					  d => instructionBuff_4,
					  e => instructionBuff_5,
					  f => "00000000000000000000000000000000",
					  g => "00000000000000000000000000000000",
					  h => "00000000000000000000000000000000",
					  sel =>InstrSelect,
					  y => InstructionOut
					  );

END struct;