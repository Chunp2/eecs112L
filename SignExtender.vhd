library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SignExtender is
	Port(
		in_put	: IN std_logic_vector(15 downto 0);
		out_put	: OUT std_logic_vector(31 downto 0) 
	);
end SignExtender;

architecture behavior of SignExtender is
begin process(in_put)
begin
	out_put(31 downto 16) <= (others=>in_put(15));
	out_put(15 downto 0)	 <= in_put;
end process;
end behavior;