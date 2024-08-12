library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;


entity My_reg is
	port (a,b: in std_logic_vector(9 downto 0); 
	      clk, set: in std_logic;
	      mode: in std_logic_vector(2 downto 0);
	      q: out std_logic_vector(9 downto 0));
end entity;

architecture reg_when of My_reg is
signal reg, gl, sh, mult, r2, a1: std_logic_vector(9 downto 0);
begin 

    process (reg)
    variable t1: std_logic_vector(9 downto 0);
    begin
        reverse_1 : for k in 0 to reg'length-1 loop
              t1(reg'length-1-k) := reg(k);
        end loop reverse_1;
	mult <= shl(t1,"11");
    end process;
    a1 <= reg + b;
    process (a, b)
    variable t2: std_logic_vector(9 downto 0);
    begin
        reverse_2 : for k in 0 to reg'length-1 loop
              t2(reg'length-1-k) := a(k) or b(k);
        end loop reverse_2;
	r2 <= t2;
    end process;

    sh(9 downto 6) <= reg (3 downto 0);
    sh(5 downto 0) <= reg (9 downto 4);

    gl(9 downto 5) <= a(5 downto 1);
    gl(4 downto 1) <= b(9 downto 6);
    gl(0) <= a(1);

    reg <= "0011100000"  when (set = '1') else
           "0000000000"  when (clk='1' and clk'EVENT and mode="000") else
           b             when (clk='1' and clk'EVENT and mode="001") else 
           std_logic_vector(unsigned(a)/unsigned(reg + b)) 
                         when (clk='1' and clk'EVENT and mode="010") else
           mult          when (clk='1' and clk'EVENT and mode="011") else
           sh            when (clk='1' and clk'EVENT and mode="100") else
           r2            when (clk='1' and clk'EVENT and mode="101") else
           gl            when (clk='1' and clk'EVENT and mode="110");

    q <= "ZZZZZZZZZZ" when (mode="111") else
         reg;

    process(reg, b)
    begin
        if (reg + b = "0000000000") then
            report "Division by zero. Gives zero result." severity WARNING;
        end if;
    end process;
end architecture;


architecture reg_proc of My_reg is
begin

    Process(clk)
    variable reg, gl, sh, r1, r2: std_logic_vector(9 downto 0);
    begin 

        if (set = '1') then
        reg := "0011100000";
        else
            if (clk = '1' and clk'event) then
                case mode is
                    when "000" =>
                        reg := "0000000000"; 
                    when "001" =>
                        reg := b;
                    when "010" =>
                        reg := std_logic_vector(unsigned(a)/unsigned(reg + b));
                    when "011" =>
			reverse_1: for k in 0 to reg'length-1 loop
                            r1(reg'length-1-k) := reg(k);
                        end loop reverse_1;
	                reg := shl(r1,"11");
                    when "100" =>
			sh(9 downto 6) := reg (3 downto 0);
        		sh(5 downto 0) := reg (9 downto 4);
                        reg := sh;
                    when "101" =>
			reverse_2: for k in 0 to reg'length-1 loop
            		    r2(reg'length-1-k) := a(k) or b(k);
       			end loop reverse_2;
                        reg := r2; 
                    when "110" =>
			gl(9 downto 5) := a(5 downto 1);
        		gl(4 downto 1) := b(9 downto 6);
        		gl(0) := a(1);
                        reg := gl;
	            when others =>
	    	    reg := reg; 
                end case;
            end if;
        end if;

        if (mode = "111") then
            q <= "ZZZZZZZZZZ";
        else
            q <= reg;
        end if;
    end process;
end architecture;

