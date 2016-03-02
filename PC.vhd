library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC is
	Port(
		clk		: IN std_logic;
		countUpdate: IN std_logic;
		countIn : IN std_logic_vector(31 downto 0);
		counter : OUT std_logic_vector(31 downto 0)
	);
end entity;

architecture behavior of PC is
begin
	process(clk)
	variable innerCount : Integer := 0;
	begin
		if (rising_edge(clk)) then 
			if (countUpdate='1') then
				innerCount := to_integer(unsigned(countIn));
			end if;
			counter <= std_logic_vector(to_unsigned(innerCount,32));
			innerCount := innerCount + 1; 
		end if;	
	end process;
end architecture;