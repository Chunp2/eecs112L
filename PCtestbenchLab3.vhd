library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PCtestbenchLab3 is
end entity;

architecture behavior of PCtestbenchLab3 is
	component PC is 
		Port(
			clk		: IN std_logic;
			countUpdate: IN std_logic;
			countIn : IN std_logic_vector(31 downto 0);
			counter : OUT std_logic_vector(31 downto 0)
		);
	end component;
	
	component Adder is
		Port(
			A_in	: IN std_logic_vector(31 downto 0);
			B_in	: IN std_logic_vector(31 downto 0);
			O_out	: OUT std_logic_vector(31 downto 0)
		);
	end component;
	Signal clk, countUpdate	: std_logic := '0';
	Signal countIn, counter, PCPlus1 : std_logic_vector(31 downto 0);
begin
	PCer: PC Port map(
		clk => clk,
		countUpdate => countUpdate,
		countIn => countIn,
		counter => counter
	);
	
	Adderer: Adder Port map(
		A_in => counter,
		B_in => std_logic_vector(to_unsigned(1,32)),
		O_out => PCPlus1
	);
	tb: process
	begin
		--tb goals: we will be observing the counter signal
		--first we increment the clk 3 times to get it to increment normally, but then, we'll 
		--turn the countUpdate control on and force the PC to change to countIn
		wait for 10 ns; -- turn clk on off 3 times to increment counter 3 times
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		
		wait for 10 ns; -- force Counter to change to a new number
		countUpdate <= '1';
		countIn <= std_logic_vector(to_unsigned(15,32));
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		countUpdate <= '0';
		wait for 10 ns; -- try to increment with the new value
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		
		
	end process;
end architecture;