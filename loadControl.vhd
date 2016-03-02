LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.NUMERIC_STD.SIGNED;

entity loadControl is 
	Port(
		loadOP: IN std_logic_vector(5 DOWNTO 0);
		dataIn: IN std_logic_vector(31 DOWNTO 0);
		dataOut: OUT std_logic_vector(31 DOWNTO 0)
	);
end loadControl;
architecture behavior of loadControl is

	signal byteShift: std_logic_vector(7 downto 0);
	signal mulShift: std_logic_vector(23 downto 0):=(others=>'0'); 
	signal hwShift: std_logic_vector (15 downto 0);
	signal mulhwShift: std_logic_vector(15 downto 0):="1111111111111111";
	signal temp1: std_logic_vector(31 downto 0);
	signal temp2: std_logic_vector(31 downto 0);
begin process(loadOp, dataIn)
	constant extendOne_byte : std_logic_vector(31 downto 0) :="11111111111111111111111100000000";
	constant extendZero_byte: std_logic_vector(31 downto 0) :="00000000000000000000000011111111";
	constant extendOne_hw : std_logic_vector(31 downto 0) :="11111111111111110000000000000000";
	constant extendZero_hw: std_logic_vector(31 downto 0) :="00000000000000001111111111111111";
begin 
------------------ Store ---------------------------------
	if(loadOp ="101001")then --Store Byte 
		if (dataIn(7)='0') then 
			dataOut<= extendZero_byte and dataIn;			
		else
			dataOut<= extendOne_byte or dataIn;
	
		end if; 
		
	elsif (loadOp ="101010") then --Store Halfword
		if(dataIn(15) ='0') then 
			dataOut<= extendZero_hw and dataIn;
		else
			dataOut<= extendOne_hw or dataIn;
		end if;
		
	elsif (loadOp ="101011") then --Store 
		dataOut<= dataIn;
------------------ Load  ---------------------------------
	elsif(loadOp ="100000")then --Load Byte 
		if (dataIn(7)='0') then 
			dataOut<= extendZero_byte and dataIn;			
		else
			dataOut<= extendOne_byte or dataIn;
	
		end if; 
	elsif (loadOp ="100001") then --Load Halfword
		if(dataIn(15) ='0') then 
			dataOut<= extendZero_hw and dataIn;
		else
			dataOut<= extendOne_hw or dataIn;
		end if;
	

	elsif (loadOp ="100100") then --Load Byte Upper 	
		dataOut<= mulShift & dataIn(31 downto 24);
		
	elsif (loadOp ="100101") then --Load Halfowrd upper
		dataOut<=mulhwShift & dataIn(31 downto 16);

	else --load word
		dataOut<= dataIn;
	end if; 
end process; 
end behavior; 