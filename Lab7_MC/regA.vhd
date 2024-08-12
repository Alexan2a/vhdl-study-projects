library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

ENTITY reg_A IS
generic(
	K: integer:=8
);
port (
	clk:       in  std_logic;
	WR:        in  std_logic;
	RD:        in  std_logic;
	RD_ALU:    in  std_logic;
	WR_ALU:    in  std_logic;
	RD_Acc:    in  std_logic;
	WR_Acc:    in  std_logic;
	D_in:      in  std_logic_vector(K-1 downto 0);
	D_in_ALU:  in  std_logic_vector(K-1 downto 0);
	D_in_Acc:  in  std_logic_vector(K-1 downto 0);	
	D_out:     out std_logic_vector(K-1 downto 0) := (others => '0');
	D_out_ALU: out std_logic_vector(K-1 downto 0) := (others => '0');
	D_out_Acc: out std_logic_vector(K-1 downto 0) := (others => '0')
);
end entity;

architecture beh of reg_A is
signal rA: std_logic_vector (K-1 downto 0) := (others => '0');
begin
	Process(clk) is
	begin
		if (clk'event and clk = '1') then
			if (RD = '1' and WR = '0') then
				D_out <= rA;
			elsif (RD = '0' and WR = '1') then
				rA <= D_in;
			end if;
			if (RD_ALU = '1' and WR_ALU = '0') then
				D_out_ALU <= rA;
			elsif (RD_ALU = '0' and WR_ALU = '1') then
				rA <= D_in_ALU;
			end if;
			if (RD_Acc = '1' and WR_Acc = '0') then
				D_out_Acc <= rA;
			elsif (RD_Acc = '0' and WR_Acc = '1') then
				rA <= D_in_Acc;
			end if;
		end if;
	end process;
end architecture;