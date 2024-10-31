library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decoder is
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
end decoder;

architecture Behavioral of decoder is
begin
    process(instruction)
    begin
        -- Extract fields from the 32-bit instruction
        opcode <= instruction(6 downto 0);       -- Opcode is the 7 least-significant bits
        rd     <= instruction(11 downto 7);      -- Destination register
        funct3 <= instruction(14 downto 12);     -- Function code (3 bits)
        rs1    <= instruction(19 downto 15);     -- Source register 1
        rs2    <= instruction(24 downto 20);     -- Source register 2
        funct7 <= instruction(31 downto 25);     -- Additional function code (7 bits)
        
        -- Immediate value decoding based on instruction type
        case opcode is
            -- I-Type Instructions (e.g., ADDI)
            when "0010011" =>   -- Example: ADDI, ORI, ANDI, etc.
                imm <= std_logic_vector(signed(instruction(31 downto 20)));  -- sign-extended 12-bit immediate

            -- S-Type Instructions (e.g., SW)
            when "0100011" =>   -- Example: SW, SB, SH
                imm <= std_logic_vector(signed(instruction(31 downto 25) & instruction(11 downto 7))); -- 12-bit immediate

            -- B-Type Instructions (e.g., BEQ)
            when "1100011" =>   -- Example: BEQ, BNE, BLT, etc.
                imm <= std_logic_vector(signed(instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & "0"));  -- 13-bit immediate (B-type)

            -- U-Type Instructions (e.g., LUI, AUIPC)
            when "0110111" | "0010111" => -- LUI or AUIPC
                imm <= instruction(31 downto 12) & "000000000000"; -- 20-bit immediate

            -- J-Type Instructions (e.g., JAL)
            when "1101111" =>   -- Example: JAL
                imm <= std_logic_vector(signed(instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & "0")); -- 21-bit immediate

            -- Default case for other instructions
            when others =>
                imm <= (others => '0');  -- Default to 0 for unsupported instructions
        end case;
    end process;
end Behavioral;
