library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--NOTE: MADE A SMALL ERROR, JUI SHOULD ACTUALLY BE LUI BUT TOO MANY TO FIX SO DEAL WITH IT

entity Processor is
	Port(
		ref_clk		: IN std_logic;
		reset		: IN std_logic
	);
end Processor;

architecture behavior of Processor is
-----------------------------component declaration-----------------------------------------------
	component alu IS
	PORT(
		Func_in		: IN	std_logic_vector(5 DOWNTO 0);
		A_in		: IN	std_logic_vector(31 DOWNTO 0);
		B_in		: IN	std_logic_vector(31 DOWNTO 0);
		O_out		: OUT 	std_logic_vector(31 DOWNTO 0);
		Branch_out	: OUT	std_logic
		--Jump_out	: OUT	std_logic
	);

	END component;
	------------------------------
	component ALUFunc is
		Port(
			ALUOp		: IN std_logic_vector(4 downto 0);
			FuncField	: IN std_logic_vector(5 downto 0);
			JRControl	: OUT std_logic;
			out_put		: OUT std_logic_vector(5 downto 0)
		);
	end component;
	------------------------------	
	component Controller is
		Port(
			rt			: IN std_logic_vector(4 downto 0);
			opSelect	: IN std_logic_vector(5 downto 0);
			RegDst		: OUT std_logic;
			MemRead		: OUT std_logic;
			MemtoReg	: OUT std_logic;
			ALUOp		: OUT std_logic_vector(4 downto 0);
			MemWrite	: OUT std_logic;
			ALUSrc		: OUT std_logic;
			RegWrite	: OUT std_logic;
			Branch		: OUT std_logic;
			Jump		: OUT std_logic;
			ShiftContr	: OUT std_logic;
			wdataContr	: OUT std_logic_vector(1 downto 0)
		);
	end component;
	------------------------------
	component dataMemory is --data memory
		port(
			clk 	: IN STD_LOGIC;
			we 	: IN STD_LOGIC;
			addr 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			dataI 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			dataO 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	end component;
	------------------------------
	component Decoder is
		Port(
			instruction 	: IN std_logic_vector(31 downto 0);
			opSelect 	: OUT std_logic_vector(5 downto 0);
			regSource 	: OUT std_logic_vector(4 downto 0);
			regTarget 	: OUT std_logic_vector(4 downto 0);
			regDest		: OUT std_logic_vector(4 downto 0);
			func		: OUT std_logic_vector(5 downto 0);
			immValue	: OUT std_logic_vector(15 downto 0)
		);
	end component;
	------------------------------
	component InstructionMemory is
		Port(
			addr	: IN std_logic_vector(31 downto 0);
			dataIO	: INOUT std_logic_vector(31 downto 0)
	);
	end component;
	------------------------------
	component MUX32bit is
		Port(
			high	: IN std_logic_vector(31 downto 0);
			low		: IN std_logic_vector(31 downto 0);
			selector: IN std_logic;
			out_put	: OUT std_logic_vector(31 downto 0)
		);
	end component;
	------------------------------
	component MUX5bit is
		Port(
			high	: IN std_logic_vector(4 downto 0);
			low	: IN std_logic_vector(4 downto 0);
			selector: IN std_logic;
			out_put	: OUT std_logic_vector(4 downto 0)
		);
	end component;
	
	------------------------------
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
	END component;
	------------------------------
	component SignExtender is
		Port(
			in_put	: IN std_logic_vector(15 downto 0);
			out_put	: OUT std_logic_vector(31 downto 0) 
		);
	end component;
	component PC is
		Port(
			clk		: IN std_logic;
			countUpdate: IN std_logic;
			countIn	: IN std_logic_vector(31 downto 0);
			counter	: OUT std_logic_vector(31 downto 0)
		);
	end component;
	component adder is
		Port(
			A_in	: IN std_logic_vector(31 downto 0);
			B_in	: IN std_logic_vector(31 downto 0);
			O_out	: OUT std_logic_vector(31 downto 0)
		);
	end component;
	component Concatinator is
		Port(
			PC_in	: IN std_logic_vector(31 downto 0);
			InstructionMem	: IN std_logic_vector(31 downto 0);
			concatOut		: OUT std_logic_vector(31 downto 0)
		);
	end component;
	component ANDGate is
		Port(
			Ain	: IN std_logic;
			Bin : IN std_logic;
			Cout: OUT std_logic
		);
	end component;
	component ShiftExtender is
		Port(
			Instr16down	: IN std_logic_vector(15 downto 0);
			ExtendedShamt	: OUT std_logic_vector(31 downto 0)
		);
	end component;
	component JUIExtender is
		Port(
			Instr16down	: IN std_logic_vector(15 downto 0);
			UpperImm	: OUT std_logic_vector(31 downto 0)
		);
	end component;
	component MUX3to1 is
		Port(
			NormalInput		: IN std_logic_vector(31 downto 0);
			JUIInput		: IN std_logic_vector(31 downto 0);
			JALInput		: IN std_logic_vector(31 downto 0);
			selector		: IN std_logic_vector(1 downto 0);
			wdata			: OUT std_logic_vector(31 downto 0)
		);
	end component;
	component ORgate is
		Port(
			Ain	: IN std_logic;
			Bin : IN std_logic;
			Cout: OUT std_logic
		);
	end component;
	component loadControl is 
		Port(
			loadOP: IN std_logic_vector(5 DOWNTO 0);
			dataIn: IN std_logic_vector(31 DOWNTO 0);
			dataOut: OUT std_logic_vector(31 DOWNTO 0)
		);
	end component; 

------------------------------------component end---------------------------------------------

------------------------------------signal declaration----------------------------------------

--------------------------instruction memory to decoder to reg file-------------------------
SIGNAL instruction		: std_logic_vector(31 DOWNTO 0);
SIGNAL immValue				: std_logic_vector(15 downto 0);
SIGNAL regSource,regTarget,regDest	: std_logic_vector(4 downto 0);
SIGNAL func, opSelect			: std_logic_vector(5 downto 0);
-------------------------------------------------------------------------------------
-----------------------------------------sign extender------------------------------------
SIGNAL extendedImm			: std_logic_vector(31 downto 0);
------------------------------------------------------------------------------------------
-----------------------------------signals out of regfile-----------------------------------
SIGNAL rdata_1, rdata_2			: std_logic_vector(31 DOWNTO 0);
----------------------------------------------------------------------------------
----------------------------------signals out of ALU-----------------------------------
SIGNAL	ALUresult			: std_logic_vector(31 DOWNTO 0);
SIGNAL BranchOut,JumpOut	: std_logic;
--------------------------------------------------------------------------------------------
-------------------------------------controller---------------------------------------------
SIGNAL	RegDst				: std_logic;
SIGNAL	MemRead				: std_logic;
SIGNAL	MemtoReg			: std_logic;
SIGNAL	ALUOp				: std_logic_vector(4 downto 0);
SIGNAL	MemWrite			: std_logic;
SIGNAL	ALUSrc				: std_logic;
SIGNAL	RegWrite			: std_logic;
SIGNAL  branch				: std_logic;
SIGNAL  jump				: std_logic;
SIGNAL  shiftContr			: std_logic;
SIGNAL  wdataContr			: std_logic_vector(1 downto 0);
--------------------------------------------------------------------------------------------
-------------------------------------signals out of mux after RAM---------------------------
SIGNAL output32AR				: std_logic_vector(31 downto 0);
--------------------------------------------------------------------------------------------
-------------------------------signals out of mux between ALU and regFile---------------
SIGNAL output32AD				: std_logic_vector(31 downto 0);
--------------------------------------------------------------------------------------------
--------------------------------signals out of mux between instruction and regfile----------
SIGNAL output5				: std_logic_vector(4 downto 0);
--------------------------------------------------------------------------------------------
-------------------------------signals out of concatenator-----------------------------
SIGNAL JumpConcat			: std_logic_vector(31 downto 0);
--------------------------------------------------------------------------------------------
-------------------------------signal out of branch AND gate---------------------------
SIGNAL branchdecider		: std_logic;
--------------------------------------------------------------------------------------------
-------------------------------signals out of Mux Branch or Not-----------------------------
SIGNAL BranchAddr			: std_logic_vector(31 downto 0);
--------------------------------------------------------------------------------------------
-------------------------------signals out of Mux Jump or Branch----------------------------
SIGNAL countIn				: std_logic_vector(31 downto 0);
--------------------------------------------------------------------------------------------
-------------------------------signals out of Mux Jump Reg or Offset------------------------ --TODO
SIGNAL JumpAddr				: std_logic_vector(31 downto 0);
--------------------------------------------------------------------------------------------
--------------------------signals out of alu func-------------------------------------------
SIGNAL FuncIn				: std_logic_vector(5 downto 0);
SIGNAL JRControl			: std_logic;
--------------------------------------------------------------------------------------------
-----------------------------------signals out of RAM---------------------------------------
SIGNAL RAMout				: std_logic_vector(31 downto 0);
--------------------------------------------------------------------------------------------
--Signals out of PC+adder
SIGNAL addr		: std_logic_vector(31 downto 0); --current accessing address
SIGNAL PCOut	: std_logic_vector(31 downto 0); --Incremented PC+4
SIGNAL countUpdate: std_logic;

----------------------------------reg file to data memory-----------------------------------
--SIGNAL	wdata_rd			: std_logic_vector(NBIT - 1 DOWNTO 0);
--------------------------------------------------------------------------------------------
----------------------------------data memory to reg file-----------------------------------
--SIGNAL	wdata_dr			: std_logic_vector(NBIT - 1 DOWNTO 0);
--------------------------------------------------------------------------------------------
-----------------------------------signals out of address adder-----------------------------
SIGNAL addrOffset				: std_logic_vector(31 downto 0);  --PC+4+Offset
--------------------------------------------------------------------------------------------
-----------------------------------signals out of ShiftExtender-----------------------------
SIGNAL ShiftAmount				: std_logic_vector(31 downto 0);
--------------------------------------------------------------------------------------------
-----------------------------------signals out of ShiftMux----------------------------------
SIGNAL ALUAin					: std_logic_vector(31 downto 0);
--------------------------------------------------------------------------------------------
-----------------------------------signals out of JUIExtender-------------------------------
SIGNAL UpperImm					: std_logic_vector(31 downto 0);
--------------------------------------------------------------------------------------------
-----------------------------------signals out of MUX3to1-----------------------------------
SIGNAL wdata					: std_logic_vector(31 downto 0);
--------------------------------------------------------------------------------------------
-----------------------------------signals out of loadControlRAM-------------------------------
--SIGNAL opsel					:std_logic_vector(5 downto 0);
--SIGNAL loadIn					:std_logic_vector(31 downto 0);
SIGNAL loadOut					:std_logic_vector(31 downto 0);
-------------------------------------signal end--------------------------------------------------
-----------------------------------signals out of loadControlReg------------------------------
SIGNAL storeOut					: std_logic_vector(31 downto 0);
----------------------------------------------------------------------------------------------


--------------------------------------Port map---------------------------------------------------
begin
	ROM:InstructionMemory 	Port map(
				addr		=> addr,
				dataIO 		=> instruction
				);
				
	Concatenator: Concatinator Port map(
				PC_in => PCOut,				   --For PC+4 4 MSB
				InstructionMem => instruction, --For Offset
				concatOut => JumpConcat		   --The Jump Offset Address
				);
	MUXJumpRegOrOffset: MUX32bit	Port map(
					high	=> storeOut,
					low		=> JumpConcat,
					selector => JRControl,
					out_put => JumpAddr
				);
	
	Decod:Decoder 		Port map(
				instruction => instruction,
				opSelect	=> opSelect,
				regSource 	=> regSource,
				regTarget 	=> regTarget,
				regDest		=> regDest,
				func		=> func,
				immValue	=> immValue
				);
	
	Control:Controller 	Port map(
				rt			=> regTarget,
				opSelect	=> opSelect,
				RegDst		=> RegDst,
				MemRead		=> MemRead,
				MemtoReg	=> MemtoReg,
				ALUOp		=> ALUOp,
				MemWrite	=> MemWrite,
				ALUSrc		=> ALUSrc,
				RegWrite	=> RegWrite,
				Branch		=> branch,
				Jump		=> jump,
				ShiftContr	=> shiftContr,
				wdataContr	=> wdataContr
				);
	
	ALUControl:ALUFunc 		Port map(
				ALUOp		=> ALUop,
				FuncField	=> func,
				JRControl   => JRControl,
				out_put		=> FuncIn
				);

	SignExt:SignExtender 	Port map(
				in_put	=> immValue,
				out_put	=> extendedImm
				);
	
	ALUs:alu 		Port map(
				Func_in		=> FuncIn,
				A_in		=> ALUAin,
				B_in		=> output32AD,
				O_out		=> ALUresult,
				Branch_out	=> BranchOut
				--Jump_out	=> JumpOut
				);
				
	BranchANDGate:ANDGate	Port map(
					Ain => branch,		--From the Controller
					Bin => branchOut,	--From the ALU
					Cout=> branchdecider --Goes to BranchOrNot Mux
				);
				
	AddrAdd:adder	Port map(
					A_in =>	PCOut, --PC+4 address(except we word addressable not byte)
					B_in => extendedImm, --offset in Instruction[15 downto 0]
					O_out	=> addrOffset --PC+4+offset
					);
					
	MUXBranchOrNot: MUX32bit	Port map(
						high	=>	addrOffset,
						low		=>  PCOut,
						selector => branchDecider,
						out_put	=>	BranchAddr
					);
	MUXJumpOrBranch: MUX32bit	Port map(
						high => BranchAddr,
						low	 => JumpAddr,
						selector => jump, --TODO add into signal list and update the controller
						out_put	=> countIn
	);

	RAMs:dataMemory		Port map(
				clk 		=> ref_clk,
				we 			=> MemWrite,
				addr 		=> ALUresult,
				dataI 		=> rdata_2,
				dataO 		=> RAMout
				);
	
	AfterRAM:MUX32bit		Port map(
				high		=> loadOut,
				low			=> ALUresult,
				selector	=> MemtoReg,
				out_put		=> output32AR
				);

	LoadCtrlRAM: loadControl  Port map(			-----Ivan Tried -----------------------------------
				--loadOp=> ALUOp,
				loadOp=> opSelect,
				dataIn=> RAMout,
				dataOut=> loadOut
				);
				
	LoadCtrlReg: loadControl Port map(
				--loadOp=> ALUOp,
				loadOp=> opSelect,
				dataIn => rdata_1,
				dataOut => storeOut
				);

	RegALU:MUX32bit Port map(
				high		=> extendedImm,
				low			=> rdata_2,
				selector	=> ALUsrc,
				out_put		=> output32AD
				);
	InstructionRegFile:MUX5bit Port map(
				high		=> regDest,
				low			=> regTarget,
				selector	=> RegDst,
				out_put		=> output5
				);
	Reg:regfile	Port map(
			clk		=>	ref_clk,
			rst_s	=>	reset,
			we		=>	RegWrite,
			raddr_1 =>	regSource,
			raddr_2 =>	regTarget,
			waddr	=>	output5,
			rdata_1 =>	rdata_1,
			rdata_2 =>	rdata_2,
			wdata	=>	wdata
			);						
	PCs:PC port map(
			clk => ref_clk,
			countUpdate => countUpdate, --TODO
			countIn => countIn,
			counter => addr
	);
	PCPlus4:Adder Port map(
			A_in => addr,
			B_in => std_logic_vector(to_unsigned(1,32)),
			O_out => PCOut
	);
	counttUpdateLogic: ORgate Port map(
			Ain	=> jump,
			Bin => branchdecider,
			Cout => countUpdate
	);
	
	--For Shift Logic
	ShiftExtend: ShiftExtender Port map(
			Instr16down => immValue,
			ExtendedShamt => ShiftAmount
	);
	ShiftMux: MUX32bit Port map(
			high => ShiftAmount,
			low	 => storeOut,
			selector => ShiftContr,
			out_put => ALUAin
	);
	--For JUI logic
	JUIExtend: JUIExtender Port map(
			Instr16down	=> immValue,
			UpperImm	=> UpperImm
	);
	wdataMUX: MUX3to1 Port map(
			NormalInput => output32AR,
			JUIInput	=> UpperImm,
			JALInput	=> PCOut,
			selector	=> wdataContr,
			wdata		=> wdata
	);
end architecture;

