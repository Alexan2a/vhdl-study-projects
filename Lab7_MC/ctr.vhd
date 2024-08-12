library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctr is
generic(
	K: integer;
	W: integer
);
port(
	clk: std_logic
);
end entity;

architecture beh of ctr is

component cu is
generic(
	K: integer;
	W: integer
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
	DataOUT:   out std_logic_vector(K-1 downto 0)
		);
end component;
component PC is
generic(
	K: integer -- word bits
);
port(
	clk:    in std_logic;
	jmp_to: in std_logic_vector(K-1 downto 0);
	jmp:    in std_logic;
	enbl:   in std_logic;
	count:  out std_logic_vector(K-1 downto 0)
		);
end component;
component PSW is
generic(
	K: integer
);
port(
	clk:       in  std_logic;
	CY:        in  std_logic;
	AC:        in  std_logic;
	F0:        in  std_logic;
	RS1:       in  std_logic;
	RS0:       in  std_logic;
	OV:        in  std_logic;
	UDB:       in  std_logic;
	P:         out std_logic;
	A:         in  std_logic_vector(K-1 downto 0); 
	A_ALU:     in  std_logic_vector(K-1 downto 0);
	new_A:     in  std_logic;
	new_A_ALU: in  std_logic
);
end component;
component RAM is
generic(
	K: integer;
	W: integer 
);
port (
	clk:     in  std_logic;
      	RD:      in  std_logic;
      	WR:      in  std_logic;
      	Addr:    in  std_logic_vector (W-1 downto 0);
      	D_in:    in  std_logic_vector (K-1 downto 0);
      	D_out:   out std_logic_vector (K-1 downto 0)

);
end component;
component ROM is
generic(
	K: integer;
	W: integer
);
port (
	clk:   in  std_logic;
	RD:    in  std_logic;
	Addr:  in  std_logic_vector(W-1 downto 0);
	D_out: out std_logic_vector(K-1 downto 0)
);
end component;
component RTS is
generic(
	K: integer
);	
port(
	clk:   in  std_logic;
	WR:    in  std_logic;
	RD:    in  std_logic;
	D_in:  in  std_logic_vector(K-1 downto 0);
	D_out: out std_logic_vector(K-1 downto 0)
);
end component;
component reg_A is
generic(
	K: integer 
);
port (
	clk:       in  std_logic;
	WR:        in  std_logic;
	RD:        in  std_logic;
	RD_ALU:    in  std_logic;
	WR_ALU:    in  std_logic;
	RD_Acc:    in  std_logic;
	WR_Acc:    in  std_logic;
	D_in:      in  std_logic_vector(K-1 downto 0);
	D_in_ALU:  in  std_logic_vector(K-1 downto 0);
	D_in_Acc:  in  std_logic_vector(K-1 downto 0);	
	D_out:     out std_logic_vector(K-1 downto 0);
	D_out_ALU: out std_logic_vector(K-1 downto 0);
	D_out_Acc: out std_logic_vector(K-1 downto 0)
);
end component;
component Acc is
generic(
	K: integer
);
port (
	clk:   in  std_logic;
	WR:    in  std_logic;
	RD:    in  std_logic;
	D_in:  in  std_logic_vector(K-1 downto 0);
	D_out: out std_logic_vector(K-1 downto 0)
);
end component;
component ALU is
generic(
	K: integer -- width
);
port(
	--clk:    in    std_logic;
	A:      in    std_logic_vector(K-1 downto 0);
	PBX:    in    std_logic_vector(K-1 downto 0);
	CY:     out   std_logic := '0';
	AC:     out   std_logic := '0';
	OV:     out   std_logic := '0';
	opcode: in    std_logic_vector(3 downto 0);
	res:    out   std_logic_vector(K-1 downto 0)
	);
