module DataMemory #(parameter WIDTH = 32) (
  input clk, 
  input MemRead, MemWrite,
  input [WIDTH-1:0] addr, write_data,
  output [WIDTH-1:0] read_data
);

  localparam DEPTH = WIDTH;
  localparam ADDR_BITS = $clog2(DEPTH); 
  
  reg [WIDTH-1:0] mem [0:DEPTH-1]; // memory
  
  // drop bottom two bits (word‐aligned) and take ADDR_BITS bits  
  wire [ADDR_BITS-1:0] index = addr[ADDR_BITS+1:2];
  
  always @(posedge clk) begin
    if (MemWrite)
      mem[index] <= write_data;
  end
  
  //combinational read
  always @(*) begin
    if(MemRead)
      read_data = mem[index];
    else
      read_data = {WIDTH{1'b0}};
  end
endmodule
