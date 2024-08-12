entity T_FF is
PORT( C,R,E: in bit;
      Q: out bit;
      QBAR: out bit);
end T_FF;
 
Architecture behavioral_1 of T_FF is
signal t1, t2: bit;
begin
PROCESS(C, R)
variable tmp: bit;
begin
if(R='1') then
	tmp:='0';
elsif(C='1' and C'EVENT) then
	if (E ='0')then
		tmp:=tmp;
	else 
		tmp:= not tmp;
	end if;
end if;
Q <= tmp;
QBAR <= not tmp;
end PROCESS;


PROCESS(C,E,R)
variable time1, time2: time;
begin
if (C'EVENT and C='1' and R'LAST_EVENT<5ns and R'LAST_VALUE = '1') then
	report "min R recovery time >= 5ns" severity ERROR;
end if;
if (R'EVENT and C='1' and C'LAST_EVENT<5ns and R='0') then
	report "min C removal time to R >= 5ns" severity ERROR;
end if;
if (C'EVENT and C='1' and E'LAST_EVENT<5ns) then
	report "min E setup time to C >= 5ns" severity ERROR;
end if;
if (E'EVENT and C='1' and C'LAST_EVENT<5ns) then
	report "min C hold time to E >= 5ns" severity ERROR;
end if;
if (C'EVENT and C='1') then
	t1 <= not t1;
	time2 := t2'LAST_EVENT;
	if (t2'LAST_EVENT<=20ns) then
		report "C=0 width <= 20ns" severity ERROR;
	end if;
elsif (C'EVENT and C='0') then
	t2 <= not t2;
	time1 := t1'LAST_EVENT;
	if (t1'LAST_EVENT<=20ns) then
		report "C=1 width <= 20ns" severity ERROR;
	end if;
if (C'EVENT and (time1 + time2)<=55ns) then
	report "C period <= 55ns" severity ERROR;
end if; 

end if;
end PROCESS;
end behavioral_1;

Architecture behavioral_2 of T_FF is
begin
PROCESS
variable tmp: bit;
begin
if(R='1') then
	tmp:='0';
elsif(C='1' and C'EVENT) then
	if (E ='0')then
		tmp:=tmp;
	else 
		tmp:= not tmp;
	end if;
end if;
Q <= tmp;
QBAR <= not tmp;
wait on C,R;
end PROCESS;
end behavioral_2;

Architecture behavioral_3 of T_FF is
signal tmp:bit;
begin
B1: block (C='1' and C'EVENT)
begin
tmp <= guarded '0' when (R='1') else
      tmp when (C='1' and C'EVENT and E='0') else
      not tmp when (C='1' and C'EVENT and E='1');
Q <= tmp;
QBAR <= not tmp;
end block B1;
end behavioral_3;

Architecture behavioral_4 of T_FF is
signal tmp:bit;
begin
tmp <= '0' when (R='1') else
      not tmp when (C='1' and C'EVENT and E='1') else
      tmp;
Q <= tmp;
QBAR <= not tmp;
end behavioral_4;

Architecture behavioral_5 of T_FF is
begin
PROCESS(C, R)
variable tmp: bit;
begin
if(R='1') then
	tmp:='0';
elsif(C='1' and C'EVENT) then
	case E is
		when '0' => tmp:=tmp;
	        when '1' => tmp:= not tmp;
	end case;
end if;
Q <= tmp;
QBAR <= not tmp;
end PROCESS;
end behavioral_5;