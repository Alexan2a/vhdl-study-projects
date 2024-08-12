library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity PC is
	generic(
		K: integer:=8
	);
	port(
		clk:    in  std_logic;
		jmp_to: in  std_logic_vector(K-1 downto 0);
		jmp:    in  std_logic;
		enbl:   in  std_logic;
		count:  out std_logic_vector(K-1 downto 0) := (others => '0')
	);
end entity PC;
architecture beh of PC is
begin
	Process (clk) is
		variable i: std_logic_vector(K-1 downto 0) := (others => '0');
	begin
		if (clk'event and clk = '1') then
			if (jmp = '1') then
				i := std_logic_vector(signed(i) + signed(jmp_to));
			elsif (enbl = '1') then
				i := i + 1;
			end if;
		count <= i;
		end if;
	end process;
end architecture;