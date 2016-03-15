library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity proc is
	Port(
		clk		: IN std_logic;
		
		
	);
end entity;

architecture behavior of proc is
	component HazardUnit
		port(WriteRegM   : IN  std_logic;
			 RegWriteE   : IN  std_logic;
			 RegWriteM   : IN  std_logic;
			 RegWriteW   : IN  std_logic;
			 MemToRegM   : IN  std_logic;
			 MemRead     : IN  std_logic;
			 Branch      : IN  std_logic;
			 RegSourceD  : IN  std_logic_vector(5 downto 0);
			 RegTargetD  : IN  std_logic_vector(5 downto 0);
			 RegSourceF  : IN  std_logic_vector(5 downto 0);
			 RegTargetF  : IN  std_logic_vector(5 downto 0);
			 RegDestE    : IN  std_logic_vector(5 downto 0);
			 RegDestW    : IN  std_logic_vector(5 downto 0);
			 RegDestM    : IN  std_logic_vector(5 downto 0);
			 ForwardBE   : OUT std_logic_vector(1 downto 0) := "00";
			 ForwardAE   : OUT std_logic_vector(1 downto 0) := "00";
			 DecodeFlush : OUT std_logic                    := 0;
			 FetchStall  : OUT std_logic                    := 0;
			 PCStall     : OUT std_logic                    := 0);
	end component HazardUnit;
	
	component FetchCycle
		port(clk                 : IN  std_logic;
			 out_newPC           : IN  std_logic_vector(31 downto 0);
			 out_PCUpdateControl : IN  std_logic;
			 countUpdateWBCycle  : IN  std_logic;
			 opSelect            : OUT std_logic_vector(5 downto 0);
			 regSource           : OUT std_logic_vector(4 downto 0);
			 regTarget           : OUT std_logic_vector(4 downto 0);
			 regDest             : OUT std_logic_vector(4 downto 0);
			 func                : OUT std_logic_vector(5 downto 0);
			 immValue            : OUT std_logic_vector(15 downto 0);
			 PCPlus4D            : OUT std_logic_vector(31 downto 0);
			 OUT_opSelect        : OUT std_logic_vector(5 downto 0);
			 OUT_regSource       : OUT std_logic_vector(4 downto 0);
			 OUT_regTarget       : OUT std_logic_vector(4 downto 0);
			 OUT_regDest         : OUT std_logic_vector(4 downto 0);
			 OUT_func            : OUT std_logic_vector(5 downto 0);
			 OUT_immValue        : OUT std_logic_vector(15 downto 0);
			 OUT_PCPlus4         : OUT std_logic_vector(31 downto 0));
	end component FetchCycle;
	
	component decode_stage
		port(clk                  : IN  std_logic;
			 reset                : IN  std_logic;
			 instruction          : IN  std_logic_vector(31 downto 0);
			 opSelect             : IN  std_logic_vector(5 downto 0);
			 regSource            : IN  std_logic_vector(4 downto 0);
			 regTarget            : IN  std_logic_vector(4 downto 0);
			 regDest              : IN  std_logic_vector(4 downto 0);
			 func                 : IN  std_logic_vector(5 downto 0);
			 immValue             : IN  std_logic_vector(15 downto 0);
			 PCPlus4              : IN  std_logic_vector(31 downto 0);
			 finalWriteData       : IN  std_logic_vector(31 downto 0);
			 regWrite             : IN  std_logic;
			 out_PCPlus4          : OUT std_logic_vector(31 downto 0);
			 out_PC               : OUT std_logic_vector(31 downto 0);
			 out_RegDst           : OUT std_logic;
			 out_MemRead          : OUT std_logic;
			 out_MemtoReg         : OUT std_logic;
			 out_ALUOp            : OUT std_logic_vector(4 downto 0);
			 out_MemWrite         : OUT std_logic;
			 out_ALUSrc           : OUT std_logic;
			 out_RegWrite         : OUT std_logic;
			 out_Branch           : OUT std_logic;
			 out_Jump             : OUT std_logic;
			 out_ShiftContr       : OUT std_logic;
			 out_wdataContr       : OUT std_logic_vector(1 downto 0);
			 out_opSelect         : OUT std_logic_vector(5 downto 0);
			 out_rdata_1          : OUT std_logic_vector(31 DOWNTO 0);
			 out_rdata_2          : OUT std_logic_vector(31 DOWNTO 0);
			 out_JumpAddr         : OUT std_logic_vector(31 DOWNTO 0);
			 out_JRControl        : OUT std_logic;
			 out_ALUfunc          : OUT std_logic_vector(5 DOWNTO 0);
			 out_ExtendedImmValue : OUT std_logic_vector(31 DOWNTO 0);
			 out_regDestination   : OUT std_logic_vector(4 DOWNTO 0);
			 out_regTarget        : OUT std_logic_vector(4 DOWNTO 0));
	end component decode_stage;
	
	component ExecutionCycle
		port(clk                      : IN  std_logic;
			 ForwardAE                : IN  std_logic_vector(1 downto 0);
			 ForwardBE                : IN  std_logic_vector(1 downto 0);
			 RegDst                   : IN  std_logic;
			 MemRead                  : IN  std_logic;
			 MemtoReg                 : IN  std_logic;
			 ALUOp                    : IN  std_logic_vector(4 downto 0);
			 MemWrite                 : IN  std_logic;
			 ALUSrc                   : IN  std_logic;
			 RegWrite                 : IN  std_logic;
			 Branch                   : IN  std_logic;
			 Jump                     : IN  std_logic;
			 ShiftContr               : IN  std_logic;
			 wdataContr               : IN  std_logic_vector(1 downto 0);
			 JRControl                : IN  std_logic;
			 ALUFunc                  : IN  std_logic_vector(5 downto 0);
			 opSelect                 : IN  std_logic_vector(5 downto 0);
			 ForwardedALUM            : IN  std_logic_vector(31 downto 0);
			 ForwardedALUW            : IN  std_logic_vector(31 downto 0);
			 RData1                   : IN  std_logic_vector(31 downto 0);
			 RData2                   : IN  std_logic_vector(31 downto 0);
			 RegDestination           : IN  std_logic_vector(4 downto 0);
			 RegTarget                : IN  std_logic_vector(4 downto 0);
			 ExtendedImmValue         : IN  std_logic_vector(31 downto 0);
			 ExtendedShiftAmount      : IN  std_logic_vector(31 downto 0);
			 ExtendedJUI              : IN  std_logic_vector(31 downto 0);
			 PCPlus4                  : IN  std_logic_vector(31 downto 0);
			 PC                       : IN  std_logic_vector(31 downto 0);
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
			 OUT_newPC                : OUT std_logic_vector(31 downto 0);
			 OUT_JumpAddress          : OUT std_logic_vector(31 downto 0);
			 OUT_BranchAddress        : OUT std_logic_vector(31 downto 0);
			 OUT_ExtendedJUI          : OUT std_logic_vector(31 downto 0);
			 OUT_PC                   : OUT std_logic_vector(31 downto 0));
	end component ExecutionCycle;
	
	component writeBackCycle
		port(clk                  : IN  std_logic;
			 MemRead              : IN  std_logic;
			 MemtoReg             : IN  std_logic;
			 ALUOp                : IN  std_logic_vector(4 downto 0);
			 MemWrite             : IN  std_logic;
			 RegWrite             : IN  std_logic;
			 Branch               : IN  std_logic;
			 Jump                 : IN  std_logic;
			 ShiftContr           : IN  std_logic;
			 wdataContr           : IN  std_logic_vector(1 downto 0);
			 JRControl            : IN  std_logic;
			 countUpdate          : IN  std_logic;
			 opSelect             : IN  std_logic_vector(5 downto 0);
			 ALUResult            : IN  std_logic_vector(31 downto 0);
			 RData2               : IN  std_logic_vector(31 downto 0);
			 RegisterWriteAddress : IN  std_logic_vector(4 downto 0);
			 JumpAddress          : IN  std_logic_vector(31 downto 0);
			 BranchAddress        : IN  std_logic_vector(31 downto 0);
			 ExtendedJUI          : IN  std_logic_vector(31 downto 0);
			 PC                   : IN  std_logic_vector(31 downto 0);
			 out_regWrite         : OUT std_logic;
			 out_memtoRegW        : OUT std_logic;
			 out_PCUpdateControl  : OUT std_logic;
			 out_ALUoutW          : OUT std_logic_vector(31 downto 0);
			 out_ReadDataW        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			 out_writeReg         : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
			 out_newPC            : OUT std_logic_vector(31 downto 0);
			 FinalWriteData       : OUT std_logic_vector(31 downto 0));
	end component writeBackCycle;
