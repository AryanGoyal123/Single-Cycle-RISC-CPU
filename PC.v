// 32 bit PC Store Module
module pc #(parameter WIDTH = 32)(
  input wire clk, reset,
  input wire [WIDTH-1:0] next_pc,
  output wire [WIDTH-1:0] pc_out
);
  
  always @(posedge clk) begin
    if(reset)
      pc_out = 32'b0;
    else 
      pc_out <= next_pc;
  end
  
endmodule
