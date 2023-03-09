library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all; -- libreria WORK user-defined

entity TBFD is
end TBFD;

architecture TEST of TBFD is

	constant NBIT: integer := 16; 
	signal	CK:		std_logic :='0';
	signal	RESET:		std_logic :='0';
	signal	D:		std_logic_vector(NBIT-1 downto 0);
	signal	QSYNCH:		std_logic_vector(NBIT-1 downto 0);
	signal	QASYNCH:	std_logic_vector(NBIT-1 downto 0);
	
	component FD_GENERIC
	generic (NBIT : integer := NumBIT);
	Port (	D:	In	std_logic_vector(NBIT-1 downto 0);
			CK:	In	std_logic;
			RESET:	In	std_logic;
			Q:	Out	std_logic_vector(NBIT-1 downto 0));
	end component;

begin 
		
	UFD1 : FD_GENERIC
	Generic Map (NBIT)
	Port Map ( D, CK, RESET,  QSYNCH); -- sinc

	UFD2 : FD_GENERIC
	Generic Map (NBIT)
	Port Map (D, CK, RESET,  QASYNCH); -- asinc
	

	RESET <= '0', '1' after 0.6 ns, '0' after 1.1 ns, '1' after 2.2 ns, '0' after 3.2 ns;	
	
	
	D <= "0000110100001111", "0000111100001111" after 0.4 ns, "0000110100001111" after 1.1 ns, "0101010111110101" after 1.4 ns, "0000111101001111" after 1.7 ns, "0101010110010101" after 1.9 ns;

	
	PCLOCK : process(CK)
	begin
		CK <= not(CK) after 0.5 ns;	
	end process;



	

end TEST;

configuration FDTEST of TBFD is
   for TEST
      for UFD1 : FD_GENERIC
         use configuration WORK.CFG_FD_GENERIC_PIPPO; -- sincrono
      end for;
      for UFD2 : FD_GENERIC
         use configuration WORK.CFG_FD_GENERIC_PLUTO; -- asincrono
      end for;


   end for;
end FDTEST;

