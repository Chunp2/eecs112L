library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ExecutionRegister is
	Port(
		clk            : IN std_logic;
		--control path
		--control bits from the Controller
		MemRead        : IN std_logic;
		MemtoReg       : IN std_logic;
		ALUOp          : IN std_logic_vector(4 downto 0);
		MemWrite       : IN std_logic;
		RegWrite       : IN std_logic;
		Branch         : IN std_logic;
		Jump           : IN std_logic;
		ShiftContr     : IN std_logic;
		wdataContr     : IN std_logic_vector(1 downto 0);
		--RegDst                  : IN  std_logic; used already
		--ALUSrc                  : IN  std_logic; used already

		--control bits from ALUFunc
		JRControl      : IN std_logic;
		ALUFunc        : IN std_logic_vector(5 downto 0);
		--control bits from branch/jump Path
		countUpdate		: IN std_logic;

		------------------------DATA PATH-------------------------
		ALUResult      : IN std_logic_vector(31 downto 0);
		RegDestination : IN std_logic_vector(4 downto 0);
		RegTarget      : IN std_logic_vector(4 downto 0);
		NewPC			: IN std_logic_vector(31 downto 0)
	);
end entity;


