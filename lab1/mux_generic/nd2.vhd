library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use WORK.constants.all; -- libreria WORK user-defined

entity ND2 is
	generic (NBIT : integer := numBit);
	Port (	A:	In	std_logic;
			B:	In	std_logic;
			Y:	Out	std_logic);
end ND2;


architecture ARCH1 of ND2 is

begin
	Y <= not( A and B) after NDDELAY; -- NAND 
end ARCH1;



configuration CFG_ND2_ARCH1 of ND2 is
	for ARCH1
	end for;
end CFG_ND2_ARCH1;


