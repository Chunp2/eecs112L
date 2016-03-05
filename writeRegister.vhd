library IEEE; 
use IEEE.std_logic_1164.all;



entity writeRegister is 
	 port(
		clk		: in STD_LOGIC;
		regWrite	: in STD_LOGIC;
		memtoRegW	: in STD_LOGIC;
		RData2		: in STD_LOGIC_VECTOR(31 DOWNTO 0); 
		ALUoutW		: in std_logic_vector(31 downto 0);
		writeReg	: in STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		out_regWrite	: out std_logic; 
		out_memtoRegW	: out std_logic;
		out_ALUoutW	: out std_logic_vector(31 downto 0);
		out_RData2	: out STD_LOGIC_VECTOR(31 DOWNTO 0);
		out_writeReg	: out STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
end writeRegister;

architecture behavior of writeRegister is
	
begin
	process(clk) begin
		if rising_edge(clk) then
		out_regWrite<=regWrite;
		out_memtoRegW <= memtoRegW;	
		out_ALUoutW <= ALUoutW; 	
		out_RData2<= RData2;	
		out_writeReg<=writeReg;	
		end if;
	end process;
end behavior;


