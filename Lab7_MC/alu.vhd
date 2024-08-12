library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ALU is
generic(
	K: integer
);
port(
	A:      in    std_logic_vector(K-1 downto 0);
	PBX:    in    std_logic_vector(K-1 downto 0);
	CY:     out std_logic := '0';
	AC:     out   std_logic := '0';
	OV:     out   std_logic := '0';
	opcode: in    std_logic_vector(3 downto 0);
	res:    out   std_logic_vector(K-1 downto 0) := (others => '0')
	);
end entity ALU;
architecture beh of ALU is
begin

	Process (opcode, PBX, A) is
	variable resc: std_logic_vector(K downto 0) := (others => '0');
	variable v1, v2, v: std_logic_vector(8 downto 0);
	begin
		case (opcode) is
			when "0001" => -- ADD
				v1 := "0" & A(7 downto 0);
				v2 := "0" & PBX(7 downto 0);
				v := v1 + v2;
				CY <= v(8);
				res <= v(K-1 downto 0);					
			when "1000" => -- COMPARE
				if (A = PBX) then
						resc := resc + '1';
				elsif (A < PBX) then
						CY <= '1';
				else
						CY <= '0';
				end if;
				res <= resc(K-1 downto 0);
			when others => null;
		end case;
		resc := (others => '0');
	end process;
end architecture;