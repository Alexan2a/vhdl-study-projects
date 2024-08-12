library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity tb is
end entity;
architecture beh of tb is
	component ctr is
		generic(
			K: integer; -- word bits
			W: integer -- address bits
		);
		port(
			clk: in std_logic
		);
	end component;
	signal clk: std_logic := '0';
   constant clk_period : time := 20 ns;
begin
	clk <= not clk after clk_period / 2;
	uut: ctr 
	generic map(
		K => 8, 
		W => 8
	)
	port map(
		clk => clk
	);	
end architecture;