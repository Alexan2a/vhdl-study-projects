library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity RAM is
generic (
	K: integer:=8;
	W: integer:=8
);
port (
	clk:     in  std_logic;
      	RD:      in  std_logic;
      	WR:      in  std_logic;
      	Addr:    in  std_logic_vector (W-1 downto 0);
      	D_in:    in  std_logic_vector (K-1 downto 0);
      	D_out:   out std_logic_vector (K-1 downto 0)

);
end entity;

architecture beh of RAM is
subtype WORD is std_logic_vector (K-1 downto 0);
type MEMORY is array (0 to 2**W-1) of WORD;
signal RAM256: MEMORY;
begin

	Process (clk)
	variable RAM_ADDR_IN: integer range 0 to 2**W-1;
	variable STARTUP: boolean :=true;
	begin
		if (STARTUP = true) then
			RAM256 <= ("00010000", -- 00
				   "00100010", -- 01
				   "00000000", -- 02
				   "00010000", -- 03
				   "00000100", -- 04
				   "00100000", -- 05
				   "00000100", -- 06
				   "00000000", -- 07
				   "00000000", -- 08
				   "00000000", -- 09
				   "00001111", -- 0A
			   	   others => "00000000");
			D_out <= "XXXXXXXX";
			STARTUP :=false;
		elsif (clk'event and clk = '1') then
			RAM_ADDR_IN := conv_integer (Addr);
			if (WR='1') then
				RAM256 (RAM_ADDR_IN) <= D_in ;
			end if;
			if (RD = '1') then 
				D_out <= RAM256 (RAM_ADDR_IN) ;
			else
				D_out <= "00000000";
			end if; 
		end if;
	end process;
end architecture;