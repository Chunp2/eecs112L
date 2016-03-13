library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity decode_stage is
	port(
		--------------     Inputs     ----------------------------------------------
		clk		: IN std_logic;
		reset		: IN std_logic;
		instruction 	: IN std_logic_vector(31 downto 0);
		--InstructionMem	: IN std_logic_vector(31 downto 0); --input, goes through decoder 
		--==========fetch register=================
		opSelect	: IN std_logic_vector(5 downto 0);
		regSource	: IN std_logic_vector(4 downto 0);
		regTarget	: IN std_logic_vector(4 downto 0);
		regDest  	: IN std_logic_vector(4 downto 0);
		func      	: IN std_logic_vector(5 downto 0);
		immValue  	: IN std_logic_vector(15 downto 0);
		PCPlus4   	: IN std_logic_vector(31 downto 0);
		--============WritebackCycle=======================
		finalWriteData	: IN std_logic_vector(31 downto 0);
		regWrite	: IN std_logic;	
		--============     CYCLE OUTPUTS       ===================
		


		--==========concatnator ============================
		--out_JumpConcat	: OUT std_logic_vector(31 downto 0);
		--===============PC=================================
		out_PCPlus4	: OUT  std_logic_vector(31 downto 0);
		out_PC		: OUT  std_logic_vector(31 downto 0);
		--==========controller output ======================
		out_RegDst	: OUT std_logic;			
		--1 is write using RD 0 is write using RT
		out_MemRead	: OUT std_logic;					--1 is read from RAM 0 is don't read from RAM
		out_MemtoReg	: OUT std_logic;					--1 is write using RAM data, 0 is write using ALU output
		out_ALUOp	: OUT std_logic_vector(4 downto 0); 
		out_MemWrite	: OUT std_logic;					--1 is write into RAM, 0 is don't write into RAM
		out_ALUSrc	: OUT std_logic;					--1 is ALU Bin is immediate value, 0 is ALU Bin is Register data
		out_RegWrite	: OUT std_logic;					--1 is write into Register, 0 is don't write into register
		out_Branch	: OUT std_logic;					--1 is the cycle is a branch cycle, 0 is not branch cycle
		out_Jump	: OUT std_logic;					--1 is the cycle is a jump cycle, 0 is not a jump cycle
		out_ShiftContr	: OUT std_logic;
		out_wdataContr	: OUT std_logic_vector(1 downto 0); --0 is normal input, 1 is Load Upper Immediate Input, 2-3 is Jump and Link Instruction
		--=================decoder output================
		out_opSelect 	: OUT std_logic_vector(5 downto 0);
		--==============register output ==================
		out_rdata_1	: OUT std_logic_vector(31 DOWNTO 0);
		out_rdata_2	: OUT std_logic_vector(31 DOWNTO 0);
		--===================mux32bi=======================
		out_JumpAddr	: OUT std_logic_vector(31 DOWNTO 0);
		--===================ALUfunc======================
		out_JRControl	: OUT std_logic;
		out_ALUfunc	: OUT std_logic_vector(5 DOWNTO 0);
		--================== sign extender ================
		out_ExtendedImmValue:OUT std_logic_vector(31 DOWNTO 0);
		--==================fetchregister ================
		out_regDestination: OUT std_logic_vector(4 DOWNTO 0);
		out_regTarget	: OUT std_logic_vector(4 DOWNTO 0)
		
		
		);
end entity decode_stage; 



architecture behavior of decode_stage is
-----------------------------component declaration-----------------------------------------------
	component Controller is 
	Port(
		rt		: IN std_logic_vector(4 downto 0);
		opSelect	: IN std_logic_vector(5 downto 0);
		RegDst		: OUT std_logic;					--1 is write using RD 0 is write using RT
		MemRead		: OUT std_logic;					--1 is read from RAM 0 is don't read from RAM
		MemtoReg	: OUT std_logic;					--1 is write using RAM data, 0 is write using ALU output
		ALUOp		: OUT std_logic_vector(4 downto 0); 
		MemWrite	: OUT std_logic;					--1 is write into RAM, 0 is don't write into RAM
		ALUSrc		: OUT std_logic;					--1 is ALU Bin is immediate value, 0 is ALU Bin is Register data
		RegWrite	: OUT std_logic;					--1 is write into Register, 0 is don't write into register
		Branch		: OUT std_logic;					--1 is the cycle is a branch cycle, 0 is not branch cycle
		Jump		: OUT std_logic;					--1 is the cycle is a jump cycle, 0 is not a jump cycle
		ShiftContr	: OUT std_logic;
		wdataContr	: OUT std_logic_vector(1 downto 0) --0 is normal input, 1 is Load Upper Immediate Input, 2-3 is Jump and Link Instruction
	 );
	end component;
