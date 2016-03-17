LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY proc_tb IS 
END ENTITY;


ARCHITECTURE behavior of proc_tb IS
	COMPONENT proc IS
		PORT(
			ref_clk		: IN std_logic;
			reset		: IN std_logic;
			enable		: IN std_logic;
			finalOutput	: OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
signal ref_clk, reset, enable: std_logic;
signal finalOutput: std_logic_vector(31 downto 0);

BEGIN 
	processor: proc PORT MAP(
		ref_clk, 
		reset,
		enable,
		finalOutput
	);
process 
	begin
	--wait for 10 ns;
	ref_clk<='0';
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
        enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	enable<= '1';
	reset<='0';
	wait for 10 ns;

	end process;
end behavior; 