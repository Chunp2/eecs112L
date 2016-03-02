--Author: Jonathan Loui

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Concatinator is	
	port(
		PC_in : in std_logic_vector(31 downto 0);
		InstructionMem : in std_logic_vector(31 downto 0);
		concatOut : out std_logic_vector (31 downto 0)
	);
	
end Concatinator;

architecture behavioral of Concatinator is
begin
	--concatOut[31 downto 27) <= PC_in;
	concatOut <= PC_in(31 downto 26) & InstructionMem(25 downto 0);
end behavioral;