begin
	Fetch: component FetchCycle
		port map(
			clk                 => clk,
			out_newPC           => out_newPC,
			out_PCUpdateControl => out_PCUpdateControl,
			countUpdateWBCycle  => countUpdateWBCycle,
			opSelect            => opSelect,
			regSource           => regSource,
			regTarget           => regTarget,
			regDest             => regDest,
			func                => func,
			immValue            => immValue,
			PCPlus4D            => PCPlus4D,
			OUT_opSelect        => OUT_opSelect,
			OUT_regSource       => OUT_regSource,
			OUT_regTarget       => OUT_regTarget,
			OUT_regDest         => OUT_regDest,
			OUT_func            => OUT_func,
			OUT_immValue        => OUT_immValue,
			OUT_PCPlus4         => OUT_PCPlus4
		);
	Decode: component decode_stage
		port map(
			clk                  => clk,
			reset                => reset,
			instruction          => instruction,
			opSelect             => opSelect,
			regSource            => regSource,
			regTarget            => regTarget,
			regDest              => regDest,
			func                 => func,
			immValue             => immValue,
			PCPlus4              => PCPlus4,
			finalWriteData       => finalWriteData,
			regWrite             => regWrite,
			out_PCPlus4          => out_PCPlus4,
			out_PC               => out_PC,
			out_RegDst           => out_RegDst,
			out_MemRead          => out_MemRead,
			out_MemtoReg         => out_MemtoReg,
			out_ALUOp            => out_ALUOp,
			out_MemWrite         => out_MemWrite,
			out_ALUSrc           => out_ALUSrc,
			out_RegWrite         => out_RegWrite,
			out_Branch           => out_Branch,
			out_Jump             => out_Jump,
			out_ShiftContr       => out_ShiftContr,
			out_wdataContr       => out_wdataContr,
			out_opSelect         => out_opSelect,
			out_rdata_1          => out_rdata_1,
			out_rdata_2          => out_rdata_2,
			out_JumpAddr         => out_JumpAddr,
			out_JRControl        => out_JRControl,
			out_ALUfunc          => out_ALUfunc,
			out_ExtendedImmValue => out_ExtendedImmValue,
			out_regDestination   => out_regDestination,
			out_regTarget        => out_regTarget
		);
	Execution:component ExecutionCycle
		port map(
			clk                      => clk,
			ForwardAE                => ForwardAE,
			ForwardBE                => ForwardBE,
			RegDst                   => RegDst,
			MemRead                  => MemRead,
			MemtoReg                 => MemtoReg,
			ALUOp                    => ALUOp,
			MemWrite                 => MemWrite,
			ALUSrc                   => ALUSrc,
			RegWrite                 => RegWrite,
			Branch                   => Branch,
			Jump                     => Jump,
			ShiftContr               => ShiftContr,
			wdataContr               => wdataContr,
			JRControl                => JRControl,
			ALUFunc                  => ALUFunc,
			opSelect                 => opSelect,
			ForwardedALUM            => ForwardedALUM,
			ForwardedALUW            => ForwardedALUW,
			RData1                   => RData1,
			RData2                   => RData2,
			RegDestination           => RegDestination,
			RegTarget                => RegTarget,
			ExtendedImmValue         => ExtendedImmValue,
			ExtendedShiftAmount      => ExtendedShiftAmount,
			ExtendedJUI              => ExtendedJUI,
			PCPlus4                  => PCPlus4,
			PC                       => PC,
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
			OUT_newPC                => OUT_newPC,
			OUT_JumpAddress          => OUT_JumpAddress,
			OUT_BranchAddress        => OUT_BranchAddress,
			OUT_ExtendedJUI          => OUT_ExtendedJUI,
			OUT_PC                   => OUT_PC
		);
	WriteBack: component writeBackCycle
		port map(
			clk                  => clk,
			MemRead              => MemRead,
			MemtoReg             => MemtoReg,
			ALUOp                => ALUOp,
			MemWrite             => MemWrite,
			RegWrite             => RegWrite,
			Branch               => Branch,
			Jump                 => Jump,
			ShiftContr           => ShiftContr,
			wdataContr           => wdataContr,
			JRControl            => JRControl,
			countUpdate          => countUpdate,
			opSelect             => opSelect,
			ALUResult            => ALUResult,
			RData2               => RData2,
			RegisterWriteAddress => RegisterWriteAddress,
			JumpAddress          => JumpAddress,
			BranchAddress        => BranchAddress,
			ExtendedJUI          => ExtendedJUI,
			PC                   => PC,
			out_regWrite         => out_regWrite,
			out_memtoRegW        => out_memtoRegW,
			out_PCUpdateControl  => out_PCUpdateControl,
			out_ALUoutW          => out_ALUoutW,
			out_ReadDataW        => out_ReadDataW,
			out_writeReg         => out_writeReg,
			out_newPC            => out_newPC,
			FinalWriteData       => FinalWriteData
		);
	Hazard: component HazardUnit
		port map(
			WriteRegM   => WriteRegM,
			RegWriteE   => RegWriteE,
			RegWriteM   => RegWriteM,
			RegWriteW   => RegWriteW,
			MemToRegM   => MemToRegM,
			MemRead     => MemRead,
			Branch      => Branch,
			RegSourceD  => RegSourceD,
			RegTargetD  => RegTargetD,
			RegSourceF  => RegSourceF,
			RegTargetF  => RegTargetF,
			RegDestE    => RegDestE,
			RegDestW    => RegDestW,
			RegDestM    => RegDestM,
			ForwardBE   => ForwardBE,
			ForwardAE   => ForwardAE,
			DecodeFlush => DecodeFlush,
			FetchStall  => FetchStall,
			PCStall     => PCStall
		);
end behavior;