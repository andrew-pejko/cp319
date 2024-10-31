-- Testbench

LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;
	USE IEEE.NUMERIC_STD.ALL;
    use std.textio.all;

ENTITY RAM_TB IS 
-- empty
END ENTITY;

ARCHITECTURE Behavioral OF RAM_TB IS

SIGNAL DATAIN,instruction, imm : STD_LOGIC_VECTOR(31 DOWNTO 0):= "00000000000000000000000000000000";
SIGNAL ADDRESS : STD_LOGIC_VECTOR(7 DOWNTO 0):= "00000000";
SIGNAL decoded_instruction : STRING(1 TO 100);
signal opcode, funct7 : std_logic_vector(6 downto 0);
signal funct3 : std_logic_vector(2 downto 0);
signal rd, rs1, rs2 : std_logic_vector(4 downto 0);
SIGNAL W_R : STD_LOGIC:='0';
SIGNAL DATAOUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL address_counter : integer := 0; -- Initialize the counter

-- DUT component
COMPONENT RAM IS
    PORT(DATAIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
         ADDRESS : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         W_R : IN STD_LOGIC;
         DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
         );
END COMPONENT;

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



BEGIN

  -- Connect DUT
  UUT: RAM PORT MAP(DATAIN, ADDRESS, W_R, DATAOUT);
  UUA: decoder PORT MAP(instruction, opcode, funct3, funct7, rd, rs1, rs2, imm);
  
  PROCESS
  
  file text_file : text open read_mode is "test.txt";
  variable text_line : line;
  variable ok : boolean;
  variable data : STD_LOGIC_VECTOR(31 DOWNTO 0);
  
  BEGIN

  while not endfile(text_file) loop
  	readline(text_file, text_line);
    read(text_line, data, ok);
  	DATAIN <= data;
    ADDRESS <= std_logic_vector(to_unsigned(address_counter, ADDRESS'length));
    address_counter <= address_counter + 1;
    WAIT FOR 100 ns;
  end loop;

    -- Read data from RAM
    W_R<='1';
    
    ADDRESS<="00000000";
    wait for 100 ns;
    
    for i in 0 to address_counter loop
    ADDRESS <= std_logic_vector(to_unsigned(i, ADDRESS'length));
    instruction <= DATAOUT;
    wait for 100 ns;
    end loop;
    
    ASSERT FALSE REPORT "Test done. Open EPWave to see signals." SEVERITY NOTE;
    WAIT;
  END PROCESS;

END Behavioral;