end component;
signal ram_RD, ram_WR, rom_rd, A_RD, A_RD_ALU, A_WR_ALU, A_WR, A_RD_Acc, A_WR_Acc, RTS_RD, RTS_WR, Acc_RD, Acc_WR, pc_jmp, pc_rdy, psw_CY, RS0, RS1, psw_P, psw_AC, psw_OV: std_logic := '0';
signal ALU_cmd: std_logic_vector(3 downto 0) := (others => '0');
signal RAM_Addr, ROM_Addr: std_logic_vector(W-1 downto 0) := (others => '0');
signal cmd, pc_jmp_to, DataA, Data_A, Data_Acc, DataRAM, DataOUT, PBX, Data1_ALU, Data2_ALU: std_logic_vector(K-1 downto 0) := (others => '0');
begin
	u1: cu 
	generic map(
		K => K,
		W => W
	)
	port map(
		clk => clk,
		cmd => cmd,
		ALU_cmd => ALU_cmd,
		RAM_RD => RAM_RD,
		RAM_WR => RAM_WR,
		RAM_Addr => RAM_Addr,
		ROM_rd => rom_rd,
		A_RD => A_RD,
		A_RD_ALU => A_RD_ALU,
		A_RD_Acc => A_RD_Acc,
		A_WR => A_WR,
		A_WR_ALU => A_WR_ALU,
		A_WR_Acc => A_WR_Acc,
		Acc_RD => Acc_RD,
		Acc_WR => Acc_WR,
		RTS_RD => RTS_RD,
		RTS_WR => RTS_WR,
		RS0 => RS0,
		RS1 => RS1,
		pc_jmp_to => pc_jmp_to,
		pc_jmp => pc_jmp,
		pc_rdy => pc_rdy,
		DataRAM => DataRAM,
		DataA => DataA,
		DataOUT => DataOUT
	);
	u2: PC
	generic map(
		K => K
	)
	port map(
		clk => clk,
		jmp_to => pc_jmp_to,
		jmp => pc_jmp,
		enbl => pc_rdy,
		count => rom_Addr
	);
	u3: PSW
	generic map(
		K => K
	)
	port map(
		clk => clk,
		CY => psw_CY,
		AC => psw_AC,
		F0 => '0',
		RS1 => RS1,
		RS0 => RS0,
		OV => psw_OV,
		UDB => '0',
		P => psw_P,
		A => DataA,
		A_ALU => Data2_ALU,
		new_A => A_WR,
		new_A_ALU => A_WR_ALU
	);
	u4: RAM
	generic map(
		K => K,
		W => W
	)
	port map(
		clk => clk,
		WR => ram_WR,
		RD => ram_RD,
		Addr => ram_Addr,
		D_in => DataOUT,
		D_out => DataRAM
	);
	u5: ROM
	generic map(
		K => K,
		W => W
	)
	port map(
		clk => clk,
		RD => rom_rd,
		Addr => rom_Addr,
		D_out => cmd
	);
	u6: RTS
	generic map(
		K => K
	)
	port map(
		clk => clk,
		WR => RTS_WR,
		RD => RTS_RD,
		D_in => DataRAM,
		D_out => PBX
	);
	u7: Acc
	generic map(
		K => K
	)
	port map(
		clk => clk,
		WR => Acc_WR,
		RD => Acc_RD,
		D_in => Data_A,
		D_out => Data_Acc
	);
	u8: reg_A
	generic map(
		K => K
	)
	port map(
		clk => clk,
		WR => A_WR,
		WR_ALU => A_WR_ALU,
		RD => A_RD,
		RD_ALU => A_RD_ALU,
		RD_Acc => A_RD_Acc,
		WR_Acc => A_WR_Acc,
		D_in => DataRAM,
		D_in_ALU => Data2_ALU,
		D_in_Acc => Data_Acc,
		D_out => DataA,
		D_out_ALU => Data1_ALU,
		D_out_Acc => Data_A
	);
	u9: ALU
	generic map(
		K => K
	)
	port map(
	--	clk => clk,
		A => Data1_ALU,
		PBX => PBX,
		CY => psw_CY,
		AC => psw_AC,
		OV => psw_OV,
		opcode => ALU_cmd,
		res => Data2_ALU
	);
end architecture;