------------------------------------------------------------------
	component Concatinator is	
	port(
		PC_in : in std_logic_vector(31 downto 0);
		InstructionMem : in std_logic_vector(31 downto 0);
		concatOut : out std_logic_vector (31 downto 0)
	);
	end component;
------------------------------------------------------------------
	component loadControl is 
	Port(
		loadOP: IN std_logic_vector(5 DOWNTO 0);
		dataIn: IN std_logic_vector(31 DOWNTO 0);
		dataOut: OUT std_logic_vector(31 DOWNTO 0)
	);
	end component;
------------------------------------------------------------------
	component regfile IS
		GENERIC (
					NBIT: INTEGER := 32;
					NSEL : INTEGER := 3 );
			PORT(
				clk	: IN 	std_logic;
				rst_s	: IN 	std_logic;
				we	: IN 	std_logic;
				raddr_1	: IN 	std_logic_vector(NSEL - 1 DOWNTO 0);
				raddr_2	: IN 	std_logic_vector(NSEL - 1 DOWNTO 0);
				waddr	: IN 	std_logic_vector(NSEL - 1 DOWNTO 0);
				rdata_1	: OUT 	std_logic_vector(NBIT - 1 DOWNTO 0);
				rdata_2	: OUT 	std_logic_vector(NBIT - 1 DOWNTO 0);
				wdata	: IN 	std_logic_vector(NBIT - 1 DOWNTO 0)
		);
	end component;
-------------------------------------------------------------------	
	
	component MUX32bit is
		Port(
			high	: IN std_logic_vector(31 downto 0);
			low		: IN std_logic_vector(31 downto 0);
			selector: IN std_logic;
			out_put	: OUT std_logic_vector(31 downto 0)
		);
	end component;

-------------------------------------------------------------------
	component SignExtender is
		Port(
			in_put	: IN std_logic_vector(15 downto 0);
			out_put	: OUT std_logic_vector(31 downto 0) 
		);
	end component;

-------------------------------------------------------------------
	component ALUFunc is
		Port(
			ALUOp		: IN std_logic_vector(4 downto 0);
			FuncField	: IN std_logic_vector(5 downto 0);
			JRControl	: OUT std_logic;
			out_put		: OUT std_logic_vector(5 downto 0)
		);
	end component;
-------------------------------------------------------------------
	component MUX5bit is
		Port(
			high	: IN std_logic_vector(4 downto 0);
			low	: IN std_logic_vector(4 downto 0);
			selector: IN std_logic;
			out_put	: OUT std_logic_vector(4 downto 0)
		);
	end component;
-------------------------------------------------------------------
	component ShiftExtender
		port(Instr16down   : IN  std_logic_vector(15 downto 0);
			 ExtendedShamt : OUT std_logic_vector(31 downto 0));
	end component ShiftExtender;
-------------------------------------------------------------------
	component JUIExtender
		port(Instr16down : IN  std_logic_vector(15 downto 0);
			 UpperImm    : OUT std_logic_vector(31 downto 0));
	end component JUIExtender;
-------------------------------------------------------------------
	component FetchRegister is
	Port(
		clk           : IN  std_logic;
		enable        : IN  std_logic;
		--From decoder into register
		opSelect      : IN  std_logic_vector(5 downto 0);
		regSource     : IN  std_logic_vector(4 downto 0);
		regTarget     : IN  std_logic_vector(4 downto 0);
		regDest       : IN  std_logic_vector(4 downto 0);
		func          : IN  std_logic_vector(5 downto 0);
		immValue      : IN  std_logic_vector(15 downto 0);
		PCPlus4       : IN  std_logic_vector(31 downto 0);

		--Output signals
		OUT_opSelect  : OUT std_logic_vector(5 downto 0);
		OUT_regSource : OUT std_logic_vector(4 downto 0);
		OUT_regTarget : OUT std_logic_vector(4 downto 0);
		OUT_regDest   : OUT std_logic_vector(4 downto 0);
		OUT_func      : OUT std_logic_vector(5 downto 0);
		OUT_immValue  : OUT std_logic_vector(15 downto 0);
		OUT_PCPlus4   : OUT std_logic_vector(31 downto 0)
	);
	end component;

	
