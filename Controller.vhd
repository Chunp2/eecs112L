library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--TODO
--Add all othe rfunctions required (BEQ*,BNE*,BLTZ*,BGEZ*,//BLEZ*,BGTZ*,//JUMP*,JR,JAL,JALR,SLL,SRL,SRA,SLLV,SRLV,SRAV)
--Go into ALU Function Controller to add addition control bits for JR and shit
--Add a shift control bit and assign it to all instructions
--Add write data control bit and assign it to all instructions

entity Controller is
	Port(
		rt			: IN std_logic_vector(4 downto 0);
		opSelect	: IN std_logic_vector(5 downto 0);
		RegDst		: OUT std_logic;					--1 is write using RD 0 is write using RT
		MemRead		: OUT std_logic;					--1 is read from RAM 0 is don't read from RAM
		MemtoReg	: OUT std_logic;					--1 is write using RAM data, 0 is write using ALU output
		ALUOp		: OUT std_logic_vector(4 downto 0); 
		MemWrite	: OUT std_logic;					--1 is write into RAM, 0 is don't write into RAM
		ALUSrc		: OUT std_logic;					--1 is ALU Bin is immediate value, 0 is ALU Bin is Register data
		RegWrite	: OUT std_logic;					--1 is write into Register, 0 is don't write into register
		Branch		: OUT std_logic;					--1 is the cycle is a branch cycle, 0 is not branch cycle
		Jump		: OUT std_logic;					--1 is the cycle is a jump cycle, 0 is not a jump cycle
		ShiftContr	: OUT std_logic;
		wdataContr	: OUT std_logic_vector(1 downto 0) --0 is normal input, 1 is Load Upper Immediate Input, 2-3 is Jump and Link Instruction
	);
end Controller;

architecture Code of Controller is
	begin process(opSelect)
	begin
		if (opSelect="000000") then --rtype
			RegDst <= '1';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '1';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "00000";
			Branch <= '0';
			Jump <= '0';
			ShiftContr<= '0';
			wdataContr <= "00";
		elsif (opSelect="100011") then --load 
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '1';
			RegWrite <= '1';
			MemRead <= '1';
			MemWrite <= '0';
			ALUOp <= "00001";
			Branch <= '0';
			Jump <= '0';
			ShiftContr<= '0';
		elsif (opSelect="101011") then --sw 
			RegDst <= 'X';
			ALUSrc <= '1';
			MemtoReg <= 'X';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '1';
			ALUOp <= "00010";
			Branch <= '0';
			Jump <= '0';
			ShiftContr<= '0';
		elsif (opSelect= "001000")then --addimediate
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '0';
			RegWrite <= '1';
			MemRead <= '1';
			MemWrite <= '0';
			ALUOp <= "00011";
			Branch <= '0';
			Jump <= '0';
			ShiftContr<= '0';
		elsif(opSelect= "101000") then --subtract  
			RegDst <= '1';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '1';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "00100";
			Branch <= '0';
			Jump <= '0';
			ShiftContr<= '0';
		elsif(opSelect="000100") then --beq
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "00101"; --Need more ALUOp's? 
			Branch <= '1';
			Jump <= '0';
			ShiftContr<= '0';
		elsif (opSelect="000101") then --bne
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "01001"; --Need more ALUOp's?
			Branch <= '1';
			Jump <= '0';
			ShiftContr<= '0';
		elsif (opSelect="000001") then --bltz and bgez
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			if (rt = "00000") then
				ALUOp <= "00111";
			else
				ALUOP <= "01000";
			end if;
			Branch <= '1';
			Jump <= '0';
			ShiftContr<= '0';
		elsif (opSelect="001000") then --blez
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "01001"; --Need more ALUOp's? TODO
			Branch <= '1';
			Jump <= '0';
			ShiftContr<= '0';
		elsif (opSelect="001001") then --bgtz
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "01010"; --Need more ALUOp's? TODO
			Branch <= '1';
			Jump <= '0';
			ShiftContr<= '0';
		elsif (opSelect="000010") then --jump
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "01011"; --Need more ALUOp's? TODO
			Branch <= '0';
			Jump <= '1';
			ShiftContr<= '0';
			wdataContr <= "00";
------------------------------------------------------------------------------------
-- Below is NOT finished yet. They are just outlined. The bits for each need to be verified.
-- ALUOp and opSelect are correct, and are arbirtarily chosen. SEE OPCODEZ excel sheet for full list.
-- Last revised by Jon 2/12/16--
------------------------------------------------------------------------------------------------------

			elsif (opSelect="000111") then -- JR,
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "01100"; --Need more ALUOp's? TODO
			Branch <= '0';
			Jump <= '1';
			ShiftContr<= '0';
		elsif (opSelect="001011") then -- JAL,
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "01101"; --Need more ALUOp's? TODO
			Branch <= '0';
			Jump <= '1';
		elsif (opSelect="011011") then -- JALR,
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "01110"; --Need more ALUOp's? TODO
			Branch <= '0';
			Jump <= '1';
		elsif (opSelect="111000") then -- SLL,
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "01100"; --Need more ALUOp's? TODO
			Branch <= '0';
			Jump <= '0';
			ShiftContr<= '1';
		elsif (opSelect="010101") then -- SRL,
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "01111"; --Need more ALUOp's? TODO
			Branch <= '0';
			Jump <= '0';
			ShiftContr<= '1';
		elsif (opSelect="101010") then -- SRA,
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "10001"; --Need more ALUOp's? TODO
			Branch <= '0';
			Jump <= '0';
		elsif (opSelect="011010") then -- SLLV,
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "01100"; --Need more ALUOp's? TODO
			Branch <= '0';
			Jump <= '1';
		elsif (opSelect="010111") then -- SRLV,
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "10011"; --Need more ALUOp's? TODO
			Branch <= '0';
			Jump <= '1';
		elsif (opSelect="010001") then -- SRAV
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			ALUOp <= "10100"; --Need more ALUOp's? TODO
			Branch <= '0';
			Jump <= '1';
		

		elsif (opSelect="100000") then --load byte ----Ivan added this 
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '1';
			RegWrite <= '1';
			MemRead <= '1';
			MemWrite <= '0';
			ALUOp <= "10101";
			Branch <= '0';
			Jump <= '0';
		elsif (opSelect="100001") then --load halfword ----Ivan added this 
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '1';
			RegWrite <= '1';
			MemRead <= '1';
			MemWrite <= '0';
			ALUOp <= "10110";
			Branch <= '0';
			Jump <= '0';
		elsif (opSelect="100100") then --load upper byte ----Ivan added this 
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '1';
			RegWrite <= '1';
			MemRead <= '1';
			MemWrite <= '0';
			ALUOp <= "10111";
			Branch <= '0';
			Jump <= '0';
		elsif (opSelect="100101") then --load upper halfword ----Ivan added this 
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '1';
			RegWrite <= '1';
			MemRead <= '1';
			MemWrite <= '0';
			ALUOp <= "11000";
			Branch <= '0';
			Jump <= '0';
		elsif (opSelect="101001") then --SB 
			RegDst <= 'X';
			ALUSrc <= '1';
			MemtoReg <= 'X';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '1';
			ALUOp <= "11001";
			Branch <= '0';
			Jump <= '0';
		elsif (opSelect="101010") then --SH 
			RegDst <= 'X';
			ALUSrc <= '1';
			MemtoReg <= 'X';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '1';
			ALUOp <= "11010";
			Branch <= '0';
			Jump <= '0';
			
		else
			RegDst <= 'Z';
			ALUSrc <= 'Z';
			MemtoReg <= 'Z';
			RegWrite <= 'Z';
			MemRead <= 'Z';
			MemWrite <= 'Z';
			ALUOp <= "ZZZZZ";
		end if;
	end process;
end Code;
