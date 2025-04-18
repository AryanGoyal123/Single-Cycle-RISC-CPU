module instruction_memory #(parameter WIDTH = 32)(
  input [WIDTH-1:0] addr,
  output [WIDTH-1:0] instr
);
  reg [WIDTH-1:0] registers [0:WIDTH-1];
  
  assign instr = registers[addr[9:2]];
  
endmodule
