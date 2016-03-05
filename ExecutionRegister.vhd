library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ExecutionRegister is
	Port(  
		clk                      : IN  std_logic;
		--control path
		--control bits from the Controller
		MemRead                  : IN  std_logic;
		MemtoReg                 : IN  std_logic;
		ALUOp                    : IN  std_logic_vector(4 downto 0);
		MemWrite                 : IN  std_logic;
		RegWrite                 : IN  std_logic;
		Branch                   : IN  std_logic;
		Jump                     : IN  std_logic;
		ShiftContr               : IN  std_logic;
		wdataContr               : IN  std_logic_vector(1 downto 0);
		--RegDst                  : IN  std_logic; used already
		--ALUSrc                  : IN  std_logic; used already

		--control bits from ALUFunc
		JRControl                : IN  std_logic;
		ALUFunc                  : IN  std_logic_vector(5 downto 0);
		--control bits from branch/jump Path
		countUpdate              : IN  std_logic;

		------------------------DATA PATH-------------------------
		ALUResult                : IN  std_logic_vector(31 downto 0);
		RData2                   : IN  std_logic_vector(4 downto 0);
		RegisterWriteAddress     : IN  std_logic_vector(4 downto 0);
		NewPC                    : IN  std_logic_vector(31 downto 0);

		-----------------------OUTPUT SIGNALS----------------------
		OUT_MemRead              : OUT std_logic;
		OUT_MemtoReg             : OUT std_logic;
		OUT_ALUOp                : OUT std_logic_vector(4 downto 0);
		OUT_MemWrite             : OUT std_logic;
		OUT_RegWrite             : OUT std_logic;
		OUT_Branch               : OUT std_logic;
		OUT_Jump                 : OUT std_logic;
		OUT_ShiftContr           : OUT std_logic;
		OUT_wdataContr           : OUT std_logic_vector(1 downto 0);
		OUT_JRControl            : OUT std_logic;
		OUT_ALUFunc              : OUT std_logic_vector(5 downto 0);
		OUT_countUpdate          : OUT std_logic;

		OUT_ALUResult            : OUT std_logic_vector(31 downto 0);
		OUT_RData2               : OUT std_logic_vector(4 downto 0);
		OUT_RegisterWriteAddress : OUT std_logic_vector(4 downto 0);
		OUT_NewPC                : OUT std_logic_vector(31 downto 0)
	);
end entity;

architecture behavior of ExecutionRegister is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			OUT_MemRead     <= MemRead;
			OUT_MemtoReg    <= MemtoReg;
			OUT_ALUOp       <= ALUOp;
			OUT_MemWrite    <= MemWrite;
			OUT_RegWrite    <= RegWrite;
			OUT_Branch      <= Branch;
			OUT_Jump        <= Jump;
			OUT_ShiftContr  <= ShiftContr;
			OUT_wdataContr  <= wdataContr;
			OUT_JRControl   <= JRControl;
			OUT_ALUFunc     <= ALUFunc;
			OUT_countUpdate <= countUpdate;

			OUT_ALUResult            <= ALUResult;
			OUT_RData2               <= RData2;
			OUT_RegisterWriteAddress <= RegisterWriteAddress;
			OUT_NewPC                <= NewPc;
		end if;
	end process;
end architecture;


