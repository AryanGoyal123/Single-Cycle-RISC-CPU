module ALUOperMux #(parameter WIDTH = 32)(
  input [WIDTH-1:0] read_data2, imm,
  input ALUSrc, // 0 for reg, 1 for imm
  output [WIDTH-1:0] alu_b
);

  assign alu_b = ALUSrc ? imm: read_data2;

endmodule
