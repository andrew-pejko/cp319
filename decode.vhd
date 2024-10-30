LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY InstructionDecoder IS
    PORT (
        instruction : IN  STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input machine code
        decoded_instruction : OUT STRING(1 TO 100) -- Decoded instruction output
    );
END ENTITY;

ARCHITECTURE Behavioral OF InstructionDecoder IS
    SIGNAL opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL rd : INTEGER;
    SIGNAL rs1 : INTEGER;
    SIGNAL rs2 : INTEGER;
    SIGNAL funct3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL funct7 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL immediate : INTEGER;
BEGIN
    PROCESS(instruction)
    BEGIN
        -- Extract fields from the instruction
        opcode <= instruction(6 DOWNTO 0);
        rd <= to_integer(unsigned(instruction(11 DOWNTO 7)));
        rs1 <= to_integer(unsigned(instruction(19 DOWNTO 15)));
        rs2 <= to_integer(unsigned(instruction(24 DOWNTO 20)));
        funct3 <= instruction(14 DOWNTO 12);
        funct7 <= instruction(31 DOWNTO 25);

        -- Decode based on opcode
        CASE opcode IS
            WHEN "0000011" => -- Load
                CASE funct3 IS
                    WHEN "010" => -- LB
                        decoded_instruction <= "LB x" & INTEGER'IMAGE(rd) & ", 0(x" & INTEGER'IMAGE(rs1) & ")";
                    WHEN "100" => -- LW
                        decoded_instruction <= "LW x" & INTEGER'IMAGE(rd) & ", 0(x" & INTEGER'IMAGE(rs1) & ")";
                    WHEN "000" => -- LBU
                        decoded_instruction <= "LBU x" & INTEGER'IMAGE(rd) & ", 0(x" & INTEGER'IMAGE(rs1) & ")";
                    WHEN OTHERS => NULL;
                END CASE;

            WHEN "0100011" => -- Store
                CASE funct3 IS
                    WHEN "010" => -- SW
                        decoded_instruction <= "SW x" & INTEGER'IMAGE(rs2) & ", 0(x" & INTEGER'IMAGE(rs1) & ")";
                    WHEN OTHERS => NULL;
                END CASE;

            WHEN "0010011" => -- I-type
                CASE funct3 IS
                    WHEN "000" => -- ADDI
                        immediate <= to_integer(signed(instruction(31 DOWNTO 20)));
                        decoded_instruction <= "ADDI x" & INTEGER'IMAGE(rd) & ", x" & INTEGER'IMAGE(rs1) & ", " & INTEGER'IMAGE(immediate);
                    WHEN OTHERS => NULL;
                END CASE;

            WHEN "0110011" => -- R-type
                CASE funct3 IS
                    WHEN "000" => -- ADD
                        IF funct7 = "0000000" THEN
                            decoded_instruction <= "ADD x" & INTEGER'IMAGE(rd) & ", x" & INTEGER'IMAGE(rs1) & ", x" & INTEGER'IMAGE(rs2);
                        ELSIF funct7 = "0100000" THEN
                            decoded_instruction <= "SUB x" & INTEGER'IMAGE(rd) & ", x" & INTEGER'IMAGE(rs1) & ", x" & INTEGER'IMAGE(rs2);
                        END IF;
                    WHEN "111" => -- AND
                        decoded_instruction <= "AND x" & INTEGER'IMAGE(rd) & ", x" & INTEGER'IMAGE(rs1) & ", x" & INTEGER'IMAGE(rs2);
                    WHEN "110" => -- OR
                        decoded_instruction <= "OR x" & INTEGER'IMAGE(rd) & ", x" & INTEGER'IMAGE(rs1) & ", x" & INTEGER'IMAGE(rs2);
                    WHEN OTHERS => NULL;
                END CASE;

            WHEN "1101111" => -- JAL
                immediate <= to_integer(signed(instruction(31 DOWNTO 12))); -- Extract immediate
                decoded_instruction <= "JAL x" & INTEGER'IMAGE(rd) & ", " & INTEGER'IMAGE(immediate);

            WHEN OTHERS => NULL; -- Handle other instruction types as needed
        END CASE;
    END PROCESS;
END ARCHITECTURE;
