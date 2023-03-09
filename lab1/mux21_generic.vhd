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
	with S select 
	Y <= A when '0',
	     B when '1',
		 A when others; 

end BEHAVIORAL;


architecture STRUCTURAL of MUX21_GENERIC is

	signal Y1: std_logic_vector(NBIT-1 downto 0);
	signal Y2: std_logic_vector(NBIT-1 downto 0);
	signal SB: std_logic;

	component ND2
	Port (	A:	In	std_logic;
			B:	In	std_logic;
			Y:	Out	std_logic);
	end component;
	
	component IV
	Port (	A:	In	std_logic;
			Y:	Out	std_logic);
	end component;

begin

	UIV : IV
	generic map(NBIT)
	Port Map ( S, SB);
	
    UND1: for I in 0 to NBIT-1 generate
		UND1I : ND2  
		  Port Map (A(I), S, Y1(I)); 
	end generate;
	
    UND2: for I in 0 to NBIT-1 generate
		UND2I : ND2  
		  Port Map (B(I), SB, Y2(I)); 
	end generate;
	
    UND3: for I in 0 to NBIT-1 generate
		UND3I : ND2  
		  Port Map (Y1(I), Y2(I), Y(I)); 
	end generate;
	
end STRUCTURAL;


configuration CFG_MUX21_GENERIC_BEHAVIORAL of MUX21_GENERIC is
	for BEHAVIORAL
	end for;
end CFG_MUX21_GENERIC_BEHAVIORAL;


configuration CFG_MUX21_GENERIC_STRUCTURAL of MUX21_GENERIC is
	for STRUCTURAL
		for all : IV
			use configuration WORK.CFG_IV_BEHAVIORAL;
		end for;
		for all : ND2
			use configuration WORK.CFG_ND2_ARCH1;
		end for;
	end for;
end CFG_MUX21_GENERIC_STRUCTURAL;
