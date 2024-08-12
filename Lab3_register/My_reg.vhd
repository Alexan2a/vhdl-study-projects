entity My_reg is
	port (C,R,E: in bit; Qreg: inout bit_vector(0 to 7));
end entity;

architecture reg_behavioral of My_reg is
signal Q: bit_vector(0 to 8);
begin
Q(0) <= C;
	reg: for i in 0 to 7 generate
		G1: entity work.T_FF(Behavioral_1) port map (Q(i),R,E,Q(i+1));
	end generate;
Qreg <= Q(1 to 8);
end architecture;

