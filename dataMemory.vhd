
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY dataMemory IS 
PORT(
	clk : IN STD_LOGIC;
	we : IN STD_LOGIC;
	--dsize: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	addr : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	dataI : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	dataO : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
-- Data memory is 512 by 32 bit array(word adressable)


END ENTITY dataMemory;
ARCHITECTURE behavior OF dataMemory IS
	
	TYPE ramType IS ARRAY(0 to (2**9)) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ram: ramType :=(others => std_logic_vector(to_unsigned(0,32)));
	SIGNAL readAddr: STD_LOGIC_VECTOR(31 DOWNTO 0);
	

BEGIN
	RamProc: PROCESS(clk) IS 
	variable LB,LH,SB, SH, LBU, LHU : std_logic_vector(31 DOWNTO 0);
	
	BEGIN
	IF (rising_edge(clk)) THEN 
		IF (we= '1') THEN
			ram(to_integer(unsigned(addr))) <= dataI;
		END IF; 
		readAddr <= addr ; 
	end if;
		


end process RamProc; 
	dataO <= ram(to_integer(unsigned(readAddr)));
END behavior; 