----------------------------------signal decleration ----------------------------------------------------
-------------------------------------controller---------------------------------------------
SIGNAL	RegDstC				: std_logic;
SIGNAL	ALUOp				: std_logic_vector(4 downto 0);
-------------------------------------FetchRegister---------------------------------------------
SIGNAL regDestF  			:  std_logic_vector(4 downto 0);
SIGNAL immValueF			: std_logic_vector( 15 downto 0);
SIGNAL PCPlus4F				: std_logic_vector(31 downto 0);
-------------------------------------Register-------------------------------------------
SIGNAL rdata_1, rdata_2			: std_logic_vector(31 DOWNTO 0);
SIGNAL raddr_1, raddr_2			: std_logic_vector(4 downto 0);
------------------------------------signals out of loadControlRAM-------------------------------
SIGNAL loadOut					:std_logic_vector(31 downto 0);
-------------------------------signals out of concatenator-----------------------------
SIGNAL JumpConcat			: std_logic_vector(31 downto 0);
-----------------------------------signals out of loadControlReg------------------------------
SIGNAL storeOut				: std_logic_vector(31 downto 0);
-----------------------------------ALU func signals--------------------------------------
Signal JRControl			: std_logic;
SIGNAL FuncField			:  std_logic_vector(5 downto 0);
----------------------------------Mux5to1 output---------------------------------
SIGNAL output5				: std_logic_vector(4 downto 0);
-------------------------------------signal end--------------------------------------------------

-------------------------------------PortMap--------------------------------------------------
begin	

	

	Concatenator: Concatinator Port map(
				PC_in => PCPlus4,				   --For PC+4 4 MSB
				InstructionMem => instruction, --For Offset
				concatOut => JumpConcat		   --The Jump Offset Address
				);
	MUXJumpRegOrOffset: MUX32bit	Port map(
					high	 => storeOut,
					low	 => JumpConcat,
					selector => JRControl,
					out_put  => out_JumpAddr

				);
	ShiftExtend: component ShiftExtender
		port map(
			Instr16down   => immValue,
			ExtendedShamt => ExtendedShiftAmount,
		); 
	JUIExtend: component JUIExtender
		port map(
			Instr16down => immValue,
			UpperImm    => ExtendedJUI
		);
	
	Control:Controller 	Port map(			
				rt		=> regTarget,
				opSelect	=> opSelect,
				RegDst		=> out_RegDst,
				MemRead		=> out_MemRead,
				MemtoReg	=> out_MemtoReg,
				ALUOp		=> out_ALUOp,
				MemWrite	=> out_MemWrite,
				ALUSrc		=> out_ALUSrc,
				RegWrite	=> out_RegWrite,
				Branch		=> out_branch,
				Jump		=> out_jump,
				ShiftContr	=> out_shiftContr,
				wdataContr	=> out_wdataContr
				);

	InstructionRegFile:MUX5bit Port map(
				high		=> regDestF,
				low		=> regTarget,
				selector	=> RegDstC,
				out_put		=> output5
				);

	LoadCtrlReg: loadControl Port map(
				--loadOp=> ALUOp,
				loadOp=> opSelect,
				dataIn => rdata_1,
				dataOut => storeOut
				);
	Reg:regfile		Port map(
				clk	=>	clk,
				rst_s	=>	reset,
				we	=>	RegWrite,
				raddr_1 =>	regSource,
				raddr_2 =>	regTarget,
				waddr	=>	output5,
				rdata_1 =>	out_rdata_1,
				rdata_2 =>	out_rdata_2,
				wdata	=>	finalWriteData
				);	

	ALUControl:ALUFunc      Port map(
				ALUOp		=> ALUOp,
				FuncField	=> func,
				JRControl   => out_JRControl,----JRControl,
				out_put		=> out_ALUfunc--FuncIn
				);	
	SignExt:SignExtender 	Port map(
				in_put	=> immValue,
				out_put	=> out_ExtendedImmValue
				);
	cycleRegister :FetchRegister port map(	
				clk 		=>clk,          
				enable		=>reset,        
				opSelect 	=>opSelect,     
				regSource 	=>regSource,     
				regTarget 	=>regTarget,     
				regDest  	=>regDest,     
				func 	 	=>func,        
				immValue	=>immValue,      
				PCPlus4  	=>PCPlus4,      
				OUT_opSelect	 => out_opSelect, 
				OUT_regSource  	 => raddr_1,
				OUT_regTarget	 => raddr_2,
				OUT_regDest  	 => regDestF,
				OUT_func	 => FuncField,
				OUT_immValue 	 => immValueF,
				OUT_PCPlus4  	 => PCPlus4F
				);	

end behavior;