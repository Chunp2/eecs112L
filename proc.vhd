library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity proc is
	Port(
		ref_clk   : IN std_logic;
		reset : IN std_logic;
		enable : IN std_logic;
		finalOutput: OUT std_logic_vector(31 downto 0)
	);
end entity;

architecture behavior of proc is
	component HazardUnit
		port(
			 clk	     : IN  std_logic;
			 RegWriteE   : IN  std_logic;
			 RegWriteM   : IN  std_logic;
			 RegWriteW   : IN  std_logic;
			 MemToRegM   : IN  std_logic;
			 MemRead     : IN  std_logic;
			 Branch      : IN  std_logic;
			 RegSourceD  : IN  std_logic_vector(4 downto 0);
			 RegTargetD  : IN  std_logic_vector(4 downto 0);
			 RegSourceF  : IN  std_logic_vector(4 downto 0);
			 RegTargetF  : IN  std_logic_vector(4 downto 0);
			 RegDestE    : IN  std_logic_vector(4 downto 0);
			 RegDestW    : IN  std_logic_vector(4 downto 0);
			 RegDestM    : IN  std_logic_vector(4 downto 0);
			 ForwardBE   : OUT std_logic_vector(1 downto 0) := "00";
			 ForwardAE   : OUT std_logic_vector(1 downto 0) := "00";
			 DecodeFlush : OUT std_logic                    := '0';
			 FetchStall  : OUT std_logic                    := '0';
			 PCStall     : OUT std_logic                    := '0');
	end component HazardUnit;

	component FetchCycle
		port(clk                 : IN  std_logic;
			 enable		    : IN std_logic;
			 newPC           : IN  std_logic_vector(31 downto 0);
			 countUpdateWBCycle  : IN  std_logic;
			 OUT_opSelect        : OUT std_logic_vector(5 downto 0);
			 OUT_regSource       : OUT std_logic_vector(4 downto 0);
			 OUT_regTarget       : OUT std_logic_vector(4 downto 0);
			 OUT_regDest         : OUT std_logic_vector(4 downto 0);
			 OUT_func            : OUT std_logic_vector(5 downto 0);
			 OUT_immValue        : OUT std_logic_vector(15 downto 0);
			 OUT_PCPlus4         : OUT std_logic_vector(31 downto 0);
			 OUT_instruction     : OUT std_logic_vector(31 downto 0);
			 OUT_PC		     : OUT std_logic_vector(31 downto 0)		
		);
			
	end component FetchCycle;

	component DecodeCycle
		port(clk                     : IN  std_logic;
			 flush                   : IN  std_logic;
			 reset                   : IN  std_logic;
			 instruction             : IN  std_logic_vector(31 downto 0);
			 opSelect                : IN  std_logic_vector(5 downto 0);
			 regSource               : IN  std_logic_vector(4 downto 0);
			 regTarget               : IN  std_logic_vector(4 downto 0);
			 regDest                 : IN  std_logic_vector(4 downto 0);
			 func                    : IN  std_logic_vector(5 downto 0);
			 immValue                : IN  std_logic_vector(15 downto 0);
			 PCPlus4                 : IN  std_logic_vector(31 downto 0);
			 finalWriteData          : IN  std_logic_vector(31 downto 0);
			 regWrite                : IN  std_logic;
			 PC			 : IN  std_logic_vector(31 downto 0);
			 out_PCPlus4             : OUT std_logic_vector(31 downto 0);
			 out_PC                  : OUT std_logic_vector(31 downto 0);
			 out_RegDst              : OUT std_logic;
			 out_MemRead             : OUT std_logic;
			 out_MemtoReg            : OUT std_logic;
			 out_ALUOp               : OUT std_logic_vector(4 downto 0);
			 out_MemWrite            : OUT std_logic;
			 out_ALUSrc              : OUT std_logic;
			 out_RegWrite            : OUT std_logic;
			 out_Branch              : OUT std_logic;
			 out_Jump                : OUT std_logic;
			 out_ShiftContr          : OUT std_logic;
			 out_wdataContr          : OUT std_logic_vector(1 downto 0);
			 out_opSelect            : OUT std_logic_vector(5 downto 0);
			 out_rdata_1             : OUT std_logic_vector(31 DOWNTO 0);
			 out_rdata_2             : OUT std_logic_vector(31 DOWNTO 0);
			 out_JumpAddr            : OUT std_logic_vector(31 DOWNTO 0);
			 out_JRControl           : OUT std_logic;
			 out_ALUfunc             : OUT std_logic_vector(5 DOWNTO 0);
			 out_ExtendedImmValue    : OUT std_logic_vector(31 DOWNTO 0);
			 out_ExtendedJUI         : OUT std_logic_vector(31 downto 0);
			 out_ExtendedShiftAmount : OUT std_logic_vector(31 downto 0);
			 out_regDestination      : OUT std_logic_vector(4 DOWNTO 0);
			 out_regTarget           : OUT std_logic_vector(4 DOWNTO 0));
	end component DecodeCycle;

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
			 ALUFuncCode              : IN  std_logic_vector(5 downto 0);
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
			 OUT_opSelect		  : OUT std_logic_vector(5 downto 0);
			 OUT_wdataContr           : OUT std_logic_vector(1 downto 0);
			 OUT_ALUResult            : OUT std_logic_vector(31 downto 0);
			 OUT_RData2               : OUT std_logic_vector(31 downto 0);
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
			 MemWrite             : IN  std_logic;
			 RegWrite             : IN  std_logic;
			 Branch               : IN  std_logic;
			 Jump                 : IN  std_logic;
			 wdataContr           : IN  std_logic_vector(1 downto 0);
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
			 HazardForwarded	  : OUT std_logic_vector(31 downto 0);
			 FinalWriteData       : OUT std_logic_vector(31 downto 0));
	end component writeBackCycle;
	--signals out of Fetch Cycle
	signal opSelectF                          : std_logic_vector(5 downto 0);
	signal regSourceF, regTargetF, regDestF   : std_logic_vector(4 downto 0);
	signal funcF                              : std_logic_vector(5 downto 0);
	signal immValueF                          : std_logic_vector(15 downto 0);
	signal PCPlus4F                           : std_logic_vector(31 downto 0);
	signal instructionF                       : std_logic_vector(31 downto 0);
	signal PCF				  : std_logic_vector(31 downto 0);
	--signals out of Decode Cycle
	signal PCPlus4D                           : std_logic_vector(31 downto 0);
	signal PCD                                : std_logic_vector(31 downto 0);
	signal regDestD, regSourceD, regTargetD   : std_logic_vector(4 downto 0);
	signal MemReadD, MemtoRegD, MemWriteD     : std_logic;
	signal ALUOpD                             : std_logic_vector(4 downto 0);
	signal ALUSrcD, regWriteD, BranchD, JumpD : std_logic;
	signal ShiftContrD			  : std_logic; 	
	signal wDataContrD          		  : std_logic_vector(1 downto 0);
	signal opSelectD                          : std_logic_vector(5 downto 0);
	signal rData1D, rData2D                   : std_logic_vector(31 downto 0);
	signal JumpAddressD                       : std_logic_vector(31 downto 0);
	signal JRControlD                         : std_logic;
	signal ALUFuncD                           : std_logic_vector(5 downto 0);
	signal ExtendedImmValueD                  : std_logic_vector(31 downto 0);
	signal ExtendedJUID                       : std_logic_vector(31 downto 0);
	signal ExtendedShamtD                     : std_logic_vector(31 downto 0);
	signal regDestControlD                    : std_logic;
	--signals out of Execution Cycle
	signal opSelectE                          : std_logic_vector(5 downto 0);
	signal MemReadE, MemToRegE, MemWriteE     : std_logic;
	signal RegWriteE, BranchE, JumpE          : std_logic;
	signal wdataContrE                        : std_logic_vector(1 downto 0);
	signal ALUResultE                         : std_logic_vector(31 downto 0);
	signal RData2E                            : std_logic_vector(31 downto 0);
	signal RegDestinationE                    : std_logic_vector(4 downto 0);
	signal newPCE                             : std_logic_vector(31 downto 0);
	signal JumpAddressE                       : std_logic_vector(31 downto 0);
	signal BranchAddressE                     : std_logic_vector(31 downto 0);
	signal ExtendedJUIE                       : std_logic_vector(31 downto 0);
	signal PCE                                : std_logic_vector(31 downto 0);
	--signals out of WriteBack Cycle
	signal regWriteW, MemToRegW               : std_logic;
	signal PCUpdateControlW                   : std_logic;
	signal ALUOutW                            : std_logic_vector(31 downto 0);
	signal ReadDataW                          : std_logic_vector(31 downto 0);
	signal RegDestW                           : std_logic_vector(4 downto 0);
	signal PCPlus4W                           : std_logic_vector(31 downto 0);
	signal HazardForwardedW                   : std_logic_vector(31 downto 0);
	signal FinalWriteData                     : std_logic_vector(31 downto 0);
	--signals out of HazardUnit
	signal ForwardAE, ForwardBE               : std_logic_vector(1 downto 0);
	signal DecodeFlush, FetchStall, PCStall   : std_logic;

