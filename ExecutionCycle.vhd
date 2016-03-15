library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ExecutionCycle is
	Port(
		--============INPUTS============--
		clk                  : IN std_logic;
		------------control bits--------------
		ForwardAE     : IN std_logic_vector(1 downto 0); --controls the hazard mux for ALU Ain
		ForwardBE     : IN std_logic_vector(1 downto 0); --controls the hazard mux for ALU Bin
		RegDst        : IN std_logic;
		MemRead       : IN std_logic;
		MemtoReg      : IN std_logic;
		ALUOp         : IN std_logic_vector(4 downto 0);
		MemWrite      : IN std_logic;
		ALUSrc        : IN std_logic;
		RegWrite      : IN std_logic;
		Branch        : IN std_logic;
		Jump          : IN std_logic;
		ShiftContr    : IN std_logic;
		wdataContr    : IN std_logic_vector(1 downto 0);
		JRControl     : IN std_logic;
		ALUFunc       : IN std_logic_vector(5 downto 0);
		opSelect      : IN std_logic_vector(5 downto 0);
		------------data path-----------------
		ForwardedALUM 		: IN std_logic_vector(31 downto 0); --ALUOutput from one cycle ahead
		ForwardedALUW 		: IN std_logic_vector(31 downto 0); --ALUOutput from two cycles ahead
		RData1        		: IN std_logic_vector(31 downto 0);
		RData2       		: IN std_logic_vector(31 downto 0);
		RegDestination    	: IN std_logic_vector(4 downto 0);
		RegTarget          	: IN std_logic_vector(4 downto 0);
		ExtendedImmValue   	: IN std_logic_vector(31 downto 0);
		ExtendedShiftAmount	: IN std_logic_vector(31 downto 0);
		ExtendedJUI         : IN std_logic_vector(31 downto 0);
		PCPlus4             : IN std_logic_vector(31 downto 0);
		PC                 	: IN std_logic_vector(31 downto 0);
		
		-------============output======================--
		--===============control path==================--
		OUT_MemRead              : OUT std_logic;
		OUT_MemtoReg             : OUT std_logic;
		OUT_MemWrite             : OUT std_logic;
		OUT_RegWrite             : OUT std_logic;
		OUT_Branch               : OUT std_logic;
		OUT_Jump                 : OUT std_logic;
		OUT_wdataContr           : OUT std_logic_vector(1 downto 0);

		--===============data path==================--
		OUT_ALUResult            : OUT std_logic_vector(31 downto 0);
		OUT_RData2               : OUT std_logic_vector(4 downto 0);
		OUT_RegisterWriteAddress : OUT std_logic_vector(4 downto 0);
		OUT_newPC				 : OUT std_logic_vector(31 downto 0);
		OUT_JumpAddress          : OUT std_logic_vector(31 downto 0);
		OUT_BranchAddress        : OUT std_logic_vector(31 downto 0);
		OUT_ExtendedJUI          : OUT std_logic_vector(31 downto 0);
		OUT_PC                   : OUT std_logic_vector(31 downto 0);

	);
end entity;

architecture behavior of ExecutionCycle is
	--the names are weird because I never thought I would use this component for another purpose
	component ExecutionRegister is
	Port(
		clk                      : IN  std_logic;
		--control path
		--control bits from the Controller
		MemRead                  : IN  std_logic;
		MemtoReg                 : IN  std_logic;
		MemWrite                 : IN  std_logic;
		RegWrite                 : IN  std_logic;
		Branch                   : IN  std_logic;
		Jump                     : IN  std_logic;
		wdataContr               : IN  std_logic_vector(1 downto 0);

		------------------------DATA PATH-------------------------
		ALUResult                : IN  std_logic_vector(31 downto 0);
		RData2                   : IN  std_logic_vector(4 downto 0);
		RegisterWriteAddress     : IN  std_logic_vector(4 downto 0);
		NewPC                    : IN  std_logic_vector(31 downto 0);
		JumpAddress              : IN  std_logic_vector(31 downto 0);
		BranchAddress            : IN  std_logic_vector(31 downto 0);
		ExtendedJUI              : IN  std_logic_vector(31 downto 0);
		PC                       : IN  std_logic_vector(31 downto 0);

		-----------------------OUTPUT SIGNALS----------------------
		OUT_MemRead              : OUT std_logic;
		OUT_MemtoReg             : OUT std_logic;
		OUT_MemWrite             : OUT std_logic;
		OUT_RegWrite             : OUT std_logic;
		OUT_Branch               : OUT std_logic;
		OUT_Jump                 : OUT std_logic;
		OUT_wdataContr           : OUT std_logic_vector(1 downto 0);
	
		OUT_ALUResult            : OUT std_logic_vector(31 downto 0);
		OUT_RData2               : OUT std_logic_vector(4 downto 0);
		OUT_RegisterWriteAddress : OUT std_logic_vector(4 downto 0);
		OUT_newPC				 : OUT std_logic_vector(31 downto 0);
		OUT_JumpAddress          : OUT std_logic_vector(31 downto 0);
		OUT_BranchAdress         : OUT std_logic_vector(31 downto 0);
		OUT_ExtendedJUI          : OUT std_logic_vector(31 downto 0);
		OUT_PC                   : OUT std_logic_vector(31 downto 0));
	end component;

	component MUX3to1
		port(NormalInput : IN  std_logic_vector(31 downto 0);
			 JUIInput    : IN  std_logic_vector(31 downto 0);
			 JALInput    : IN  std_logic_vector(31 downto 0);
			 selector    : IN  std_logic_vector(1 downto 0);
			 wdata       : OUT std_logic_vector(31 downto 0));
	end component MUX3to1;
