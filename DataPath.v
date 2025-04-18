module DataPath(
  input clk, reset, 
  input RegWrite, ALUSrc, MemWrite, MemRead, Branch, Jump,
  input [1:0] ALUop,
  output [31:0] instr_out
);
  // the PC, adder, and mux modules
  localparam WIDTH = 32;
 
  wire [WIDTH-1:0] next_pc, pc_out, pc_plus4, instr, imm, branch_target, jump_target;
  wire alu_b, alu_control, alu_result, zero;
  wire MemToReg;
  wire branch_cond;
  wire take_branch = Branch & branch_cond;
  
  wire [WIDTH-1:0] read_data1, read_data2;
  wire [WIDTH-1:0] write_back_data;
  wire [WIDTH-1:0] mem_read_data;
 
  PC pc1 (.clk(clk), .reset(reset), .next_pc(next_pc), .pc_out(pc_out));
  
  //PC = PC + 4
  PC_adder #(.WIDTH(WIDTH)) pcadd1 (.pc_in(pc_out), .pc_out(pc_plus4));
  
  // Branch Adder
  branch_adder #(.WIDTH(WIDTH)) br_adder(.pc_in(pc_out), .imm(imm), .pc_out(branch_target));
  
  wire is_jal  = (instr[6:0]==7'b1101111);
  wire is_jalr = (instr[6:0]==7'b1100111);
  assign jump_target = is_jal  ? (pc_plus4 + imm)
                     : is_jalr ? ((read_data1 + imm) & ~32'b1)
                               : {WIDTH{1'b0}};
  
  //3 way PC select Mux
  PC_mux #(.WIDTH(WIDTH)) pxmux1(.JUMP(Jump), .pc_sel(take_branch), .pc_p4(pc_plus4),
    .branch_target (branch_target),
    .jump_target(jump_target),
    .pc_next(next_pc));
  
  //Instruction Memory
  instruction_memory #(.WIDTH(WIDTH)) imem(.addr(pc_out), .instr(instr));
  
  //Immediate Generation
  immediate_generator #(.WIDTH(WIDTH)) immgen(.instr(instr), .imm_out(imm));
  
  BranchComparator bc (.op1(read_data1), .op2(read_data2), .funct3(instr[14:12]), .branch_taken(branch_cond));
  
  //Register File 
  register_file #(.WIDTH(WIDTH)) rf (.clk(clk), .RegWrite(RegWrite), .rs1(instr[19:15]), .rs2(instr[24:20]),.rd(instr[11:7]),.write_data(write_back_data), .read_data1(read_data1),.read_data2 (read_data2));
  
  //ALU Controller
  ALUController ac (.ALUop (ALUop),.funct3(instr[14:12]),.funct7(instr[31:25]), .alu_control(alu_control));
  
  ALUOperMux muxB (.read_data2(read_data2), .imm(imm), .ALUSrc(ALUSrc), .alu_b(alu_b));
  
  ALU #(.WIDTH(WIDTH)) alu1 (.a(read_data1), .b(alu_b), .alu_control(alu_control), .result(alu_result), .zero(zero));
  
  WriteBackMux wb_mux (.alu_result(alu_result), .mem_read_data(mem_read_data), .MemToReg(MemToReg), .write_data(write_back_data));
  
  assign instr_out = instr;

endmodule