begin
	Fetch : component FetchCycle
		port map(
			clk                => ref_clk,
			enable             => PCStall,
			newPC              => PCPlus4W,
			countUpdateWBCycle => PCUpdateControlW,
			OUT_opSelect       => opSelectF,
			OUT_regSource      => regSourceF,
			OUT_regTarget      => regTargetF,
			OUT_regDest        => regDestF,
			OUT_func           => funcF,
			OUT_immValue       => immValueF,
			OUT_PCPlus4        => PCPlus4F,
			OUT_instruction    => instructionF,
			OUT_PC		   => PCF
		);

	Decode : component DecodeCycle
		port map(
			clk                     => ref_clk,
			flush                   => decodeFlush,
			reset                   => reset,
			instruction             => instructionF,
			opSelect                => opSelectF,
			regSource               => regSourceF,
			regTarget               => regTargetF,
			regDest                 => regDestF,
			func                    => funcF,
			immValue                => immValueF,
			PCPlus4                 => PCPlus4F,
			finalWriteData          => finalWriteData,
			regWrite                => regWriteW,
			PC			=> PCF,
			out_PCPlus4             => PCPlus4D,
			out_PC                  => PCD,
			out_RegDst              => regDestControlD,
			out_MemRead             => MemReadD,
			out_MemtoReg            => MemtoRegD,
			out_ALUOp               => ALUOpD,
			out_MemWrite            => MemWriteD,
			out_ALUSrc              => ALUSrcD,
			out_RegWrite            => RegWriteD,
			out_Branch              => BranchD,
			out_Jump                => JumpD,
			out_ShiftContr          => ShiftContrD,
			out_wdataContr          => wdataContrD,
			out_opSelect            => opSelectD,
			out_rdata_1             => rdata1D,
			out_rdata_2             => rdata2D,
			out_JumpAddr            => JumpAddressD,
			out_JRControl           => JRControlD,
			out_ALUfunc             => ALUfuncD,
			out_ExtendedImmValue    => ExtendedImmValueD,
			out_ExtendedJUI         => ExtendedJUID,
			out_ExtendedShiftAmount => ExtendedShamtD,
			out_regDestination      => regDestD,
			out_regTarget           => regTargetD
		);

	Execution : component ExecutionCycle
		port map(
			clk                      => ref_clk,
			ForwardAE                => ForwardAE,
			ForwardBE                => ForwardBE,
			RegDst                   => RegDestControlD,
			MemRead                  => MemReadD,
			MemtoReg                 => MemtoRegD,
			ALUOp                    => ALUOpD,
			MemWrite                 => MemWriteD,
			ALUSrc                   => ALUSrcD,
			RegWrite                 => RegWriteD,
			Branch                   => BranchD,
			Jump                     => JumpD,
			ShiftContr               => ShiftContrD,
			wdataContr               => wdataContrD,
			JRControl                => JRControlD,
			ALUFuncCode              => ALUFuncD,
			opSelect                 => opSelectD,
			ForwardedALUM            => ALUResultE,
			ForwardedALUW            => HazardForwardedW,
			RData1                   => RData1D,
			RData2                   => RData2D,
			RegDestination           => RegDestD,
			RegTarget                => RegTargetD,
			ExtendedImmValue         => ExtendedImmValueD,
			ExtendedShiftAmount      => ExtendedShamtD,
			ExtendedJUI              => ExtendedJUID,
			PCPlus4                  => PCPlus4D,
			PC                       => PCD,
			OUT_MemRead              => MemReadE,
			OUT_MemtoReg             => MemtoRegE,
			OUT_MemWrite             => MemWriteE,
			OUT_RegWrite             => RegWriteE,
			OUT_Branch               => BranchE,
			OUT_Jump                 => JumpE,
			OUT_opSelect             => opSelectE,
			OUT_wdataContr           => wdataContrE,
			OUT_ALUResult            => ALUResultE,
			OUT_RData2               => RData2E,
			OUT_RegisterWriteAddress => RegDestinationE,
			OUT_newPC                => newPCE,
			OUT_JumpAddress          => JumpAddressE,
			OUT_BranchAddress        => BranchAddressE,
			OUT_ExtendedJUI          => ExtendedJUIE,
			OUT_PC                   => PCE
		);
	WriteBack : component writeBackCycle
		port map(
			clk                  => ref_clk,
			MemRead              => MemReadE,
			MemtoReg             => MemtoRegE,
			MemWrite             => MemWriteE,
			RegWrite             => RegWriteE,
			Branch               => BranchE,
			Jump                 => JumpE,
			wdataContr           => wdataContrE,
			opSelect             => opSelectE,
			ALUResult            => ALUResultE,
			RData2               => RData2E,
			RegisterWriteAddress => RegDestinationE,
			JumpAddress          => JumpAddressE,
			BranchAddress        => BranchAddressE,
			ExtendedJUI          => ExtendedJUIE,
			PC                   => PCE,
			out_regWrite         => regWriteW,
			out_memtoRegW        => memtoRegW,
			out_PCUpdateControl  => PCUpdateControlW,
			out_ALUoutW          => ALUoutW,
			out_ReadDataW        => ReadDataW,
			out_writeReg         => RegDestW,
			out_newPC            => PCPlus4W,
			HazardForwarded      => HazardForwardedW,
			FinalWriteData       => FinalWriteData
		);
	Hazard : component HazardUnit
		port map(
			clk	    => ref_clk,
			RegWriteE   => RegWriteD,
			RegWriteM   => RegWriteE,
			RegWriteW   => RegWriteW,
			MemToRegM   => MemToRegD,
			MemRead     => MemReadD,
			Branch      => BranchE,
			RegSourceD  => RegSourceD,
			RegTargetD  => RegTargetD,
			RegSourceF  => RegSourceF,
			RegTargetF  => RegTargetF,
			RegDestE    => RegDestD,
			RegDestW    => RegDestW,
			RegDestM    => RegDestinationE,
			ForwardBE   => ForwardBE,
			ForwardAE   => ForwardAE,
			DecodeFlush => DecodeFlush,
			FetchStall  => FetchStall,
			PCStall     => PCStall
		);
		finalOutput<= FinalWriteData;
end behavior;