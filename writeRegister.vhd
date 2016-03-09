library IEEE;
use IEEE.std_logic_1164.all;

entity writeRegister is
	port(
		clk                 : in  STD_LOGIC;
		--CONTROL--
		regWrite            : in  STD_LOGIC;
		memtoRegW           : in  STD_LOGIC;
		PCUpdateControl     : in  std_logic;
		--DATA--
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
		out_newPC           : out std_logic_vector(31 downto 0)
	);
end writeRegister;

architecture behavior of writeRegister is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			out_regWrite        <= regWrite;
			out_memtoRegW       <= memtoRegW;
			out_PCUpdateControl <= PCUpdateControl;
			out_ALUoutW         <= ALUoutW;
			out_writeReg        <= writeReg;
			out_ReadDataW       <= ReadDataW;
			out_newPC           <= newPC;
		end if;
	end process;
end behavior;


