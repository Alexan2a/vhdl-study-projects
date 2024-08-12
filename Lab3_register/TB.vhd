library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;
 

entity T_FF_TB is

end T_FF_TB;

architecture test of T_FF_TB is
signal C_TB, R_TB, E_TB, Q_TB1, QBAR_TB1, Q_TB2, QBAR_TB2, Q_TB3, QBAR_TB3, Q_TB4, QBAR_TB4, Q_TB5, QBAR_TB5: bit;
signal Qreg_TB:bit_vector(0 to 7);
begin
    R_TB <= not R_TB after 161 ns;
    E_TB <= not E_TB after 70 ns;
--    R_TB <= '0'; --for reg
--    E_TB <= '1'; --for reg
    C_TB <= '1' after 2 ns, '0' after 19 ns, '1' after 45 ns, '0' after 70 ns, '1' after 81 ns, '0' after 110 ns, '1' after 120 ns;
G1: entity work.t_ff(Behavioral_1) 
    port map (C_TB, R_TB, E_TB, Q_TB1, QBAR_TB1);
G2: entity work.t_ff(Behavioral_2)
    port map (C_TB, R_TB, E_TB, Q_TB2, QBAR_TB2);
G3: entity work.t_ff(Behavioral_3)
    port map (C_TB, R_TB, E_TB, Q_TB3, QBAR_TB3);
G4: entity work.t_ff(Behavioral_4)
    port map (C_TB, R_TB, E_TB, Q_TB4, QBAR_TB4);
G5: entity work.t_ff(Behavioral_5)
    port map (C_TB, R_TB, E_TB, Q_TB5, QBAR_TB5);
G6: entity work.my_reg(reg_behavioral) 
    port map (C_TB, R_TB, E_TB, Qreg_TB);

end architecture test;
