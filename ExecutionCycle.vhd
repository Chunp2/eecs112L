library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ExecutionCycle is
	Port(
		--============INPUTS============--
		------------control bits--------------
		ForwardAE     : IN std_logic_vector(1 downto 0); --controls the hazard mux for ALU Ain
		ForwardBE     : IN std_logic_vector(1 downto 0); --controls the hazard mux for ALU Bin
		------------data path-----------------
		ForwardedALUM : IN std_logic_vector(31 downto 0); --ALUOutput from one cycle ahead
		ForwardedALUW : IN std_logic_vector(31 downto 0); --ALUOutput from two cycles ahead
		RData1        : IN std_logic_vector(31 downto 0);
		RData2        : IN std_logic_vector(31 downto 0);

	);
end entity;

architecture behavior of ExecutionCycle is
	--the names are weird because I never thought I would use this component for another purpose
	component MUX3to1
		port(NormalInput : IN  std_logic_vector(31 downto 0);
			 JUIInput    : IN  std_logic_vector(31 downto 0);
			 JALInput    : IN  std_logic_vector(31 downto 0);
			 selector    : IN  std_logic_vector(1 downto 0);
			 wdata       : OUT std_logic_vector(31 downto 0));
	end component MUX3to1;

	--signal out of ForwardA--
	signal ForwardAOut : std_logic_vector(31 downto 0);
	--signal out of ForwardB--
	signal ForwardBOut : std_logic_vector(31 downto 0);
begin
	ForwardA : component MUX3to1
		port map(
			NormalInput => RData1,
			JUIInput    => ForwardedALUM,
			JALInput    => ForwardedALUW,
			selector    => ForwardAE,
			wdata       => ForwardAOut
		);
	ForwardB : component MUX3to1
		port map(
			NormalInput => RData2,
			JUIInput    => ForwardedALUM,
			JALInput    => ForwardedALUW,
			selector    => ForwardBE,
			wdata       => ForwardBOut
		);
end architecture;