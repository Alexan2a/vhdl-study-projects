library ieee;
use ieee. std_logic_1164.all;
--use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;
 

entity reg_TB is

end reg_TB;

architecture test of reg_TB is
signal a,b:  std_logic_vector(9 downto 0); 
signal clk, set: std_logic := '0';
signal mode: std_logic_vector(2 downto 0):="000"; 
signal q1, q2: std_logic_vector(9 downto 0);
begin
    a <= "0101110111", "1101010101" after 55ns,"0000101111" after 250ns, "1101110101" after 500ns;
    b <= "1111101010", "0000000000" after 150ns, "0001011101" after 270ns, "0000001100"after 435ns;
    clk <= not clk after 25 ns;
    mode <= mode + 1 after 50 ns;


G1: entity work.My_reg(reg_when) 
    port map (a,b, std_logic(clk), set, std_logic_vector(mode), q1);
G2: entity work.My_reg(reg_proc)
    port map (a,b, std_logic(clk), set, std_logic_vector(mode), q2);


end architecture test;
