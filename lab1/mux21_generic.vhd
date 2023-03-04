library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use WORK.constants.all; -- libreria WORK user-defined


--reused the LAB0 mux21, just generilized for NBITs

entity MUX21_GENERIC is 
	generic (NBIT : integer := numBit;
			DELAY_MUX: Time := TP_MUX);
	port (	A:	In	std_logic_vector(NBIT-1 downto 0);
			B:	In	std_logic_vector(NBIT-1 downto 0);
			S:	In	std_logic;
			Y:	Out	std_logic_vector(NBIT-1 downto 0));
end MUX21_GENERIC;


architecture BEHAVIORAL of MUX21_GENERIC is

begin
	Y <= (A and S) or (B and not(S)) after DELAY_MUX; -- processo implicito

end BEHAVIORAL;


architecture STRUCTURAL of MUX21_GENERIC is

	signal Y1: std_logic_vector(NBIT-1 downto 0);
	signal Y2: std_logic_vector(NBIT-1 downto 0);
	signal SB: std_logic;

	component ND2
	generic(NBIT: integer:= numBit);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
			B:	In	std_logic_vector(NBIT-1 downto 0);
			Y:	Out	std_logic_vector(NBIT-1 downto 0));
	end component;
	
	component IV
	generic(NBIT: integer:= numBit);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
			Y:	Out	std_logic_vector(NBIT-1 downto 0));
	end component;

begin

	UIV : IV
	Port Map ( S, SB);

	UND1 : ND2
	Port Map ( A, S, Y1);

	UND2 : ND2
	Port Map ( B, SB, Y2);

	UND3 : ND2
	Port Map ( Y1, Y2, Y);


end STRUCTURAL;


configuration CFG_MUX21_GENERIC_BEHAVIORAL of MUX21 is
	for BEHAVIORAL_1
	end for;
end CFG_MUX21_GENERIC_BEHAVIORAL;


configuration CFG_MUX21_GENERIC_STRUCTURAL of MUX21 is
	for STRUCTURAL
		for all : IV
			use configuration WORK.CFG_IV_BEHAVIORAL;
		end for;
		for all : ND2
			use configuration WORK.CFG_ND2_ARCH2;
		end for;
	end for;
end CFG_MUX21_GENERIC_STRUCTURAL;
