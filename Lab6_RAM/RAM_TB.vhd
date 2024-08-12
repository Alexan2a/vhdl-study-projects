library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use STD.textio.all;
use work.ram_td.all;

entity RAM_TB is
end entity;

architecture tester of RAM_TB is
	constant K: integer := 8;
	constant W: integer := 8;
	signal clk_tb, rd_tb, wr_tb: std_logic := '0';
	signal e_tb: std_logic := '1';
	signal tb_signals: ram_signals(
		A_Write(W-1 downto 0), 
		A_Read(W-1 downto 0),
		D_in(K-1 downto 0), 
		D_out(K-1 downto 0)
	);
	begin
		G1: entity work.RAM(RAMBEHAVIOR) generic map(K, W) port map (tb_signals);
		clk_tb <= not clk_tb after 10 ns;
		rd_tb <= not rd_tb after 110 ns;
		wr_tb <= not wr_tb after 220 ns;
		e_tb <= not e_tb after 440 ns;
		tb_signals.clk <= clk_tb after 3ns;
		tb_signals.RD <= rd_tb;
		tb_signals.WR <= wr_tb;
		tb_signals.Enable <= e_tb;
		tb_signals.A_Write <= "00000000", "00001000" after 100ns,
			"00000010" after 195ns, "00000101" after 240ns, 
			"00001100" after 295ns, "00000100" after 365ns,
			"00000101" after 440ns, "00000001" after 540ns,
			"00000010" after 620ns, "00000011" after 700ns, 
			"00000100" after 780ns, "00000101" after 880ns;
		tb_signals.A_Read <= "00000000", "00000001" after 100ns,
			"00000010" after 180ns, "00000011" after 260ns, 
			"00000100" after 340ns, "00000101" after 440ns,
 			"00001000" after 540ns, "00000010" after 635ns, 
			"00000101" after 680ns, "00001100" after 735ns, 
			"00000100" after 805ns, "00000101" after 880ns;
		tb_signals.D_in <= (others => '0'), "01010101" after 10 ns, 
			"10101010" after 50 ns, "00001111" after 130 ns, "11110000" after 220 ns;
end architecture;
