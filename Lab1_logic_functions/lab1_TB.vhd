entity lab1_TB is

end lab1_TB;

architecture test of lab1_TB is
    signal i: bit_vector(3 downto 0);
    signal o: bit_vector(1 downto 0);
    
begin
    i(0) <= not i(0) after 200ns;
    i(1) <= not i(1) after 100ns;
    i(2) <= not i(2) after 50ns;
    i(3) <= not i(3) after 25ns;
U1: entity work.lab1(Behavioral)
    port map (i(3 downto 0),o(1 downto 0));
    
end test;

