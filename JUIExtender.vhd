library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity JUIExtender is
	Port(
		Instr16down		: IN std_logic_vector(15 downto 0);
		UpperImm		: OUT std_logic_vector(31 downto 0)
	);
end JUIExtender;

architecture behavior of JUIExtender is
begin
	UpperImm(31 downto 16) <= Instr16down;
	UpperImm(15 downto 0) <= std_logic_vector(to_unsigned(0,16));
end behavior;