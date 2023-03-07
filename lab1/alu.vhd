library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all; -- for arith operations
use WORK.constants.all;
use WORK.alu_types.all;

entity ALU is
  generic (N : integer := numBit);
  port 	 ( FUNC: IN TYPE_OP;
           DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
           OUTALU: OUT std_logic_vector(N-1 downto 0));
end ALU;

architecture BEHAVIOR of ALU is
begin

P_ALU: process (FUNC, DATA1, DATA2)
  -- complete all the requested functions

  begin
    case FUNC is
      when ADD 	=> OUTALU <= std_logic_vector(unsigned(DATA1) + unsigned(DATA2)); 
      when SUB 	=> OUTALU <= std_logic_vector(unsigned(DATA1) - unsigned(DATA2));
      when MULT 	=> OUTALU <= std_logic_vector(resize(unsigned (HALFD1), N) * resize(unsigned (HALFD2), N));
      when BITAND 	=> OUTALU <= DATA1 and DATA2; -- bitwise operations
      when BITOR 	=> OUTALU <= DATA1 or DATA2;
      when BITXOR 	=> OUTALU <= DATA1 xor DATA2 ;
      when FUNCLSL 	=> OUTALU  <= std_logic_vector(shift_left(unsigned(DATA1), to_integer(unsigned(DATA2)))); -- logical shift left, HELP: use the concatenation operator &  
      --DATA1(N-1-to_integer(unsigned(DATA2)) downto 0) & (to_integer(unsigned(DATA2)) - 1 downto 0 => '0'); 
      --std_logic_vector(shift_left(unsigned(DATA1), to_integer(unsigned(DATA2)))); -- logical shift left, HELP: use the concatenation operator &  
--      when FUNCLSR 	=> OUTALU <= shift_right(DATA1, to_integer(unsigned(DATA2))); -- logical shift right
--      when FUNCRL 	=> OUTALU <= rotate_left(DATA1, to_integer(unsigned(DATA2))); -- rotate left
--      when FUNCRR 	=> OUTALU <= rotate_right(DATA1, to_integer(unsigned(DATA2))); -- toate right
      when others => null;
    end case; 
  end process P_ALU;

end BEHAVIOR;

configuration CFG_ALU_BEHAVIORAL of ALU is
  for BEHAVIOR
  end for;
end CFG_ALU_BEHAVIORAL;
