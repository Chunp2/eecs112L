library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY alu_tb IS
END alu_tb;


ARCHITECTURE behavior OF alu_tb IS
COMPONENT alu IS
	PORT(
		Func_in		: IN	std_logic_vector(5 DOWNTO 0);
		A_in		: IN	std_logic_vector(31 DOWNTO 0);
		B_in		: IN	std_logic_vector(31 DOWNTO 0);
		O_out		: OUT 	std_logic_vector(31 DOWNTO 0);
		Branch_out	: OUT	std_logic
	);
END COMPONENT;
	
	SIGNAL Func_in		: std_logic_vector(5 DOWNTO 0);
	SIGNAL A_in		: std_logic_vector(31 DOWNTO 0);
	SIGNAL B_in		: std_logic_vector(31 DOWNTO 0);
	SIGNAL O_out		: std_logic_vector(31 DOWNTO 0);
	SIGNAL Branch_out	: std_logic;
	
BEGIN
	uut : alu PORT MAP( Func_in => Func_in,
				A_in => A_in,
				B_in => B_in,
				O_out => O_out,
				Branch_out => Branch_out
				
				);

	PROCESS
	BEGIN
		--ADD
		Func_in <= "100000";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--ADDI
		Func_in <= "100001";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--SUB
		Func_in <= "100010";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--SUBI
		Func_in <= "100011";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--AND
		Func_in <= "100100";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--OR
		Func_in <= "100101";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--XOR
		Func_in <= "100110";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--NOR
		Func_in <= "100111";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--SLTS
		Func_in <= "101000";
		A_in <= "10000000000100000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--SLTU
		Func_in <= "101001";
		A_in <= "10000000000100000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--BLTZ
		Func_in <= "111000";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--BGTEZ
		Func_in <= "111001";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--BE
		Func_in <= "111100";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--BNE
		Func_in <= "111101";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--BLTEZ
		Func_in <= "111110";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--BGTZ
		Func_in <= "111111";
		A_in <= "00000000000000000000000000000001";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--srl
		Func_in <= "000X00";
		A_in <= "00000000000000000000000000000011";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;
		--sll
		Func_in <= "000X10";
		A_in <= "00000000000000000000000000000011";
		B_in <= "00000000000000000000000000000001";
		wait for 10 ns;		
		--sra
		Func_in <= "000X11";
		A_in <= "00000000000000000000000000000011";
		B_in <= "10000000000000000000000000000001";
		wait for 10 ns;
		
	END PROCESS;
END behavior;