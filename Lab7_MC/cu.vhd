library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use work.cmdlib.all;

entity CU is
generic(
	K: integer; -- word bits
	W: integer -- address bits
);
port(
	clk:       in  std_logic;
	cmd:       in  std_logic_vector(K-1 downto 0);
	ALU_cmd:   out std_logic_vector(3 downto 0);
	RAM_RD:    out std_logic;
	RAM_WR:    out std_logic;
	RAM_Addr:  out std_logic_vector(W-1 downto 0);
	ROM_rd:    out std_logic;
	A_RD:      out std_logic;
	A_RD_ALU:  out std_logic;
	A_RD_Acc:  out std_logic;
	A_WR:      out std_logic;
	A_WR_ALU:  out std_logic;
	A_WR_Acc:  out std_logic;
	Acc_RD:    out std_logic;
	Acc_WR:    out std_logic;
	RTS_RD:    out std_logic;
	RTS_WR:    out std_logic;
	RS0:       inout std_logic;
	RS1:       inout std_logic;
	PC_jmp_to: out std_logic_vector(K-1 downto 0);
	PC_jmp:    out std_logic;
	PC_rdy:    out std_logic;
	DataRAM:   in  std_logic_vector(K-1 downto 0);
	DataA:     in  std_logic_vector(K-1 downto 0);
	DataOUT:   out std_logic_vector(K-1 downto 0) := (others => '0')
);
end entity CU;

architecture beh of CU is
type state is (next_cmd_1, next_cmd_2, read_cmd, decode, add_1, add_2, add_3, add_4, add_5, add_6, add_7, cjne_1, cjne_2, cjne_3, cjne_4, cjne_5, cjne_6, cjne_7, cjne_8, cjne_9, cjne_10, mov_7, mov_1, mov_2, mov_3, mov_4, mov_5, mov_6);
signal current_state, next_state: state;
signal reg_num: std_logic_vector(2 downto 0) := (others => '0');
signal temp1, temp2: std_logic_vector(K-1 downto 0) := (others => '0');
begin

	Process (clk) is
	begin
		if (clk'event and clk = '1') then
			current_state <= next_state;
		end if;
	end process;

	Process (current_state) is
	variable tmp1: std_logic_vector(K-1 downto 0) := (others => '0');
	begin
		RAM_RD <= '0';
		RAM_WR <= '0';
		ROM_rd <= '0';
		A_RD <= '0';
		A_WR <= '0';
		A_RD_ALU <= '0';
		A_WR_ALU <= '0';
		A_RD_Acc <= '0';
		A_WR_Acc <= '0';
		Acc_RD <= '0';
		Acc_WR <= '0';
		RTS_RD <= '0';
		RTS_WR <= '0';
		PC_jmp <= '0';
		RS0 <= '0';
		RS1 <= '0';
		ALU_cmd <= (others => '0');
		PC_jmp_to <= (others => '0');
		RAM_Addr <= (others => '0');
		case (current_state) is
			when next_cmd_1 =>
				pc_rdy <= '0';
				rom_rd <= '1';
				next_state <= next_cmd_2;
			when next_cmd_2 =>
				pc_rdy <= '1';
				rom_rd <= '0';
				next_state <= decode;
			when decode =>
				pc_rdy <= '0';
				if (cmd(7 downto 3) = ADD_A_Ri) then
					reg_num <= cmd(2 DOWNTO 0);
					next_state <= add_1;
				elsif (cmd = CJNE_A_dir_addr) then
					rom_rd <= '1';
					next_state <= cjne_1;
				elsif (cmd(7 downto 3) = MOV_Rn_dir) then
					reg_num <= cmd(2 downto 0);
					rom_rd <= '1';
					next_state <= mov_1;
				else
					next_state <= next_cmd_1;
				end if;
			when add_1 =>
				RAM_Addr <= "00000" & reg_num;
				RAM_RD <= '1';
				Acc_RD <= '1';
				next_state <= add_2;
			when add_2 =>
				A_WR_Acc <= '1';
				RTS_WR <= '1';
				next_state <= add_3;
			when add_3 => 
				RTS_RD <= '1';
				A_RD_ALU <= '1';
				next_state <= add_4;
			when add_4 =>
				ALU_cmd <= "0001";
				next_state <= add_5;
			when add_5 => 
				A_WR_ALU <= '1';
				next_state <= add_6;
			when add_6 =>
				A_RD_Acc <= '1';
				next_state <= add_7;
			when add_7 => 
				Acc_WR <= '1';
				next_state <= next_cmd_1;
			when cjne_1 => 
				temp1 <= cmd; 
				pc_rdy <= '1';
				Acc_RD <= '1';
				next_state <= cjne_2;
			when cjne_2 =>
				ROM_RD <= '1';
				A_WR_Acc <= '1';
				next_state <= cjne_3;
			when cjne_3 =>
				temp2 <= cmd;
				ROM_RD <= '0';
				PC_rdy <= '0';
				next_state <= cjne_4;				
			when cjne_4 =>
				RAM_Addr <= temp1;
				RAM_RD <= '1';
				next_state <= cjne_5;
			when cjne_5 => 
				RTS_WR <= '1';
				next_state <= cjne_6;
			when cjne_6 =>
				RTS_RD <= '1';
				A_RD_ALU <= '1';
				next_state <= cjne_7;
			when cjne_7 =>
				ALU_cmd <= "1000";
				next_state <= cjne_8;
			when cjne_8 => 
				A_WR_ALU <= '1';
				next_state <= cjne_9;
			when cjne_9 => 
				A_RD <= '1';
				next_state <= cjne_10;
			when cjne_10 =>
				if (DataA = "00000000") then
					PC_jmp <= '1';
					PC_jmp_to <= temp2;
				end if;
				next_state <= next_cmd_1;
			when mov_1 =>
				temp1 <= cmd;
				ROM_RD <= '0';
				PC_rdy <= '1';
				next_state <= mov_2;
			when mov_2 =>
				temp1 <= cmd;
				PC_rdy <= '0';
				next_state <= mov_3;
			when mov_3 =>
				RAM_Addr <= temp1;
				RAM_RD <= '1';
				next_state <= mov_4;
			when mov_4 =>
				A_WR <= '1';
				next_state <= mov_5;
			when mov_5 => 
				A_RD <= '1';
				next_state <= mov_6;
			when mov_6 => 
				tmp1 := "00000" & reg_num;
				RAM_Addr <= tmp1;
				DataOut <= DataA;
				RAM_WR <= '1';
				next_state <= next_cmd_1;
			when others =>
				next_state <= next_cmd_1;
		end case;
	end process;
end architecture;
