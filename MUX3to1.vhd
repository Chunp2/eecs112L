library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MUX3to1 is
	Port(
		NormalInput		: IN std_logic_vector(31 downto 0); --operation from ALU
		JUIInput		: IN std_logic_vector(31 downto 0); --shifted immediate value from Instruction Code
		JALInput		: IN std_logic_vector(31 downto 0); --Linked Address, the current PC+4
		selector		: IN std_logic_vector(1 downto 0);
		wdata			: OUT std_logic_vector(31 downto 0)
	);
end MUX3to1;

architecture behavior of MUX3to1 is
begin
	process(selector,NormalInput,JUIInput,JALInput)
	begin
		if (selector="00") then --Normal Input
			wdata <= NormalInput;
		elsif (selector="01") then --LUI input
			wdata <= JUIInput;
		elsif (selector="10") then --JAL input
			wdata <= JALInput;
		end if;
	end process;
end behavior;