LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- RAM entity
ENTITY RAM IS
  PORT(
       DATAIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- 32-bit input
       ADDRESS : IN STD_LOGIC_VECTOR(7 DOWNTO 0);   -- 8-bit address
       W_R : IN STD_LOGIC;                           -- Write when 0, Read when 1
       DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)  -- 32-bit output
       );
END ENTITY;

-- RAM architecture
ARCHITECTURE Behavioral OF RAM IS

-- Change the array type to hold 32-bit values
TYPE MEM IS ARRAY (255 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MEMORY : MEM;
SIGNAL ADDR : INTEGER RANGE 0 TO 255;

BEGIN

  PROCESS(ADDRESS, DATAIN, W_R)
  BEGIN

    ADDR <= CONV_INTEGER(ADDRESS);  -- Convert address from std_logic_vector to integer
    IF (W_R = '0') THEN
      MEMORY(ADDR) <= DATAIN;  -- Write data into memory
    ELSIF (W_R = '1') THEN
      DATAOUT <= MEMORY(ADDR);  -- Read data from memory
    ELSE
      DATAOUT <= (others => 'Z');  -- High impedance state
    END IF;
  END PROCESS;

END Behavioral;
