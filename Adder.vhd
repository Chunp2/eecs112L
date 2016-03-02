library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Adder is
	Port(
		A_in	: IN std_logic_vector(31 downto 0);
		B_in	: IN std_logic_vector(31 downto 0);
		O_out	: OUT std_logic_vector(31 downto 0)
	);
end entity;

architecture increment of Adder is
begin
	process(A_in,B_in)
	begin
		O_out <= A_in + B_in;
	end process;
end architecture;