--ALU
	component alu IS
	PORT(
		Func_in		: IN	std_logic_vector(5 DOWNTO 0);
		A_in		: IN	std_logic_vector(31 DOWNTO 0);
		B_in		: IN	std_logic_vector(31 DOWNTO 0);
		O_out		: OUT 	std_logic_vector(31 DOWNTO 0);
		Branch_out	: OUT	std_logic);
	end component alu;

	component loadControl
		port(loadOP  : IN  std_logic_vector(5 DOWNTO 0);
			 dataIn  : IN  std_logic_vector(31 DOWNTO 0);
			 dataOut : OUT std_logic_vector(31 DOWNTO 0));
	end component loadControl;
	
--BranchAndGate
	component ANDGate is
	Port(
		Ain	: IN std_logic;
		Bin : IN std_logic;
		Cout: OUT std_logic
	);
	end component ANDGate;
--ALUFunc
	component ALUFunc is
	Port(
		ALUOp		: IN std_logic_vector(4 downto 0);
		FuncField	: IN std_logic_vector(5 downto 0);
		JRControl	: OUT std_logic;
		ShiftContr	: OUT std_logic;
		out_put		: OUT std_logic_vector(5 downto 0)
	);
	end component ALUFunc;
--MUXBranchOrNot --MUXJumpRegOrOffset --RegALU --shiftmux
	component MUX32bit is
		Port(
			high	: IN std_logic_vector(31 downto 0);
			low		: IN std_logic_vector(31 downto 0);
			selector: IN std_logic;
			out_put	: OUT std_logic_vector(31 downto 0)
		);
	end component;
--SignExtender	
	component SignExtender is
		Port(
			in_put	: IN std_logic_vector(15 downto 0);
			out_put	: OUT std_logic_vector(31 downto 0) 
		);
	end component;
--address adder	
	component adder is
		Port(
			A_in	: IN std_logic_vector(31 downto 0);
			B_in	: IN std_logic_vector(31 downto 0);
			O_out	: OUT std_logic_vector(31 downto 0)
		);
	end component;
--InstructionRegFile	
	component MUX5bit is
		Port(
			high	: IN std_logic_vector(4 downto 0);
			low	: IN std_logic_vector(4 downto 0);
			selector: IN std_logic;
			out_put	: OUT std_logic_vector(4 downto 0)
		);
	end component;
--ShiftExtend	
	component ShiftExtender is
		Port(
			Instr16down	: IN std_logic_vector(15 downto 0);
			ExtendedShamt	: OUT std_logic_vector(31 downto 0)
		);
	end component;
--JUIExtender	
	component JUIExtender is
		Port(
			Instr16down	: IN std_logic_vector(15 downto 0);
			UpperImm	: OUT std_logic_vector(31 downto 0)
		);
	end component;
	
	--signal out of ForwardA--
	signal ForwardAOut : std_logic_vector(31 downto 0); --tier2Ain
	--signal out of ForwardB--
	signal ForwardBOut : std_logic_vector(31 downto 0);
	--signal out of LoadControl
	signal tier1Ain	: std_logic_vector(31 downto 0);
	--signal out of ShiftMux
	signal tier3Ain : std_logic_vector(31 downto 0);
	--signal out of InstructionRegFile
	signal RegDestE		: std_logic_vector(4 downto 0);
	--signal out of RegALU
	signal Bin			: std_logic_vector(31 downto 0);
	--signal out of ALU
	signal ALUResult		: std_logic_vector(31 downto 0);
	signal BranchResult		: std_logic;
	--signal out of BranchANDGate
	signal BranchDecider	: std_logic;
	--signal out of BranchAdder
	signal tier1BranchAddress	: std_logic_vector(31 downto 0);
	--signal out of MUXBranchOrNot
	signal tier2BranchAddress	: std_logic_vector(31 downto 0);
	--signal out of Concatenator for JUMP
	signal tier1JumpAddress		: std_logic_vector(31 downto 0);
	--signal out of MUXJumpRegOrOffset
	signal tier2JumpAddress		: std_logic_vector(31 downto 0);

