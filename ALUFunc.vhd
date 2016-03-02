library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--NEED MORE ALUOp's for all the different functions
--Add the shift control bit
--Communicate with Paul -> CWP

entity ALUFunc is
	Port(
		ALUOp		: IN std_logic_vector(4 downto 0);
		FuncField	: IN std_logic_vector(5 downto 0);
		JRControl	: OUT std_logic;
		ShiftContr	: OUT std_logic;
		out_put		: OUT std_logic_vector(5 downto 0)
	);
end ALUFunc;

architecture behavior of ALUFunc is
begin process(ALUOp,FuncField)
begin
	if (ALUOp = "00000" OR ALUOp = "00100") then	  --r type
		out_put <= FuncField;
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "00001" OR ALUOp = "00010") then  --load save
		out_put <= "100000";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "00011") then --addi
		out_put <= "100000";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "00101") then --BEQ
		out_put <= "111100";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "00110") then --BNE
		out_put <= "111101";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "00111") then --BLTZ
		out_put <= "111000";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "01000") then --BGEZ
		out_put <= "111001";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "01001") then --BLEZ
		out_put <= "111110";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "01010") then --BGTZ
		out_put <= "111111";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (AlUOp = "01011") then --Jump
		out_put <= "100000";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "01100") then --JR
		out_put <= "100000";
		JRControl <= '1';
		ShiftContr <= '0';
	elsif (ALUOp = "01101") then --JAL
		out_put <= "100000";
		JRControl <= '0';
		Shiftcontr <= '0';
	elsif (ALUOp = "01110") then --JALR
		out_put <= "100000";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "01111") then --SLL
		out_put <= "000010";
		JRControl <= '0';
		ShiftContr <= '1';
	elsif (ALUOp = "10000") then --SRL
		out_put <= "000000";
		JRControl <= '0';
		ShiftContr <= '1';
	elsif (ALUOp = "10001") then --SRA
		out_put <= "000011";
		JRControl <= '0';
		ShiftContr <= '1';
	elsif (ALUOp = "10010") then --SLLV
		out_put <= "000010";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "10011") then --SRLV
		out_put <= "000000";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "10100") then --SRAV
		out_put <= "000011";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "10101") then --LB
		out_put <= "100000";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "10110") then --LH
		out_put <= "100000";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "10111") then --LBU
		out_put <= "100000";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "11000") then --LHU
		out_put <= "100000";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "11001") then --SB
		out_put <= "100000";
		JRControl <= '0';
		ShiftContr <= '0';
	elsif (ALUOp = "11010") then --SH
		out_put <= "100000";
		JRControl <= '0';
		ShiftContr <= '0';
	else 
		out_put <= "100001";
		JRControl <= '0';
		ShiftContr <= '0';
	end if;	 
end process;
end behavior;
