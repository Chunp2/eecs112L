library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity FetchCycle is
	Port(
		clk                : IN  std_logic;
		enable             : IN  std_logic;
		newPC              : IN  std_logic_vector(31 downto 0);
		countUpdateWBCycle : IN  std_logic;
		OUT_opSelect       : OUT std_logic_vector(5 downto 0);
		OUT_regSource      : OUT std_logic_vector(4 downto 0);
		OUT_regTarget      : OUT std_logic_vector(4 downto 0);
		OUT_regDest        : OUT std_logic_vector(4 downto 0);
		OUT_func           : OUT std_logic_vector(5 downto 0);
		OUT_immValue       : OUT std_logic_vector(15 downto 0);
		OUT_PCPlus4        : OUT std_logic_vector(31 downto 0);
		OUT_instruction	   : OUT std_logic_vector(31 downto 0);
		OUT_PC		   : OUT std_logic_vector(31 downto 0)
	);
end FetchCycle;

architecture behavior of FetchCycle is
	component InstructionMemory
		port(
			addr   : IN    std_logic_vector(31 downto 0);
			dataIO : INOUT std_logic_vector(31 downto 0)
		);
	end component;

	component Decoder
		port(instruction : IN  std_logic_vector(31 downto 0);
			 opSelect    : OUT std_logic_vector(5 downto 0);
			 regSource   : OUT std_logic_vector(4 downto 0);
			 regTarget   : OUT std_logic_vector(4 downto 0);
			 regDest     : OUT std_logic_vector(4 downto 0);
			 func        : OUT std_logic_vector(5 downto 0);
			 immValue    : OUT std_logic_vector(15 downto 0));
	end component;

	component FetchRegister
		port(    clk           : IN  std_logic;
			 enable        : IN  std_logic;
			 opSelect      : IN  std_logic_vector(5 downto 0);
			 regSource     : IN  std_logic_vector(4 downto 0);
			 regTarget     : IN  std_logic_vector(4 downto 0);
			 regDest       : IN  std_logic_vector(4 downto 0);
			 func          : IN  std_logic_vector(5 downto 0);
			 immValue      : IN  std_logic_vector(15 downto 0);
			 instruction   : IN  std_logic_vector(31 downto 0);			
			 PCPlus4       : IN  std_logic_vector(31 downto 0);
			 PC	       : IN  std_logic_vector(31 downto 0);
			 OUT_opSelect  : OUT std_logic_vector(5 downto 0);
			 OUT_regSource : OUT std_logic_vector(4 downto 0);
			 OUT_regTarget : OUT std_logic_vector(4 downto 0);
			 OUT_regDest   : OUT std_logic_vector(4 downto 0);
			 OUT_func      : OUT std_logic_vector(5 downto 0);
			 OUT_immValue  : OUT std_logic_vector(15 downto 0);
			 OUT_PCPlus4   : OUT std_logic_vector(31 downto 0);
			 OUT_instruction : OUT std_logic_vector(31 downto 0);
			 OUT_PC		: OUT std_logic_vector(31 downto 0)
			);
	end component;

	component Adder
		port(
			A_in  : IN  std_logic_vector(31 downto 0);
			B_in  : IN  std_logic_vector(31 downto 0);
			O_out : Out std_logic_vector(31 downto 0)
		);
	end component;

	component PC
		port(
			clk         : IN  std_logic;
			enable	    : IN  std_logic;
			countUpdate : IN  std_logic;
			countIn     : IN  std_logic_vector(31 downto 0); --PC Prime 
			counter     : OUT std_logic_vector(31 downto 0)
		);
	end component;

	--===========================SIGNALS============================--
	--To instruction memory--
	signal programCounter_Sig   : std_logic_vector(31 downto 0);
	--To program counter--
	signal programCounter_Prime : std_logic_vector(31 downto 0);
	--To instruction memory--
	signal to_Decoder           : std_logic_vector(31 downto 0);
	--PC Plus 4 to Fetch register --
	signal PCPlus4              : std_logic_vector(31 downto 0);
	-- DECODER SIGNALS--
	signal opSelectSig          : std_logic_vector(5 downto 0);
	signal regSourceSig         : std_logic_vector(4 downto 0);
	signal regTargetSig         : std_logic_vector(4 downto 0);
	signal regDestSig           : std_logic_vector(4 downto 0);
	signal funcSig              : std_logic_vector(5 downto 0);
	signal immValueSig          : std_logic_vector(15 downto 0);

begin
	instMem : component InstructionMemory
		port map(
			addr   => programCounter_Sig,
			dataIO => to_Decoder
		);
	decodr : component Decoder
		port map(
			instruction => to_Decoder,
			opSelect    => opSelectSig,
			regSource   => regSourceSig,
			regTarget   => regTargetSig,
			regDest     => regDestSig,
			func        => funcSig,
			immValue    => immValueSig
		);

	ftchReg : component FetchRegister
		port map(
			clk           => clk,
			enable	      => enable,
			opSelect      => opSelectSig,
			regSource     => regSourceSig,
			regTarget     => regTargetSig,
			regDest       => regDestSig,
			func          => funcSig,
			immValue      => immValueSig,
			PCPlus4       => PCPlus4,
			instruction	  => to_Decoder,
			PC	      => programcounter_sig,
			OUT_opSelect  => OUT_opSelect,
			OUT_regSource => OUT_regSource,
			OUT_regTarget => OUT_regTarget,
			OUT_regDest   => OUT_regDest,
			OUT_func      => OUT_func,
			OUT_immValue  => OUT_immValue,
			OUT_PCPlus4   => OUT_PCPlus4,
			OUT_instruction => OUT_instruction,
			OUT_PC	      => OUT_PC
		);
	PC_PlusOne : component Adder
		port map(
			A_in  => programCounter_Sig,
			B_in  => std_logic_vector(to_unsigned(1, 32)),
			O_out => PCPlus4
		);

	programCounter : component PC
		port map(
			clk         => clk,
			enable      => enable,
			countUpdate => countUpdateWBCycle,
			countIn     => programCounter_Prime,
			counter     => programCounter_Sig
		);
end behavior;	

