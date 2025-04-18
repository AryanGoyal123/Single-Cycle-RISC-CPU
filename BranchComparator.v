module BranchComparator #(parameter WIDTH = 32) (
  input  [WIDTH-1:0] op1,
  input  [WIDTH-1:0] op2,
  input  [2:0]  funct3,
  output reg    branch_taken
);
  always @(*) begin
    case (funct3)
      3'b000: branch_taken = (op1 == op2);               // BEQ
      3'b001: branch_taken = (op1 != op2);               // BNE
      3'b100: branch_taken = ($signed(op1) <  $signed(op2)); // BLT
      3'b101: branch_taken = ($signed(op1) >= $signed(op2)); // BGE
      3'b110: branch_taken = (op1 <  op2);               // BLTU
      3'b111: branch_taken = (op1 >= op2);               // BGEU
      default: branch_taken = 1'b0;
    endcase
  end
endmodule
