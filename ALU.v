module alu #(parameter WIDTH = 32)(
  input wire [WIDTH-1: 0] a,
  input wire [WIDTH-1: 0] b,
  input wire [3:0] alu_control,
  output reg [WIDTH-1: 0] result,
  output wire zero     
);

 always @(*) begin
   case(alu_control)
     4'b0000: result = a & b; // AND
     4'b0001: result = a | b; //OR
     4'b0010: result = a + b; //ADD
     4'b0110: result = a - b; // SUB
     4'b0011: result = a ^ b; //XOR
     4'b0100: reuslt = a << b[4:0]; //SLL (Logical Shift left)
     4'b0101: result = a >> b[4:0]; //SRL (Logical Shift Right)
     4'b1000: result = $signed(a) >>> b[4:0];            // SRA (Arithmetic Right Shift)
     4'b0111: result = ($signed(a) < $signed(b)) ? 1 : 0;// SLT (Set Less Than - signed)
     4'b1001: result = (a < b) ? 1 : 0;                  // SLTU (Set Less Than - unsigned)
     default: result = 32'b0;
   endcase
 end
  
  assign zero = (result == 1'b0);

endmodule
