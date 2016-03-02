library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ORgate is
	Port (
		Ain	: IN std_logic;
		Bin : IN std_logic;
		Cout: OUT std_logic
	);
end ORgate;

architecture behavior of ORgate is
begin
	Cout <= Ain OR Bin;
end behavior;