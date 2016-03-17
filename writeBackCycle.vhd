library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--Remember to communicate with whoever is doing the fetch cycle about the extra PC required to connect
entity writeBackCycle is
	Port(
		clk                  : IN  std_logic;
		------------------INPUTS-----------------
		--===============control path==================--
		MemRead              : IN  std_logic;
		MemtoReg             : IN  std_logic;
		MemWrite             : IN  std_logic;
		RegWrite             : IN  std_logic;
		Branch               : IN  std_logic;
		Jump                 : IN  std_logic;
		wdataContr           : IN  std_logic_vector(1 downto 0);
		opSelect             : IN  std_logic_vector(5 downto 0);

		--===============data path==================--
		ALUResult            : IN  std_logic_vector(31 downto 0);
		RData2               : IN  std_logic_vector(31 downto 0);
		RegisterWriteAddress : IN  std_logic_vector(4 downto 0);
		JumpAddress          : IN  std_logic_vector(31 downto 0);
		BranchAddress        : IN  std_logic_vector(31 downto 0);
		ExtendedJUI          : IN  std_logic_vector(31 downto 0);
		PC                   : IN  std_logic_vector(31 downto 0);

		--==============CYCLE OUTPUTS===============--
		out_regWrite         : OUT std_logic;
		out_memtoRegW        : OUT std_logic;
		out_PCUpdateControl  : OUT std_logic;
		out_ALUoutW          : OUT std_logic_vector(31 downto 0);
		out_ReadDataW        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		out_writeReg         : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		out_newPC            : OUT std_logic_vector(31 downto 0);
		HazardForwarded		 : OUT std_logic_vector(31 downto 0);
		FinalWriteData       : OUT std_logic_vector(31 downto 0)
	);
end writeBackCycle;

architecture behavior of writeBackCycle is
	component dataMemory
		port(clk   : IN  STD_LOGIC;
			 we    : IN  STD_LOGIC;
			 addr  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			 dataI : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			 dataO : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	end component;

	component MUX32bit
		port(high     : IN  std_logic_vector(31 downto 0);
			 low      : IN  std_logic_vector(31 downto 0);
			 selector : IN  std_logic;
			 out_put  : OUT std_logic_vector(31 downto 0));
	end component;

	component ORgate
		port(Ain  : IN  std_logic;
			 Bin  : IN  std_logic;
			 Cout : OUT std_logic);
	end component;

	component loadControl
		port(loadOP  : IN  std_logic_vector(5 DOWNTO 0);
			 dataIn  : IN  std_logic_vector(31 DOWNTO 0);
			 dataOut : OUT std_logic_vector(31 DOWNTO 0));
	end component;

	--component MUX3to1
	--	port(NormalInput : IN  std_logic_vector(31 downto 0);
	--		 JUIInput    : IN  std_logic_vector(31 downto 0);
	--		 JALInput    : IN  std_logic_vector(31 downto 0);
	--		 selector    : IN  std_logic_vector(1 downto 0);
	--		 wdata       : OUT std_logic_vector(31 downto 0));
	--end component;

	component writeRegister
		port(clk                 : in  STD_LOGIC;
			 regWrite            : in  STD_LOGIC;
			 memtoRegW           : in  STD_LOGIC;
			 PCUpdateControl     : in  std_logic;
			 ALUoutW             : in  std_logic_vector(31 downto 0);
			 ReadDataW           : in  std_logic_vector(31 downto 0);
			 writeReg            : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
			 newPC               : in  std_logic_vector(31 downto 0);
			 out_regWrite        : out std_logic;
			 out_memtoRegW       : out std_logic;
			 out_PCUpdateControl : out std_logic;
			 out_ALUoutW         : out std_logic_vector(31 downto 0);
			 out_ReadDataW       : out std_logic_vector(31 downto 0);
			 out_writeReg        : out STD_LOGIC_VECTOR(4 DOWNTO 0);
			 out_newPC           : out std_logic_vector(31 downto 0));
	end component;
	--===========================SIGNALS============================--
	--SIGNALS OUT OF DATAMEMORY--
	signal RAMOUT          : std_logic_vector(31 downto 0);
	--SIGNALS OUT OF MUXJUMPORBRANCH--
	signal newPC           : std_logic_vector(31 downto 0);
	--SIGNALS OUT OF LoadCtrlRam--
	signal tier2WriteData  : std_logic_vector(31 downto 0);
	--SIGNALS OUT OF COUNTUPDATELOGIC--
	signal PCUpdateControl : std_logic;
	--SIGNAL OUT OF AFTERRAMMUX--
	signal tier1WriteData  : std_logic_vector(31 downto 0);
	--signal for feeding back into cycle
	signal ReadDataW_In	: std_logic_vector(31 downto 0);
	signal ALUOutW_In	: std_logic_vector(31 downto 0);

begin
	RAM : component dataMemory
		port map(
			clk   => clk,
			we    => MemWrite,
			addr  => ALUResult,
			dataI => RData2,
			dataO => RAMOut
		);
	MUXJUMPORBRANCH : component MUX32bit
		port map(
			high     => JumpAddress,
			low      => BranchAddress,
			selector => Jump,
			out_put  => newPC
		);
	LoadCtrlRam : component loadControl
		port map(
			loadOP  => opSelect,
			dataIn  => ReadDataW_In,
			dataOut => tier1WriteData
		);
	COUNTUPDATELOGIC : component ORgate
		port map(
			Ain  => jump,
			Bin  => branch,
			Cout => PCUpdateControl
		);
	--WDATAMUX : component MUX3to1
	--	port map(
	--		NormalInput => tier2WriteData,
		--	JUIInput    => ExtendedJUI,
	--		JALInput    => PC,
	--		selector    => wdataContr,
	--		wdata       => FinalWriteData
	--	);
	AFTERRAMMUX : component MUX32bit
		port map(
			high     => tier1Writedata,
			low      => ALUOutW_In,
			selector => MemtoReg,
			out_put  => tier2WriteData
		);
	cycleRegister : component writeRegister
		port map(
			clk                 => clk,
			regWrite            => regWrite,
			memtoRegW           => MemtoReg,
			ALUoutW             => ALUResult,
			ReadDataW           => RAMOut,
			writeReg            => RegisterWriteAddress,
			newPC               => newPC,
			PCUpdateControl     => PCUpdateControl,
			out_regWrite        => out_regWrite,
			out_memtoRegW       => out_memtoRegW,
			out_PCUpdateControl => out_PCUpdateControl,
			out_ALUoutW         => ALUOutW_in,
			out_ReadDataW       => ReadDataW_In,
			out_writeReg        => out_writeReg,
			out_newPC           => out_newPC
		);
	FinalWriteData <= tier2WriteData;
	HazardForwarded <= tier2Writedata;
	out_ReadDataW <= ReadDataW_In;
	out_ALUOutW <= ALUOutW_In;
end behavior;