library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

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
	signal mem: registerArray;
begin

	process(clk) begin
		if rising_edge(clk) then
			if we = '1' then 
				mem(conv_integer(waddr)) <= wdata;
			end if;
		end if;
	end process;
	
	process(clk,we,raddr_1,raddr_2,waddr,wdata) begin
		if rst_s = '1' then
			mem <= (OTHERS => x"00000000");
		end if;
		if (conv_integer(raddr_1) = 0) then 
			rdata_1 <= X"00000000";
		else 
			rdata_1 <= mem(conv_integer(raddr_1));
		end if;
		if (conv_integer(raddr_2) = 0) then 
			rdata_2 <= X"00000000";
		else 
			rdata_2 <= mem(conv_integer(raddr_2));
		end if;
	end process;
end;



