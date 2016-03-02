library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MUX32bit is
	Port(
		high	: IN std_logic_vector(31 downto 0);
		low		: IN std_logic_vector(31 downto 0);
		selector: IN std_logic;
		out_put	: OUT std_logic_vector(31 downto 0)
	);
end MUX32bit;

architecture behavior of MUX32bit is
begin process(high,low,selector)
begin
	if (selector = '0') then
		out_put <= low;
	else 
		out_put <= high;	
	end if;
end process;	
end behavior;