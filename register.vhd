--Register File
--Made by Jonathan Loui
--EECS 112L Winter 2016
--University of California Irvine

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY regfile IS
	GENERIC (
				NBIT: INTEGER := 32;
				NSEL : INTEGER := 5 );
	PORT(
			clk		: IN 	std_logic;
			rst_s	: IN 	std_logic;
			we		: IN 	std_logic;
			raddr_1	: IN 	std_logic_vector(4  DOWNTO 0);
			raddr_2	: IN 	std_logic_vector(4 DOWNTO 0);
			waddr	: IN 	std_logic_vector(4  DOWNTO 0);
			rdata_1	: OUT 	std_logic_vector(31 DOWNTO 0);
			rdata_2	: OUT 	std_logic_vector(31 DOWNTO 0);
			wdata	: IN 	std_logic_vector(31 DOWNTO 0)
		
	);
END regfile;

ARCHITECTURE behavioral OF regfile IS
	
		TYPE registerArray IS ARRAY(0 to 31) OF std_logic_vector (31 downto 0);
		SIGNAL Registers : registerArray;
BEGIN
	Registers(0)<=std_logic_vector(to_unsigned(0,32));
	rdata_1 <= Registers(to_integer(unsigned(raddr_1)));
	rdata_2 <= Registers(to_integer(unsigned(raddr_2)));
	
	regWrite : PROCESS (clk, rst_s)
	
	BEGIN
		if rst_s = '1' then
			Registers <= (OTHERS => x"00000000");
		elsif rising_edge(clk) then
		
			if (we = '1') then
			Registers(to_integer(unsigned(waddr))) <= wdata;
			
		end if;
	end if;

END PROCESS regWrite;

END behavioral;
