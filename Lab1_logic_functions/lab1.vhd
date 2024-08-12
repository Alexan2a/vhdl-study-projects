entity lab1 is
    generic(delay:time:=30ns);
    Port ( X : in bit_vector (3 downto 0);
           Y : out bit_vector (1 downto 0));
end lab1;

architecture Behavioral of lab1 is

begin
    Y(0) <= (X(1) and X(2) and X(3)) or (X(0) and X(1) and X(3)) or (X(0) and not X(1) and X(2)) or (not X(0) and X(1) and not X(2) and not X(3)) after delay;
    Y(1) <= transport (X(1) and X(2) and X(3)) or (X(0) and X(1) and X(3)) or (X(0) and not X(1) and X(2)) or (not X(0) and X(1) and not X(2) and not X(3)) after delay;
 --   Y(2) <= (not X(1) and X(2) and X(3)) or (X(1) and X(2) and not X(3)) or (not X(0) and X(1) and not X(2) and not X(3)) after delay;

end Behavioral;

