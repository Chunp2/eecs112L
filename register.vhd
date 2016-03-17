library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity regfile is 
	 port(
		clk		: in STD_LOGIC;
		rst_s		: in STD_LOGIC;
	 	we		: in STD_LOGIC;
	 	raddr_1		: in STD_LOGIC_VECTOR(4 downto 0);
		raddr_2		: in STD_LOGIC_VECTOR(4 downto 0);
	 	waddr		: in STD_LOGIC_VECTOR(4 downto 0);
	 	wdata		: in STD_LOGIC_VECTOR(31 downto 0);
	 	rdata_1		: out STD_LOGIC_VECTOR(31 downto 0);
		rdata_2		: out STD_LOGIC_VECTOR(31 downto 0)
	);
end;

architecture behavior of regfile is
	type registerArray is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0); 
	signal mem: registerArray :=(others => std_logic_vector(to_unsigned(0,32)));
	signal testSig	: std_logic_vector(31 downto 0);
begin
	rdata_1 <= mem(to_integer(unsigned(raddr_1)));
	rdata_2 <= mem(to_integer(unsigned(raddr_2)));
	process(clk,raddr_1,raddr_2,waddr,wdata,rst_s,we) begin
		if rising_edge(clk) then
			if we = '1' then 
				mem(conv_integer(waddr)) <= wdata;
			end if;
			if rst_s = '1' then
				mem <= (OTHERS => x"00000000");
			end if;
			
		end if;
	end process;
	
end architecture;



