library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--This device will store decoder values that will be passed onto
--the next pipeline stage
entity FetchRegister is
	Port(
		clk           : IN  std_logic;
		enable        : IN  std_logic;

		--From decoder into register
		opSelect      : IN  std_logic_vector(5 downto 0);
		regSource     : IN  std_logic_vector(4 downto 0);
		regTarget     : IN  std_logic_vector(4 downto 0);
		regDest       : IN  std_logic_vector(4 downto 0);
		func          : IN  std_logic_vector(5 downto 0);
		immValue      : IN  std_logic_vector(15 downto 0);
		PCPlus4       : IN  std_logic_vector(31 downto 0);

		--Output signals
		OUT_opSelect  : OUT std_logic_vector(5 downto 0);
		OUT_regSource : OUT std_logic_vector(4 downto 0);
		OUT_regTarget : OUT std_logic_vector(4 downto 0);
		OUT_regDest   : OUT std_logic_vector(4 downto 0);
		OUT_func      : OUT std_logic_vector(5 downto 0);
		OUT_immValue  : OUT std_logic_vector(15 downto 0);
		OUT_PCPlus4   : OUT std_logic_vector(31 downto 0)
	);
end FetchRegister;

architecture behavior of FetchRegister is
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if enable=1 then
				OUT_opSelect  <= opSelect;
				OUT_regSource <= regSource;
				OUT_regTarget <= regTarget;
				OUT_regDest   <= regDest;
				OUT_func      <= func;
				OUT_immValue  <= immValue;
				OUT_PCPlus4   <= PCPlus4;
			end if;
		end if;
	end process;
end behavior;