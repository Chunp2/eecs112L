library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Decoder is
	Port(
		instruction : IN std_logic_vector(31 downto 0);
		opSelect 	: OUT std_logic_vector(5 downto 0);
		regSource 	: OUT std_logic_vector(4 downto 0);
		regTarget 	: OUT std_logic_vector(4 downto 0);
		regDest		: OUT std_logic_vector(4 downto 0);
		func		: OUT std_logic_vector(5 downto 0);
		immValue	: OUT std_logic_vector(15 downto 0)
	);
end Decoder;

architecture Code of Decoder is
	begin process(instruction)
	begin
		opSelect <= instruction(31 downto 26);
		regSource <= instruction(25 downto 21);
		regTarget <= instruction(20 downto 16);
		regDest <= instruction(14 downto 10); -- Changed this from 15 to 14 because it was throwing a length error //Jon
		func <= instruction(5 downto 0);
		immValue <= instruction(15 downto 0);
	end process;
end Code;