begin
	ForwardA : component MUX3to1
		port map(
			NormalInput => RData1,
			JUIInput    => ForwardedALUM,
			JALInput    => ForwardedALUW,
			selector    => ForwardAE,
			wdata       => ForwardAOut
		);
	ForwardB : component MUX3to1
		port map(
			NormalInput => RData2,
			JUIInput    => ForwardedALUM,
			JALInput    => ForwardedALUW,
			selector    => ForwardBE,
			wdata       => ForwardBOut
		);
	ALU : component alu 
		port map(
			Func_in		=> ALUFunc,
			A_in		=> tier3Ain,
			B_in		=> Bin,
			O_out		=> ALUResult,
			Branch_out	=> BranchResult
	);
	LoadCtr: component loadControl
		port map(
			loadOP  => opSelect,
			dataIn  => RData1,
			dataOut => tier1Ain
		);
	BranchAndGate : component ANDGate 
		Port map(
			Ain		=> Branch,
			Bin 	=> BranchResult,
			Cout	=> BranchDecider
		);
	MUXBranchOrNot: component MUX32bit
		port map(
			high     => tier1BranchAddress,
			low      => PCPlus4,
			selector => BranchDecider,
			out_put  => tier2BranchAddress
		);
	MUXJumpRegOrOffset : component MUX32bit 
		Port map(
			high		=> Rdata1,
			low			=> tier1JumpAddress,
			selector	=> JRControl,
			out_put		=> tier2JumpAddress
		);
	RegALU : component MUX32bit 
		Port map(
			high	=> RData2, 
			low		=> ExtendedImmValue,
			selector	=> ALUSrc,
			out_put		=> Bin
		);
	shiftmux : component MUX32bit 
		Port map(
			high		=> ForwardAOut,
			low			=> ExtendedShiftAmount,
			selector	=> ShiftContr,
			out_put		=> tier3Ain
		);
	BranchAdder : component adder 
		Port map(
			A_in		=> PCPlus4,
			B_in		=> ExtendedImmValue,
			O_out		=> tier1BranchAddress
		);
	InstructionRegFile : component MUX5bit 
		Port map(
			high		=> RegDestination,
			low			=> RegTarget,
			selector	=> ALUSrc,
			out_put		=> RegDestE
		);
	ExecutionRegister : component ExecutionRegister 
		Port map(
		clk                      => clk,
		--control path
		--control bits from the Controller
		MemRead                  => MemRead,
		MemtoReg                 => MemtoReg,
		MemWrite                 => MemWrite,
		RegWrite                 => RegWrite,
		Branch                   => Branch,
		Jump                     => Jump,
		wdataContr               => wdataContr,

		------------------------DATA PATH-------------------------
		ALUResult                => ALUResult,
		RData2                   => RData2,
		RegisterWriteAddress     => RegDestE,
		NewPC                    => PCPlus4,
		JumpAddress              => tier2JumpAddress,
		BranchAddress            => tier2BranchAddress,
		ExtendedJUI              => ExtendedJUI,
		PC                       => PC,

		-----------------------OUTPUT SIGNALS----------------------
		OUT_MemRead              => OUT_MemRead,
		OUT_MemtoReg             => OUT_MemtoReg,
		OUT_MemWrite             => OUT_MemWrite,
		OUT_RegWrite             => OUT_RegWrite,
		OUT_Branch               => OUT_Branch,
		OUT_Jump                 => OUT_Jump,
		OUT_wdataContr           => OUT_wdataContr,

		OUT_ALUResult            => OUT_ALUResult,
		OUT_RData2               => OUT_RData2,
		OUT_RegisterWriteAddress => OUT_RegisterWriteAddress,
		OUT_JumpAddress          => OUT_JumpAddress,
		OUT_BranchAdress         => OUT_BranchAddress,
		OUT_ExtendedJUI          => OUT_ExtendedJUI,
		OUT_PC                   => OUT_PC
	);
end architecture;