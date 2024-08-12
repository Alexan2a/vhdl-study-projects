entity NOT_gate is
    Port ( X1 : in bit;
           Y  : out bit);
end NOT_gate;

architecture Behavioral of NOT_gate is
begin
    Y <= not X1;
end Behavioral;



entity NOR_3_gate is
generic (delay: time);
    Port ( X1 : in bit;
           X2 : in bit;
           X3 : in bit;
           Y  : out bit);
end NOR_3_gate;

architecture Behavioral of NOR_3_gate is
begin
    Y <= not (X1 or X2 or X3) after delay;
end Behavioral;



entity NAND_gate is
generic (delay: time);
    Port ( X1 : in bit;
           X2 : in bit;
           Y  : out bit);
end NAND_gate;

architecture Behavioral of NAND_gate is
begin
    Y <= not (X1 and X2) after delay;
end Behavioral;



entity F1 is
generic (delay: time:=5ns);
    Port ( a : in bit;
           b : in bit;
           c : in bit;
           o : out bit);
end F1;


architecture Behavioral of F1 is
begin
   o <= not (a or b or c) nand not (not a or not b or c) after delay;
end Behavioral;


architecture Algorithm of F1 is
begin
   process (a,b,c)
   variable V1,V2,V3,V4,V5,V6,V7: bit;
   begin
   V1 := not a;
   V2 := not b;
   V3 := V1 or V2 or c;
   V2 := a or b or c;
   V1 := not V2;
   V2 := not V3;
   V3 := V1 and V2;
   o <= not V3 after delay;
   end process;
end Algorithm;


architecture Dataflow of F1 is
signal C1,C2,C3,C4,C5,C6,C7:bit;
begin
   C1 <= not a;
   C2 <= not b;
   C3 <= C1 or C2 or c;
   C4 <= a or b or c;
   C5 <= not C4;
   C6 <= not C3;
   C7 <= C5 and C6;
   o <= not C7 after delay;
end Dataflow;


architecture Algorithm_2 of F1 is
signal C1,C2,C3,C4,C5,C6,C7: bit;
begin
   process (a,b,c,C1,C2,C3,C4,C5,C6,C7)
   begin
   C1 <= not a;
   C2 <= not b;
   C3 <= C1 or C2 or c;
   C4 <= a or b or c;
   C5 <= not C4;
   C6 <= not C3;
   C7 <= C5 and C6;
   o <= not C7 after delay;
   end process;
end Algorithm_2;


architecture Structure of F1 is
signal C1,C2,C3,C4:bit;
component NOT_gate   port(X1: in bit; 
			Y: out bit); 
end component NOT_gate;
component NOR_3_gate generic (delay:time);
		     port    (X1, X2, X3: in bit;
			      Y: out bit); 
end component NOR_3_gate;
component NAND_gate  generic  (delay:time); 
	             port     (X1, X2: in bit;
		              Y: out bit); 
end component NAND_gate;
begin
   G1:NOT_gate port map (a, C1);
   G2:NOT_gate port map (b, C2);
   G3:NOR_3_gate generic map (0ns) port map (a, b, c, C3);
   G4:NOR_3_gate generic map (0ns) port map (C1, C2, c, C4);
   G5:NAND_gate generic map (5ns) port map (C3, C4, o);
end Structure;


architecture Mixed of F1 is
signal C1,C2,C3,C4:bit;
component NOT_gate   port(X1: in bit; 
			Y: out bit); 
end component NOT_gate;
component NOR_3_gate generic (delay:time);
		     port    (X1, X2, X3: in bit;
			      Y: out bit); 
end component NOR_3_gate;
component NAND_gate  generic  (delay:time); 
	             port     (X1, X2: in bit;
		              Y: out bit); 
end component NAND_gate;
begin
   C1 <= not a;
   C2 <= not b;
   G1:NOR_3_gate generic map (0ns) port map (a, b, c, C3);
   G2:NOR_3_gate generic map (0ns) port map (C1, C2, c, C4);
   G3:NAND_gate generic map (5ns) port map (C3, C4, o);
end Mixed;

