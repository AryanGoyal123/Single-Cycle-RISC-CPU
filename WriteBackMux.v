//Chooses whether the value written back into the register file comes from the ALU result or the data memory (for loads)
module WriteBackMux #(parameter WIDTH = 32)(
  input [WIDTH-1:0] alu_result, mem_read_data,
  input  MemToReg,
  output [WIDTH-1:0] write_data
);
	assign write_data = MemToReg ? mem_read_data : alu_result;

endmodule
