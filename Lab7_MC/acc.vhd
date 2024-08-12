library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

ENTITY Acc IS
generic(
	K: integer:=8
);
port (
	clk:   in  std_logic;
	WR:    in  std_logic;
	RD:    in  std_logic;
	D_in:  in  std_logic_vector(K-1 downto 0);
	D_out: out std_logic_vector(K-1 downto 0)
);
end entity;

architecture beh of Acc is
signal A: std_logic_vector (K-1 downto 0) := (others => '0');
begin
	Process(clk) is
	begin
		if (clk'event and clk = '1') then
			if (RD = '1' and WR = '0') then
				D_out <= A;
			elsif (RD = '0' and WR = '1') then
				A <= D_in;
			end if;
		end if;
	end process;
end architecture;
