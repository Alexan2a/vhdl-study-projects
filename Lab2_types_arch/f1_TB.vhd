entity f1_TB is

end f1_TB;

architecture test of f1_TB is
signal x1, x2, x3, f_Beh, f_Alg, f_DF, 
       f_Alg2, f_Struct, f_Mix:bit;

begin
    x1 <= not x1 after 200 ns;
    x2 <= not x2 after 100 ns;
    x3 <= not x3 after 50 ns;

G1: entity work.f1(Behavioral) 
    port map (x1, x2, x3, f_Beh);
G2: entity work.f1(Algorithm)
    port map (x1, x2, x3, f_Alg);
G3: entity work.f1(Dataflow) 
    port map (x1, x2, x3, f_DF);
G4: entity work.f1(Algorithm_2) 
    port map (x1, x2, x3, f_Alg2);
G5: entity work.f1(Structure) 
    port map (x1, x2, x3, f_Struct);
G6: entity work.f1(Mixed) 
    port map (x1, x2, x3, f_Mix);



end architecture test;
