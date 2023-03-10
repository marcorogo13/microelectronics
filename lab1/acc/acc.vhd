library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use WORK.constants.all; -- libreria WORK user-defined
use IEEE.numeric_std.all; -- to sum unsigned numbers

entity ACC is 
	generic (NBIT : integer := numBit);
	port (
      A          : in  std_logic_vector(NBIT - 1 downto 0);
      B          : in  std_logic_vector(NBIT - 1 downto 0);
      CLK        : in  std_logic;
      RST_n      : in  std_logic;
      ACCUMULATE : in  std_logic;
      --- ACC_EN_n   : in  std_logic;  -- optional use of the enable
      Y          : out std_logic_vector(NBIT - 1 downto 0));
end ACC;


architecture BEHAVIORAL of ACC is

signal tmp, tmp_next: std_logic_vector(NBIT - 1  downto 0);

begin
regProc : process (CLK) 
begin
    if (RST_n = '0') then     --reset is active low!
        tmp <= (others => '0');
    elsif rising_edge(CLK) then
	if (ACCUMULATE = '1') then
		tmp <= std_logic_vector(unsigned(tmp) + unsigned(A)); --if accumulate == 1 increment the current value
	else
		tmp <= std_logic_vector(unsigned(A) + unsigned(B));   --otherwise use the B input to add to A
	end if;
   
    end if;    
end process regProc;

end BEHAVIORAL;


architecture STRUCTURAL of ACC is
	signal RST: std_logic;
	signal mux_out: std_logic_vector(NBIT-1 downto 0);
	signal add_out: std_logic_vector(NBIT-1 downto 0);
	signal reg_out: std_logic_vector(NBIT-1 downto 0);
    signal Co: std_logic; --needed to instanciate the RCA but not used
	component MUX21_GENERIC
	generic (NBIT : integer := numBit;
			DELAY_MUX: Time := TP_MUX);
	port (	A:	In	std_logic_vector(NBIT-1 downto 0);
			B:	In	std_logic_vector(NBIT-1 downto 0);
			S:	In	std_logic;
			Y:	Out	std_logic_vector(NBIT-1 downto 0));
	end component;
	
	component RCA_GENERIC
	generic (NBIT : integer := NumBit;
           DRCAS : 	Time := 0 ns;
	         DRCAC : 	Time := 0 ns);
	Port (	A:	In	std_logic_vector(NBIT - 1 downto 0);
          B:	In	std_logic_vector(NBIT - 1 downto 0);
          Ci:	In	std_logic;
          S:	Out	std_logic_vector(NBIT - 1 downto 0);
          Co:	Out	std_logic);
	end component;

    component FD_GENERIC
	generic (NBIT : integer := numBit);
	Port (	D:	In	std_logic_vector(NBIT-1 downto 0);
		CK:	In	std_logic;
		RESET:	In	std_logic;
		Q:	Out	std_logic_vector(NBIT-1 downto 0));
    end component;

begin
	
	RST <= not(RST_n);	

    UMUX: MUX21_GENERIC
    generic map(NBIT, TP_MUX)
    port map(reg_out, B, ACCUMULATE, mux_out);

    UADD : RCA_GENERIC
    generic map(NBIT, 0 ns, 0 ns)
    port map(A, mux_out, '0', add_out, Co);

    UREG : FD_GENERIC
    generic map(NBIT)
    port map(add_out, CLK, RST, reg_out);

    Y <= reg_out;

end STRUCTURAL;

configuration CFG_ACC_BEHAVIORAL of ACC is
	for BEHAVIORAL
	end for;
end CFG_ACC_BEHAVIORAL;

configuration CFG_ACC_STRUCTURAL of ACC is
	for STRUCTURAL
	end for;
end CFG_ACC_STRUCTURAL;


