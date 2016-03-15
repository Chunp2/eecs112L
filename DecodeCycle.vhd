library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity DecodeCycle is
	port(
		--------------     Inputs     ----------------------------------------------
		clk		: IN std_logic;
		flush		: IN std_logic;
		reset		: IN std_logic;
		instruction 	: IN std_logic_vector(31 downto 0);
		
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
		out_ExtendedJUI	:OUT std_logic_vector(31 downto 0); 
		out_ExtendedShiftAmount:OUT std_logic_vector(31 downto 0);
		--==================fetchregister ================
		out_regDestination: OUT std_logic_vector(4 DOWNTO 0);
		out_regTarget	: OUT std_logic_vector(4 DOWNTO 0)
		);
end entity DecodeCycle; 



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
	end component;
-------------------------------------------------------------------
	component JUIExtender
		port(Instr16down : IN  std_logic_vector(15 downto 0);
 			 UpperImm    : OUT std_logic_vector(31 downto 0));
	end component;
-------------------------------------------------------------------

	component DecodeRegister is
	Port(
		clk                     : IN  std_logic;
		flush			: IN  std_logic;
		------------------INPUTS---------------------
		--control path entries
		--control bits from the controller
		RegDst                  : IN  std_logic;
		MemRead                 : IN  std_logic;
		MemtoReg                : IN  std_logic;
		ALUOp                   : IN  std_logic_vector(4 downto 0);
		MemWrite                : IN  std_logic;
		ALUSrc                  : IN  std_logic;
		RegWrite                : IN  std_logic;
		Branch                  : IN  std_logic;
		Jump                    : IN  std_logic;
		ShiftContr              : IN  std_logic;
		wdataContr              : IN  std_logic_vector(1 downto 0);
		opSelect                : IN  std_logic_vector(5 downto 0);
		--control bits from ALUFunc
		JRControl               : IN  std_logic;
		ALUFunc                 : IN  std_logic_vector(5 downto 0);

		--data path entries
		--data entries from the Register File
		RData1                  : IN  std_logic_vector(31 downto 0);
		RData2                  : IN  std_logic_vector(31 downto 0);
		--data entries from Instruction Code data
		RegDestination          : IN  std_logic_vector(4 downto 0);
		RegTarget               : IN  std_logic_vector(4 downto 0);
		ExtendedImmValue        : IN  std_logic_vector(31 downto 0);
		ExtendedShiftAmount     : IN  std_logic_vector(31 downto 0);
		ExtendedJUI             : IN  std_logic_vector(31 downto 0);
		--data entry from PCPlus4
		PCPlus4                 : IN  std_logic_vector(31 downto 0);
		PC                      : IN  std_logic_vector(31 downto 0);

		--------------------OUTPUTS-------------------------
		--control bits out
		OUT_RegDst              : OUT std_logic;
		OUT_MemRead             : OUT std_logic;
		OUT_MemtoReg            : OUT std_logic;
		OUT_ALUOp               : OUT std_logic_vector(4 downto 0);
		OUT_MemWrite            : OUT std_logic;
		OUT_ALUSrc              : OUT std_logic;
		OUT_RegWrite            : OUT std_logic;
		OUT_Branch              : OUT std_logic;
		OUT_Jump                : OUT std_logic;
		OUT_ShiftContr          : OUT std_logic;
		OUT_wdataContr          : OUT std_logic_vector(1 downto 0);
		OUT_JRControl           : OUT std_logic;
		OUT_ALUFunc             : OUT std_logic_vector(5 downto 0);
		OUT_opSelect            : OUT std_logic_vector(5 downto 0);

		--data entries out
		OUT_RData1              : OUT std_logic_vector(31 downto 0);
		OUT_RData2              : OUT std_logic_vector(31 downto 0);
		OUT_RegDestination      : OUT std_logic_vector(4 downto 0);
		OUT_RegTarget           : OUT std_logic_vector(4 downto 0);
		OUT_ExtendedImmValue    : OUT std_logic_vector(31 downto 0);
		OUT_ExtendedShiftAmount : OUT std_logic_vector(31 downto 0);
		OUT_ExtendedJUI         : OUT std_logic_vector(31 downto 0);
		OUT_PCPlus4             : OUT std_logic_vector(31 downto 0);
		OUT_PC                  : OUT std_logic_vector(31 downto 0)
		);
	end component;
	
