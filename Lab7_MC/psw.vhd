library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity PSW is
	generic(
		K: integer -- width
	);
port(
	clk:       in  std_logic;
	CY:        in  std_logic;
	AC:        in  std_logic;
	F0:        in  std_logic;
	RS1:       in  std_logic;
	RS0:       in  std_logic;
	OV:        in  std_logic;
	UDB:       in  std_logic;
	P:         out std_logic;
	A:         in  std_logic_vector(K-1 downto 0); 
	A_ALU:     in  std_logic_vector(K-1 downto 0);
	new_A:     in  std_logic;
	new_A_ALU: in  std_logic
);
end entity;

architecture beh of PSW is
begin
	Process(clk) is
	variable tmp: std_logic := '0';
	variable ACC: std_logic_vector(K-1 downto 0);
	begin
		if (clk'EVENT and clk = '1') then
			if (new_A = '1') then
				ACC := A;
			elsif (new_A_ALU = '1') then
				ACC := A_ALU;
			end if;
			if ((new_A or new_A_ALU) = '1') then
				tmp := '0';
				for i in 0 to (ACC'LENGTH - 1) loop
					if (ACC(i) = '1') then
						tmp := not tmp;
					end if;
				end loop;
			end if;
		end if;
		P <= tmp;
	end process;
end;
