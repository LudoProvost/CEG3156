LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY oneCycleProcessor IS
	PORT(GClock, GReset : IN STD_LOGIC;
		  ValueSelect : IN STD_LOGIC_VECTOR(2 downto 0);
		  MuxOut : OUT STD_LOGIC_VECTOR(7 downto 0);
		  InstructionOut : OUT STD_LOGIC_VECTOR(31 downto 0);
		  BranchOut, ZeroOut, MemWriteOut, RegWriteOut : OUT STD_LOGIC
		  );
			
END oneCycleProcessor;

ARCHITECTURE struct OF oneCycleProcessor IS

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

	COMPONENT MUX2to1_8b IS
		 PORT(
			  IN1, IN2: in std_logic_vector(7 downto 0);
			  Sel: in std_logic;
			  OUT1: out std_logic_vector(7 downto 0)
		 );
	END COMPONENT;
	
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
	
	SIGNAL PCplus4, fetchAddr8bit, nextAddr, jumpAddr, write_data, o_A, o_B, alu_B : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL aluData, branch, branchAddr, braORseq, branchALU, read_data, o_Other : STD_LOGIC_VECTOR(7 downto 0);			--TODO remove branch signal as it is not used
	SIGNAL decodedInstr32bit : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL  write_Reg : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL ALUcontrol : STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL reg_dst, reg_write, ALU_Src, zero, branchZero, branchInstr, jumpInstr, write_enable, mem_read, mem_write, mem_toReg, branchMuxSel : STD_LOGIC;
	SIGNAL opALU : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL aluInstr : STD_LOGIC_VECTOR(5 downto 0);
	
	SIGNAL PCJumpAdderOut, PCLoadMuxOut, instrAddrMuxOut: STD_LOGIC_VECTOR(7 downto 0);

	SIGNAL CLKdiv2, PCLoadSel: STD_LOGIC;
	
BEGIN

PCLoadSel <= jumpInstr or (branchMuxSel);

clockdiv: entity work.clkDiv(struct)
	port map(GClock, GReset, CLKdiv2);

controlUnit: controlLogicUnit 
	PORT MAP(
				 op => decodedInstr32bit(31 downto 26),
				 regDst => reg_dst,
				 ALUSrc => ALU_Src,
				 MemtoReg => mem_toReg,
				 RegWrite => reg_write,
				 MemRead => mem_read,
				 MemWrite => mem_write,
				 Branch => branchInstr,
				 Jump => jumpInstr,
				 ALUOp => opALU
			  );

controlALU: ALU_control
	PORT MAP(
			 ALUop => opALU,
			 instr => aluInstr,
			 ALUopOut => ALUcontrol
		  );

		  
PCJumpAdder: adder_8b
	PORT MAP(
		A => nextAddr,
		B => "00000000", --00000100
		Cin => '0', 
		sum => PCJumpAdderOut
	);

PCLoadMux: MUX2to1_8b	
	PORT MAP(
		IN1 => nextAddr,
		IN2 => PCJumpAdderOut,
		Sel => PCLoadSel,
		OUT1 => PCLoadMuxOut
	);	
	
pc: reg_8b
	PORT MAP( 
				i_reset => GReset,
				SEL => '1',
				LOAD => '1',
				CLK => CLKdiv2,				--changed clock --ended up keeping it as GClock so that it refreshes quickly (in the case of a jump)
				INPUT => nextAddr,
				OUTPUT => fetchAddr8bit
			 );

instrAddrMux: MUX2to1_8b	
	PORT MAP(
		IN1 => fetchAddr8bit,
		IN2 => nextAddr,
		Sel => PCLoadSel,
		OUT1 => instrAddrMuxOut
	);	

seqInstrAdd: adder_8b
	PORT MAP(
		 A => fetchAddr8bit,
		 B => "00000100",
		 Cin => '0', 
		 sum => PCplus4
	 );
	 
ROM: instrMem
	PORT MAP( 
				addr => instrAddrMuxOut,
				i_clock => GClock,
				instr => decodedInstr32bit
				);

jumpShiftL2: shLeft2	
	PORT MAP(input => decodedInstr32bit(7 downto 0),
			   output => jumpAddr
				);
	
branchShiftL2: shLeft2
	PORT MAP(input => decodedInstr32bit(7 downto 0),
			   output => branchALU
				);	
				
ALUBranch: adder_8b
		PORT MAP(
				A => PCplus4,
				B => branchALU,
				Cin => '0',
				sum => branchAddr
				);
				
branchMUX: MUX2to1_8b	
	 PORT MAP(
				  IN1 => PCplus4,
				  IN2 => branchAddr,
				  Sel => branchMuxSel,
				  OUT1 => braORseq
				);
				
jumpMUX: MUX2to1_8b	
	 PORT MAP(
				  IN1 => braORseq,
				  IN2 => jumpAddr,
				  Sel => jumpInstr,
				  OUT1 => nextAddr
				);		
				
sourceRegMux: MUX2to1_5b
	PORT MAP(
				 IN1 => decodedInstr32bit(20 downto 16),
				 IN2 => decodedInstr32bit(15 downto 11),
				 Sel => reg_dst,
				 OUT1 => write_Reg
			  );	

Registers: regFile_8reg		-- changed to new 8reg register file
    PORT MAP(
				  CLK => CLKdiv2,								--changed clk
				  RegWrite => reg_write,
				  reset => GReset,
				  ReadReg1 => decodedInstr32bit(25 downto 21),
				  ReadReg2 => decodedInstr32bit(20 downto 16),
				  WriteReg => write_Reg,
				  WriteData => write_data,
				  ReadData1 => o_A,
				  ReadData2 => o_B
			  );

ALUmuxB: MUX2to1_8b	
	 PORT MAP(
				  IN1 => o_B,
				  IN2 => decodedInstr32bit(7 downto 0),
				  Sel => ALU_Src,
				  OUT1 => alu_B
				);
				
operatingALU: ALU_8b
		PORT MAP(
				A => o_A,
				B => alu_B,
				ctrl => ALUcontrol,
				ALUout => aluData,
				Z => zero
				);

ram: dataMem
		PORT MAP( 
				   data => o_B,
					addr => aluData,
					i_clock => GClock, 
					writeEn => mem_write,
					o_data => read_data
					);

dataMux: MUX2to1_8b	
	 PORT MAP(
				  IN1 => aluData, 	--Bypass memory
				  IN2 => read_data,
				  Sel => mem_toReg,
				  OUT1 => write_data
				);
				
ValueSelector: mux8to1_8bits			-- MUX data export selector
	 PORT MAP( a => fetchAddr8bit,	-- PC out
				  b => aluData, 			-- ALU out Data
				  c => o_A,					-- Register file Operator A
				  d => o_B,					-- Register file Operator B
				  e => write_data,		-- Register file Write Data
				  f => o_Other,			-- Control Data
				  g => o_Other,
				  h  => o_Other,
				  sel => ValueSelect,
				  output => MuxOut
				);
		branchMuxSel <= zero and branchInstr;	
		aluInstr	<= decodedInstr32bit(5 downto 0);
		o_Other <= '0' & reg_dst & jumpInstr & mem_read & mem_toReg & opALU (1) & opALU(0) & ALU_Src; -- "0XXXXXXX"
		BranchOut <= branchInstr;
		ZeroOut <= zero;
		MemWriteOut <= mem_write;
		RegWriteOut <= reg_write;
		InstructionOut <= decodedInstr32bit;

END struct;