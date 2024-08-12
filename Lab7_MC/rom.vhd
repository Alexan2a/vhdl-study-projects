library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ROM is
generic(
	K: integer:=8;
	W: integer:=8
);
port (
	clk:   in  std_logic;
	RD:    in  std_logic;
	Addr:  in  std_logic_vector(W-1 downto 0);
	D_out: out std_logic_vector(K-1 downto 0) := (others => '0')
);
end entity ROM;

architecture beh of ROM is
subtype WORD is std_logic_vector (K-1 downto 0);
type MEMORY is array (0 to 256) of WORD;
constant ROM: MEMORY := (
	"00101010", 		            -- ADD A, R2
	"10101010", "00001010",             -- MOV R2, 0x0Ah
	"10110101", "00001010", "11111010", -- CJNE A, 0AH, start
	others => "00000000"
);
begin

	Process (clk) is
	variable ROM_ADDR_IN: integer range 0 to 2**W-1;
	begin
		if (clk'event and clk = '1') then
			if (RD = '1') then
				ROM_ADDR_IN := conv_integer(Addr);
				D_out <= ROM(ROM_ADDR_IN);
			end if;
		end if;
	end process;
end architecture;