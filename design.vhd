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

signal DATAIN_IN, DATAOUT_OUT, instruction_in, imm_in : STD_LOGIC_VECTOR(31 DOWNTO 0);  
signal ADDRESS_IN : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal opcode_in, funct7_in : std_logic_vector(6 downto 0);
signal funct3_in : std_logic_vector(2 downto 0);
signal rd_in, rs1_in, rs2_in : std_logic_vector(4 downto 0);
signal W_R_IN : STD_LOGIC;

Component RAM IS
  PORT(
       DATAIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
       ADDRESS : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       W_R : IN STD_LOGIC;
       DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
END Component;

Component decoder IS
    Port (
        instruction : in std_logic_vector(31 downto 0);  -- 32-bit RV32i instruction
        opcode      : out std_logic_vector(6 downto 0);  -- Primary opcode field
        funct3      : out std_logic_vector(2 downto 0);  -- Secondary function field
        funct7      : out std_logic_vector(6 downto 0);  -- Additional function field
        rd          : out std_logic_vector(4 downto 0);  -- Destination register
        rs1         : out std_logic_vector(4 downto 0);  -- Source register 1
        rs2         : out std_logic_vector(4 downto 0);  -- Source register 2
        imm         : out std_logic_vector(31 downto 0)  -- Immediate value (varies by instruction)
    );
END Component;


Begin

u1: RAM port map(DATAIN => DATAIN_IN, ADDRESS => ADDRESS_IN, W_R => W_R_IN, DATAOUT => DATAOUT_OUT);
u2: decoder port map(instruction => instruction_in, opcode => opcode_in, funct3 => funct3_in, funct7 => funct7_in, rd => rd_in, rs1 => rs1_in, rs2 => rs2_in, imm => imm_in);

end Behavioral;