library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity InstructionMemory is
	Port(
		addr	: IN std_logic_vector(31 downto 0);
		dataIO	: INOUT std_logic_vector(31 downto 0)
	);
end InstructionMemory;

architecture Behavioral of InstructionMemory is
	type ROM is array(1024 downto 0) of std_logic_vector(31 downto 0);
	begin process(addr)
	variable pointer : ROM;
begin
		-----------  "aaaaabaaaabaaaabaaaaaaaaaaaaaaab"	
			   --"aaaaalssssslttttldddddl000000000" 
		
		pointer(0) := "10001100000000100000000001010000"; --lw instruction
		--pointer(0) := "00100000001000100000000000000111";--addi t, s, imm: t= s+imm    
		pointer(1) := "00100000000000100000000000000100";--addi t, s, imm: t= s+imm	  
		pointer(2) := "00000000001000100001100000100000";--addr d, s, t :  d= s + t   
		pointer(3) := "00011100000000100000000000000101";--jr s
		pointer(4) := "00011100000000110000000000001100";--jr s 
		pointer(5) := "00011100011001111111111111110111";--jr s
		pointer(6) := "00100000001000100000000000000111";--addi t, s, imm: t= s+imm
		pointer(7) := "11100000111000100010000000100101";--sll d, t, h : d= t<<h
		pointer(8) := "11100000011001000010100000100100";--sll d, t, h : d= t<<h
		pointer(9) := "11100000101001000010100000100000";--sll d, t, h : d= t<<h
		pointer(10) := "01101000101001110000000000001010";--sllv d, t, s : d= t<<s
		pointer(11) := "11100000011001000010000000101010";--sll d, t, h : d= t<<h
		pointer(12) := "01101000100000000000000000000001";--sllv d, t, s : d= t<<s
		pointer(13) := "00011100000001010000000000000000";--jr s
		pointer(14) := "11100000111000100010000000101010";--sll d, t, h : d= t<<h
		pointer(15) := "11100000100001010011100000100000";--sll d, t, h : d= t<<h
		pointer(16) := "11100000111000100011100000100010";--sll d, t, h : d= t<<h
		pointer(17) := "10101100011001110000000001000100";--sw t, offset(s)
		pointer(18) := "10001100000000100000000001010000"; --lw t, offset(s)
		pointer(19) := "01010100000000000000000000010001";--srl d, t, h : d= t >>h
		pointer(20) := "00011100000000100000000000000001";--jr s
		pointer(21) := "00100000001000100000000000000101";--addi t, s, imm: t= s+imm 
	 	pointer(22) := "10101100000000100000000001010100";--sw t, offset(s)
		


		dataIO <= pointer(to_integer(unsigned(addr)));
	end process;
end Behavioral;

