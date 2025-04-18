module ALUController (
  input  [1:0] ALUop,        // from main control unit
  input  [2:0] funct3,       // instr[14:12]
  input  [6:0] funct7,       // instr[31:25]
  output reg [3:0] alu_control
);

  //-------------------------------------------------------------------------
  // ALUop encoding from main control
  //-------------------------------------------------------------------------
  localparam OP_ADD_SUB  = 2'b00; // load/store use ADD for address calc
  localparam OP_BRANCH   = 2'b01; // compare (=SUB) for BEQ/BNE/etc.
  localparam OP_REG      = 2'b10; // R‑type register‑register
  localparam OP_IMM      = 2'b11; // I‑type immediate ALU

  //-------------------------------------------------------------------------
  // ALU control signals (4‑bit)
  //-------------------------------------------------------------------------
  localparam ALU_AND     = 4'b0000;
  localparam ALU_OR      = 4'b0001;
  localparam ALU_ADD     = 4'b0010;
  localparam ALU_XOR     = 4'b0011;
  localparam ALU_SLL     = 4'b0100;
  localparam ALU_SRL     = 4'b0101;
  localparam ALU_SUB     = 4'b0110;
  localparam ALU_SLT     = 4'b0111;
  localparam ALU_SRA     = 4'b1000;
  localparam ALU_SLTU    = 4'b1001;

  //-------------------------------------------------------------------------
  // fun3 constants 
  //-------------------------------------------------------------------------
  localparam F3_ADD_SUB = 3'b000;
  localparam F3_SLL     = 3'b001;
  localparam F3_SLT     = 3'b010;
  localparam F3_SLTU    = 3'b011;
  localparam F3_XOR     = 3'b100;
  localparam F3_SRL_SRA = 3'b101;
  localparam F3_OR      = 3'b110;
  localparam F3_AND     = 3'b111;

  // special funct7 for SUB vs. ADD, and SRA vs. SRL
  localparam F7_SUB_SRA = 7'b0100000;

  //-------------------------------------------------------------------------
  always @(*) begin
    case (ALUop)
      OP_ADD_SUB:  alu_control = ALU_ADD;
      OP_BRANCH:   alu_control = ALU_SUB;

      OP_IMM: begin
        case (funct3)
          F3_ADD_SUB:    alu_control = ALU_ADD; 
          F3_AND:        alu_control = ALU_AND;
          F3_OR:         alu_control = ALU_OR;
          F3_XOR:        alu_control = ALU_XOR;
          F3_SLT:        alu_control = ALU_SLT;
          F3_SLTU:       alu_control = ALU_SLTU;
          F3_SLL:        alu_control = ALU_SLL;
          F3_SRL_SRA:    // choose between SRL and SRA based on funct7
            alu_control = (funct7 == F7_SUB_SRA) ? ALU_SRA : ALU_SRL;
          default:       alu_control = ALU_ADD;
        endcase
      end

      OP_REG: begin
        case (funct3)
          F3_ADD_SUB: alu_control = (funct7 == F7_SUB_SRA) ? ALU_SUB : ALU_ADD;// ADD vs. SUB
          F3_AND: alu_control = ALU_AND;
          F3_OR:  alu_control = ALU_OR;
          F3_XOR: alu_control = ALU_XOR;
          F3_SLL: alu_control = ALU_SLL;
          F3_SRL_SRA: alu_control = (funct7 == F7_SUB_SRA) ? ALU_SRA : ALU_SRL;
          F3_SLT: alu_control = ALU_SLT;
          F3_SLTU: alu_control = ALU_SLTU;
          default: alu_control = ALU_ADD;
        endcase
      end

      default: alu_control = ALU_ADD;
    endcase
  end
endmodule
