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
		MemWrite                 : IN  std_logic;
		RegWrite                 : IN  std_logic;
		Branch                   : IN  std_logic;
		Jump                     : IN  std_logic;
		opSelect				 : IN  std_logic_vector(5 downto 0);
		wdataContr               : IN  std_logic_vector(1 downto 0);

		------------------------DATA PATH-------------------------
		ALUResult                : IN  std_logic_vector(31 downto 0);
		RData2                   : IN  std_logic_vector(31 downto 0);
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
		OUT_opSelect			 : OUT std_logic_vector(5 downto 0);
		OUT_wdataContr           : OUT std_logic_vector(1 downto 0);
		
		OUT_ALUResult            : OUT std_logic_vector(31 downto 0);
		OUT_RData2               : OUT std_logic_vector(31 downto 0);
		OUT_RegisterWriteAddress : OUT std_logic_vector(4 downto 0);
		OUT_newPC				 : OUT std_logic_vector(31 downto 0);
		OUT_JumpAddress          : OUT std_logic_vector(31 downto 0);
		OUT_BranchAdress         : OUT std_logic_vector(31 downto 0);
		OUT_ExtendedJUI          : OUT std_logic_vector(31 downto 0);
		OUT_PC                   : OUT std_logic_vector(31 downto 0)
	);
end entity;

architecture behavior of ExecutionRegister is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			OUT_MemRead     <= MemRead;
			OUT_MemtoReg    <= MemtoReg;
			OUT_MemWrite    <= MemWrite;
			OUT_RegWrite    <= RegWrite;
			OUT_Branch      <= Branch;
			OUT_Jump        <= Jump;
			OUT_opSelect	<= opSelect;
			OUT_wdataContr  <= wdataContr;

			OUT_ALUResult            <= ALUResult;
			OUT_RData2               <= RData2;
			OUT_RegisterWriteAddress <= RegisterWriteAddress;
			OUT_newPC				 <= newPC;
			OUT_JumpAddress          <= JumpAddress;
			OUT_BranchAdress         <= BranchAddress;
			OUT_ExtendedJUI          <= ExtendedJUI;
			OUT_PC                   <= PC;
		end if;
	end process;
end architecture;


