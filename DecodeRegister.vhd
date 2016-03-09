library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity DecodeRegister is
	Port(
		clk                     : IN  std_logic;
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
		--data entry from PCPlus4
		PCPlus4                 : IN  std_logic_vector(31 downto 0);

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
		OUT_PCPlus4             : OUT std_logic_vector(31 downto 0)
	);
end DecodeRegister;

architecture behavior of DecodeRegister is
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			--control bits out
			OUT_RegDst              <= RegDst;
			OUT_MemRead             <= MemRead;
			OUT_MemtoReg            <= MemToReg;
			OUT_ALUOp               <= ALUOp;
			OUT_MemWrite            <= MemWrite;
			OUT_ALUSrc              <= ALUSrc;
			OUT_RegWrite            <= RegWrite;
			OUT_Branch              <= Branch;
			OUT_Jump                <= Jump;
			OUT_ShiftContr          <= ShiftContr;
			OUT_wdataContr          <= wdataContr;
			OUT_JRControl           <= JRControl;
			OUT_ALUFunc             <= ALUFunc;
			OUT_opSelect            <= opSelect;
			--data entries out
			OUT_RData1              <= RData1;
			OUT_RData2              <= RData2;
			OUT_RegDestination      <= Regdestination;
			OUT_RegTarget           <= RegTarget;
			OUT_ExtendedImmValue    <= ExtendedImmValue;
			OUT_ExtendedShiftAmount <= ExtendedShiftAmount;
			OUT_PCPlus4             <= PCPlus4;
		end if;
	end process;
end architecture;