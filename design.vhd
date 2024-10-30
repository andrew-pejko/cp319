-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity design is
    Port ( CLK : in STD_LOGIC;
           );        
end design;

architecture Behavioral of design is

signal DATAIN_IN, DATAOUT_OUT, instruction_in : STD_LOGIC_VECTOR(31 DOWNTO 0);  
signal ADDRESS_IN : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal decoded_instruction_out : STRING(1 TO 100);
signal W_R_IN : STD_LOGIC;

Component RAM IS
  PORT(
       DATAIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
       ADDRESS : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       W_R : IN STD_LOGIC;
       DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
END Component;

Component InstructionDecoder IS
    PORT (
        instruction : IN  STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input machine code
        decoded_instruction : OUT STRING(1 TO 100) -- Decoded instruction output
    );
END Component;


Begin

u1: RAM port map(DATAIN => DATAIN_IN, ADDRESS => ADDRESS_IN, W_R => W_R_IN, DATAOUT => DATAOUT_OUT);
u2: InstructionDecoder port map(instruction => instruction_in, decoded_instruction => decoded_instruction_out);

end Behavioral;