----------------------------------signal decleration ----------------------------------------------------
-------------------------------------controller---------------------------------------------
SIGNAL RegDstC				: std_logic;
SIGNAL ALUOp				: std_logic_vector(4 downto 0);		
SIGNAL MemRead				: std_logic;					--1 is read from RAM 0 is don't read from RAM
SIGNAL MemtoReg				: std_logic;					--1 is write using RAM data, 0 is write using ALU output
SIGNAL ALUOpC				: std_logic_vector(4 downto 0); 
SIGNAL MemWrite				: std_logic;					--1 is write into RAM, 0 is don't write into RAM
SIGNAL ALUSrc				: std_logic;					--1 is ALU Bin is immediate value, 0 is ALU Bin is Register data
SIGNAL RegWriteC				: std_logic;					--1 is write into Register, 0 is don't write into register
SIGNAL Branch				: std_logic;					--1 is the cycle is a branch cycle, 0 is not branch cycle
SIGNAL Jump				: std_logic;					--1 is the cycle is a jump cycle, 0 is not a jump cycle
SIGNAL ShiftContr			: std_logic;
SIGNAL wdataContr			: std_logic_vector(1 downto 0);
-------------------------------------FetchRegister---------------------------------------------
SIGNAL opSelectF			: std_logic_vector(5 downto 0);
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
Signal JRControlA			: std_logic;
SIGNAL FuncFieldA			:  std_logic_vector(5 downto 0);
----------------------------------Mux5to1 output---------------------------------
SIGNAL output5				: std_logic_vector(4 downto 0);
----------------------------------signals out of signextender---------------------------------
SIGNAL extendImmS			: std_logic_vector(31 downto 0);
----------------------------------signals out of shiftExtender---------------------------------
SIGNAL ExtendedShiftAmount		: std_logic_vector(31 downto 0);
----------------------------------signals out of JuiExtender---------------------------------
SIGNAL ExtendedJUI				: std_logic_vector(31 downto 0);
-------------------------------------signal end--------------------------------------------------

-------------------------------------PortMap--------------------------------------------------
begin	
	Concatenator: Concatinator Port map(
				PC_in => PCPlus4,		--For PC+4 4 MSB
				InstructionMem => instruction,  --For Offset
				concatOut => JumpConcat		--The Jump Offset Address
				);
	MUXJumpRegOrOffset: MUX32bit	Port map(
					high	 => storeOut,
					low	 => JumpConcat,
					selector => JRControlA,
					out_put  => out_JumpAddr
				);	
	ShiftExtend: ShiftExtender	port map(
			Instr16down   => immValue,
			ExtendedShamt => ExtendedShiftAmount
		); 
	JUIExtend:JUIExtender 		port map(
			Instr16down => immValue,
			UpperImm    => ExtendedJUI
		);
	Control:Controller 	Port map(			
				rt		=> regTarget,
				opSelect	=> opSelect,
				RegDst		=> RegDstC,
				MemRead		=> MemRead,
				MemtoReg	=> MemtoReg,
				ALUOp		=> ALUOp,
				MemWrite	=> MemWrite,
				ALUSrc		=> ALUSrc,
				RegWrite	=> RegWriteC,
				Branch		=> branch,
				Jump		=> jump,
				ShiftContr	=> shiftContr,
				wdataContr	=> wdataContr
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
				ALUOp		=> ALUOpC,
				FuncField	=> func,
				JRControl   	=> out_JRControl,----JRControl,
				out_put		=> out_ALUfunc--FuncIn
				);	
	SignExt:SignExtender 	Port map(
				in_put	=> immValue,
				out_put	=> extendImmS
				);
	cycleExecute:DecodeRegister port map(	
			
		clk                     =>clk,
		flush			=>flush,		
		------------------INPUTS---------------------
		--control path entries
		--control bits from the controller
		RegDst                  =>RegDstC,
		MemRead                 =>MemRead,
		MemtoReg                =>MemtoReg,
		ALUOp                   =>ALUOpC,
		MemWrite                =>MemWrite,
		ALUSrc                  =>ALUSrc,
		RegWrite                =>RegWrite,
		Branch                  =>Branch,
		Jump                    =>Jump,
		ShiftContr              =>ShiftContr,
		wdataContr              =>wdataContr,
		opSelect                =>opSelectF,
		--control bits from ALUFunc
		JRControl               =>JRControlA,
		ALUFunc                 =>FuncFieldA,

		--data path entries
		--data entries from the Register File
		RData1                  =>rdata_1,
		RData2                  =>rdata_2,
		--data entries from Instruction Code data
		RegDestination          =>output5,
		RegTarget               =>regTarget,
		ExtendedImmValue        =>extendImmS,
		ExtendedShiftAmount     =>ExtendedShiftAmount,
		ExtendedJUI             =>ExtendedJUI,
		--data entry from PCPlus4
		PCPlus4                 =>PCPlus4,
		PC                      =>PC,

		--------------------OUTPUTS-------------------------
		--control bits out
		OUT_RegDst              =>out_RegDst,
		OUT_MemRead             =>out_MemRead,
		OUT_MemtoReg            =>out_MemtoReg,
		OUT_ALUOp               =>out_ALUOP,
		OUT_MemWrite            =>out_MemWrite,
		OUT_ALUSrc              =>out_ALUSrc,
		OUT_RegWrite            =>out_RegWrite,
		OUT_Branch              =>out_Branch,
		OUT_Jump                =>out_Jump,
		OUT_ShiftContr          =>out_ShiftContr,
		OUT_wdataContr          =>out_wdataContr,
		OUT_JRControl           =>out_JRControl,
		OUT_ALUFunc             =>out_ALUFunc,
		OUT_opSelect            =>out_opSelect,

		--data entries out
		OUT_RData1              =>OUT_rdata_1,
		OUT_RData2              =>out_rdata_2,
		OUT_RegDestination      =>out_regDestination,
		OUT_RegTarget           =>out_regTarget,
		OUT_ExtendedImmValue    =>out_ExtendedImmValue,
		OUT_ExtendedShiftAmount =>out_ExtendedShiftAmount,
		OUT_ExtendedJUI         =>out_ExtendedJUI,
		OUT_PCPlus4             =>out_PCPlus4,
		OUT_PC                  =>out_PC
		);
end behavior;