library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ANDGate is
	Port(
		Ain	: IN std_logic;
		Bin : IN std_logic;
		Cout: OUT std_logic
	);
end ANDGate;

architecture behavior of ANDGate is
begin
	Cout <= Ain AND Bin;
end behavior;