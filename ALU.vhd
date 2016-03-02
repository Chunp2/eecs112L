library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
---use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--hi

ENTITY alu IS
	PORT(
		Func_in		: IN	std_logic_vector(5 DOWNTO 0);
		A_in		: IN	std_logic_vector(31 DOWNTO 0);
		B_in		: IN	std_logic_vector(31 DOWNTO 0);
		O_out		: OUT 	std_logic_vector(31 DOWNTO 0);
		Branch_out	: OUT	std_logic
	);

END alu;

ARCHITECTURE behv OF alu IS


begin
	process(Func_in, A_in, B_in)
	begin
		
		case Func_in IS
			when "000X00" =>
				O_out <= std_logic_vector(unsigned(B_in) srl to_integer(unsigned(A_in))) ;
				Branch_out <= '0';
				
			
			when "000X10" =>
				O_out <= std_logic_vector(unsigned(B_in) sll to_integer(unsigned(A_in))) ;
				Branch_out <= '0';
				
			
			when "000X11" =>
				O_out <= to_stdlogicvector(to_bitvector(B_in) sra to_integer(unsigned(A_in))) ;
				Branch_out <= '0';
				
			
			when "100000" =>
				O_out <= std_logic_vector(unsigned(A_in) + unsigned(B_in));
				Branch_out <= '0';
				
			when "100001" =>
				O_out <= std_logic_vector(unsigned(A_in) + unsigned(B_in));
				Branch_out <= '0';
				
			when "100010" =>
				O_out <= std_logic_vector(unsigned(A_in) - unsigned(B_in));
				Branch_out <= '0';
				
			when "100011" =>
				O_out <= std_logic_vector(unsigned(A_in) - unsigned(B_in));
				Branch_out <= '0';
				
			when "100100" =>
				O_out <= A_in AND B_in;
				Branch_out <= '0';
				
			when "100101" =>
				O_out <= A_in OR B_in;
				Branch_out <= '0';
				
			when "100110" =>
				O_out <= A_in XOR B_in;
				Branch_out <= '0';
				
			when "100111" =>
				O_out <= A_in NOR B_in;
				Branch_out <= '0';
				
			when "101000" =>
				IF signed(A_in) < signed(B_in) THEN
				O_out <= "00000000000000000000000000000001"; 
				ELSE O_out <= "00000000000000000000000000000000";  
				END IF;		
				Branch_out <= '0';
				
			when "101001" =>
				IF A_in < B_in THEN
				O_out <= "00000000000000000000000000000001";
				ELSE O_out <= "00000000000000000000000000000000";
				END IF;

				Branch_out <= '0';
				
			when "111000" =>
				O_out <= A_in;
				IF A_in < "00000000000000000000000000000000" THEN
				Branch_out <= '1';
				ELSE Branch_out <= '0';
				END IF;
				
			when "111001" =>
				O_out <= A_in;
				
				IF A_in >= "00000000000000000000000000000000" THEN
				Branch_out <= '1';
				ELSE Branch_out <= '0';
				END IF;

				

			when "111100" =>
				O_out <= A_in;
				IF A_in = B_in THEN
				Branch_out <= '1';
				ELSE Branch_out <= '0';
				END IF;
				
			when "111101" =>
				O_out <= A_in;
				IF A_in /= B_in THEN
				Branch_out <= '1';
				ELSE Branch_out <= '0';
				END IF;
				
			when "111110" =>
				O_out <= A_in;
				IF A_in <= "00000000000000000000000000000000" THEN
				Branch_out <= '1';
				ELSE Branch_out <= '0';
				END IF;
				
			when "111111" =>
				O_out <= A_in;
				IF A_in > "00000000000000000000000000000000" THEN
				Branch_out <= '1';
				ELSE Branch_out <= '0';
				END IF;
				
			when others => O_out <= A_in;
		end case;
	end process;
end behv;
