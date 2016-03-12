library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity HazardUnit is
	Port(
		--logic control inputs--
		WriteRegM   : IN  std_logic;
		RegWriteM   : IN  std_logic;
		RegWriteW   : IN  std_logic;
		MemRead     : IN  std_logic;
		Branch		: IN  std_logic;

		RegSourceD  : IN  std_logic_vector(5 downto 0);
		RegTargetD  : IN  std_logic_vector(5 downto 0);
		RegSourceF  : IN  std_logic_vector(5 downto 0);
		RegTargetF  : IN  std_logic_vector(5 downto 0);

		RegDestW    : IN  std_logic_vector(5 downto 0);
		RegDestM    : IN  std_logic_vector(5 downto 0);

		--logic control outputs--
		ForwardBE   : OUT std_logic_vector(1 downto 0) := "00";
		ForwardAE   : OUT std_logic_vector(1 downto 0) := "00";
		DecodeFlush : OUT std_logic                    := 0;
		FetchStall  : OUT std_logic                    := 0;
		PCStall     : OUT std_logic                    := 0;
	);
end HazardUnit;

architecture behavior of HazardUnit is
begin
	process
	begin
		--EX Hazard
		if (RegWriteM = 1) then
			if (NOT (RegDestM = "00000") AND (RegDestM = RegSourceD)) then
				ForwardAE <= "10";
			elsif (NOT (RegDestM = "00000") AND (RegDestM = RegTargetD)) then
				ForwardBE <= "10";
			end if;
		--MEM Hazard
		elsif (RegWriteW = 1) then
			if (NOT (RegDestW = "00000") AND (RegDestW = RegSourceD)) then
				ForwardAE <= "01";
			elsif (NOT (RegDestW = "0000") AND (RegDestW = RegTargetD)) then
				ForwardBE <= "01";
			end if;
		--Stall hazard for lw
		elsif (MemRead = 1) then
			if (RegTargetD = RegSourceF) OR (RegTargetD = RegTargetF) then
				DecodeFlush <= 1;
				FetchStall  <= 1;
				PCStall     <= 1;
			end if;
		--stall for branches
		elsif (Branch = 1) then
			
		--No hazard, reset all control bits	
		else
			ForwardAE   <= "00";
			ForwardBE   <= "00";
			DecodeFlush <= 0;
			FetchStall  <= 0;
			PCStall     <= 0;
		end if;
	end process;
end behavior;