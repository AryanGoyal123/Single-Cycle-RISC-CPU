module immediate_generator #(parameter WIDTH = 32)(
  input wire [WIDTH-1:0] instr;
  output reg [WIDTH-1:0] imm_out;
);
  wire [6:0] opcode = instr[6:0];
  
  always @(*) begin
    case (opcode)
      // I-type
      7'b0010011, 7'b0000011: imm_out = {{20{instr[31]}}, instr[31:20]}; // LW
      // S-type
      7'b0100011: imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // SW
      // B-type
      7'b1100011: imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // BEQ, BNE, etc.
      // U-type
      7'b0110111, 7'b0010111: imm_out = {instr[31:12], 12'b0}; // LIU, AUIPC
      // J-type
      7'b1101111: imm_out = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // JAL
      default:imm_out = {WIDTH{1'b0}};
    endcase
  end
endmodule
