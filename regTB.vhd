library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;

entity regTB is
end entity;

architecture behavior of regTB is
	component regfile is
		Port(
			clk		: IN 	std_logic;
			rst_s	: IN 	std_logic;
			we		: IN 	std_logic;
			raddr_1	: IN 	std_logic_vector(4 DOWNTO 0);
			raddr_2	: IN 	std_logic_vector(4 DOWNTO 0);
			waddr	: IN 	std_logic_vector(4 DOWNTO 0);
			rdata_1	: OUT 	std_logic_vector(31 DOWNTO 0);
			rdata_2	: OUT 	std_logic_vector(31 DOWNTO 0);
			wdata	: IN 	std_logic_vector(31 DOWNTO 0)
		);
	end component;
	signal rdat1,rdat2,wdat	: std_logic_vector(31 downto 0);
	signal radd1,radd2,wadd	:std_logic_vector(4 downto 0);	
	signal clk,rst,we	: std_logic;
begin
	tb: regfile Port map(clk,rst,we,radd1,radd2,wadd,rdat1,rdat2,wdat);
	clock:process
	begin
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
	end process;
	
	process
	begin
		--write into the regfile
		wait for 10 ns;
		radd1<=conv_std_logic_vector(1,5);
		radd2<=conv_std_logic_vector(0,5); -- register[0] and register[1] should be unintialized
		we<='0';
		rst<='0';
		wait for 20 ns;
		we<='1';
		wadd<=conv_std_logic_vector(1,5);
		wdat<=conv_std_logic_vector(5,32); -- makes register[1]=5
		wait for 20 ns;
		wadd<=conv_std_logic_vector(0,5);
		wdat<=conv_std_logic_vector(7,32); -- makes register[0]=7 (can't happen, r[0] always 0)
		wait for 20 ns;
		we<='0';
		wadd<=conv_std_logic_vector(1,5);
		wdat<=conv_std_logic_vector(420,32); -- check if register[1]=7 still or is now 420
		wait for 20 ns;
		rst<='1';
		wait for 20 ns; -- check if register[1] and register[0] are now 0
	end process;
end behavior;