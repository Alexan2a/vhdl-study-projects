library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.ram_td.all;

entity RAM is
generic (
	K: integer:=8;
	W: integer:=8
);
port (
	signals: inout ram_signals(
		A_Write(W-1 downto 0), 
		A_Read(W-1 downto 0),
		D_in(K-1 downto 0), 
		D_out(K-1 downto 0)
	)
);
end entity RAM;

architecture RAMBEHAVIOR of RAM is
subtype WORD is std_logic_vector (K-1 downto 0);
type MEMORY is array (0 to 2**W-1) of WORD;
signal RAM256: MEMORY;
begin
	process (signals.clk)
	variable RAM_ADDR_IN1: integer range 0 to 2**W-1;
	variable RAM_ADDR_IN2: integer range 0 to 2**W-1;
	variable STARTUP: boolean :=true;
	begin
		if (STARTUP = true) then
			RAM256 <= (0 => "00000101",
			   	   1 => "00110100",
			   	   2 => "00000110",
			   	   3 => "00011000",
			   	   4 => "00000011",
			   	   others => "00000000");
			signals.D_out <= "XXXXXXXX";
			STARTUP :=false;
		else
			if (signals.Enable = '1' and signals.clk'event and signals.clk = '1') then
				RAM_ADDR_IN1 := conv_integer (signals.A_Write);
				RAM_ADDR_IN2 := conv_integer (signals.A_Read);
				if (signals.WR='1') then 
					RAM256 (RAM_ADDR_IN1) <= signals.D_in ;
				end if;
				if (signals.RD = '1') then 
					signals.D_out <= RAM256 (RAM_ADDR_IN2) ;
				else
					signals.D_out <= "00000000";
				end if;
			elsif (signals.Enable = '0') then
				signals.D_out <= "00000000";
			end if; 
		end if;
	end process;
end architecture RAMBEHAVIOR;
