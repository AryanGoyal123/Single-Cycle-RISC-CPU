//PC + 4 Module
module pc_adder #(parameter WIDTH = 32)(
  input wire [WIDTH-1:0] pc_in,
  output wire [WIDTH-1:0] pc_out
);  
  assign pc_out = pc_in + 4;
endmodule

//PC Adder for Target Branch
module branch_adder #(parameter WIDTH = 32)(
  input wire [WIDTH-1:0] pc_in,
  input wire [WIDTH-1:0] imm,
  output wire [WIDTH-1:0] pc_out
);
  assign pc_out = pc_in + imm;
endmodule

// 2x1 Mux for PC Select
module pc_mux #(parameter WIDTH = 32)(
  input wire pc_sel,
  input wire [WIDTH-1:0] pc_p4,
  input wire [WIDTH-1:0] branch_target,
  output wire [WIDTH-1:0] pc_next
);
  assign pc_next = pc_sel ? branch_target : pc_p4;
endmodule
