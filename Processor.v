module Processor(
  input clk, reset
);
  wire RegWrite, ALUSrc, MemWrite, MemRead, Branch, Jump;
  wire [1:0] ALUop;
  wire [31:0] instr;
  
  // 1) Controller: needs the fetched instruction
  Controller control1 (
    .instr    (instr),
    .RegWrite (RegWrite),
    .ALUSrc   (ALUSrc),
    .MemWrite (MemWrite),
    .MemRead  (MemRead),
    .Branch   (Branch),
    .Jump     (Jump),
    .ALUop    (ALUop)
  );

  // 2) DataPath: does everything else (including IMEM & DMEM)
  DataPath datapath1 (
    .clk       (clk),
    .reset     (reset),
    .RegWrite  (RegWrite),
    .ALUSrc    (ALUSrc),
    .MemWrite  (MemWrite),
    .MemRead   (MemRead),
    .Branch    (Branch),
    .Jump      (Jump),
    .ALUop     (ALUop),
    .instr_out (instr)     // datapath must drive this to feed the controller
  );

endmodule
