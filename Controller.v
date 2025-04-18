module Controller #(parameter WIDTH = 32)(
  input [WIDTH-1:0] instr,
  output reg RegWrite, ALUSrc, MemWrite, MemRead, Branch, Jump,
  output reg [1:0] ALUop
);

  // Decode fields
  wire [6:0] opcode = instr[6:0];
  wire [2:0] funct3 = instr[14:12];
  wire [6:0] funct7 = instr[31:25];
  
  always @(*) begin
    // ——— Defaults ———
    RegWrite = 0;
    ALUSrc   = 0;
    MemRead  = 0;
    MemWrite = 0;
    Branch   = 0;
    Jump     = 0;
    ALUop    = 2'b00;
    
    case(opcode) 
      // R‑type: add, sub, and, or, slt, etc.
      7'b0110011: begin	// R-type instructions
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ALUop    = 2'b10;
      end
      
      // I‑type ALU: addi, andi, ori, slti
      7'b0010011: begin
        RegWrite = 1'b1;
        ALUSrc = 1'b1;
        ALUop = 2'b11;
      end
      
       // Load (lw)
      7'b0000011: begin
        RegWrite = 1;
        ALUSrc   = 1;
        MemRead  = 1;
        ALUop    = 2'b00;  // ADD for address calc
      end
      
      // Store (sw)
      7'b0100011: begin
        MemWrite = 1;
        ALUSrc   = 1;
        ALUop    = 2'b00;  // ADD for address calc
      end
    
            // Branch (beq, bne, blt, bge)
      7'b1100011: begin
        Branch = 1;
        ALUSrc = 0;
        ALUop  = 2'b01;    // SUB for comparison
      end

      // JAL
      7'b1101111: begin
        RegWrite = 1;
        Jump     = 1;
      end

      // JALR
      7'b1100111: begin
        RegWrite = 1;
        Jump     = 1;
        ALUSrc   = 1;      // uses rs1 + imm
      end
      
      default : begin
      end
      
    endcase
  end
endmodule
