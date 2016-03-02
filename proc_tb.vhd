LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY proc_tb IS 
END ENTITY;


ARCHITECTURE behavior of proc_tb IS
	COMPONENT Processor IS
		PORT(
			ref_clk		: IN std_logic;
			reset		: IN std_logic
		);
	END COMPONENT;
signal ref_clk, reset: std_logic;

BEGIN 
	proc: processor PORT MAP(
		ref_clk, 
		reset
	);
process 
	begin
	--wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
        reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';
	wait for 10 ns;
	ref_clk<='1'; 
	reset<='0';
	wait for 10 ns;
	ref_clk<='0';
	reset<='0';


	end process;
end behavior; 