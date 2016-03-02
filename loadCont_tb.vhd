LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;


ENTITY loadCont_tb IS 
END ENTITY;

ARCHITECTURE behavior OF loadCont_tb IS
	COMPONENT loadControl IS
		PORT(
		loadOP: IN std_logic_vector(5 DOWNTO 0);
		dataIn: IN std_logic_vector(31 DOWNTO 0);
		dataOut: OUT std_logic_vector(31 DOWNTO 0)
	);
	END COMPONENT;
SIGNAL loadOp: std_logic_vector(5 DOWNTO 0);
SIGNAL dataIn, dataOut: std_logic_vector(31 DOWNTO 0);

BEGIN 

	LCONTR_TB: loadControl PORT MAP(
		loadOP, dataIn, dataOut 
		);
	process 
	begin 

	loadOp<="100000"; --byte 
	dataIn<= "01011110110011100111111110000110";
	wait for 10 ns;

	loadOp<="100001"; --hw 
	dataIn<= "01011110110011100111111110000000";
	wait for 10 ns;

	loadOp<="100100"; --upper byte
	dataIn<= "01011110110011100111111110000000";
	wait for 10 ns;

	loadOp<="100101"; --upper hw
	dataIn<= "01011110110011100111111110000000";
	wait for 10 ns;
	loadOp<="111111";  --lw 
	dataIn<= "01011110110011100111111110000000";
	wait for 10 ns;
	
	end process;
end behavior;