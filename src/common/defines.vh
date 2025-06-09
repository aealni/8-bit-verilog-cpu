// defines.vh - Global definitions for CPU

// ===================
// Instruction Opcodes (bits 7:5 of instruction word)
// ===================
`define OPCODE_ADD    3'b000
`define OPCODE_SUB    3'b001
`define OPCODE_NAND   3'b010
`define OPCODE_LOAD   3'b011
`define OPCODE_STORE  3'b100
`define OPCODE_JMP    3'b101
`define OPCODE_JZ     3'b110
`define OPCODE_HALT   3'b111

// ===================
// ALU Operations (used in control -> alu_op)
// ===================
`define ALU_ADD       2'b00
`define ALU_SUB       2'b01
`define ALU_NAND      2'b10

// ===================
// reg_src options
// ===================
`define REG_SRC_ALU   2'b00
`define REG_SRC_RAM   2'b01
`define REG_SRC_ZERO  2'b11

// ===================
// pc_src options
// ===================
`define PC_SRC_INC    1'b0  // PC + 1
`define PC_SRC_JUMP   1'b1  // Jump target

// ===================
// mem_addr_src options
// ===================
`define MEM_ADDR_PC   1'b0
`define MEM_ADDR_IR   1'b1

// ===================
// Register file
// ===================
`define REG_ZERO      2'b00  // ADD, SUB accumulator
`define REG_1         2'b01
`define REG_2         2'b10
`define REG_3         2'b11

// ===================
// Other constants
// ===================
`define WORD_SIZE     8
`define ADDR_WIDTH    5     // 5-bit addressing (32 words)
`define RAM_DEPTH     32    // 256 bits / 8 bits per word
