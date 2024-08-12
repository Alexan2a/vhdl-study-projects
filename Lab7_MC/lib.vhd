library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

package cmdlib is
	constant ADD_A_Ri: std_logic_vector (4 downto 0) := "00101"; -- Add A, Ri
	constant CJNE_A_dir_addr: std_logic_vector (7 downto 0) := "10110101"; -- CJNE A, dir, addr
	constant MOV_Rn_dir: std_logic_vector (4 downto 0) := "10101"; -- MOV Rn, #data
end package cmdlib;

