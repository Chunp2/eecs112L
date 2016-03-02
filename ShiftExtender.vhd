library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ShiftExtender is
	Port(
		Instr16down		: IN std_logic_vector(15 downto 0);
		ExtendedShamt	: OUT std_logic_vector(31 downto 0)
	);
end ShiftExtender;

architecture behavior of ShiftExtender is
begin
ExtendedShamt(31 downto 5) <= std_logic_vector(to_unsigned(0,27));
ExtendedShamt(4 downto 0) <= Instr16down(10 downto 6);
end behavior;