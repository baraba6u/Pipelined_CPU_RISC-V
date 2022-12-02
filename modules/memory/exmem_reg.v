//exmem_reg.v

/* This module is the EX/MEM stage pipeline registers.
*  It takes EX stage outputs and passes to the MEM stage
*/

module exmem_reg #(
  parameter DATA_WIDTH = 32
)(
  input clk,
  input exmem_bubble,

  //////////////////////////////////////
  // output of ex stage
  //////////////////////////////////////
  input [DATA_WIDTH-1:0] ex_pc_plus_4,
  input [DATA_WIDTH-1:0] ex_pc_target,
  input ex_taken,

  // mem control
  input ex_memread,
  input ex_memwrite,

  // wb control
  input [1:0] ex_toreg,
  input ex_regwrite,
  
  input [DATA_WIDTH-1:0] ex_alu_result,
  input [DATA_WIDTH-1:0] ex_writedata,
  input [2:0] ex_funct3,
  input [4:0] ex_rd,
  
  //////////////////////////////////////
  // input to mem stage
  //////////////////////////////////////
  output reg [DATA_WIDTH-1:0] mem_pc_plus_4,
  output reg [DATA_WIDTH-1:0] mem_pc_target,
  output reg mem_taken,

  // mem control
  output reg mem_memread,
  output reg mem_memwrite,

  // wb control
  output reg [1:0] mem_toreg,
  output reg mem_regwrite,
  
  output reg [DATA_WIDTH-1:0] mem_alu_result,
  output reg [DATA_WIDTH-1:0] mem_writedata,
  output reg [2:0] mem_funct3,
  output reg [4:0] mem_rd
);

//////////////////////////////////////////////////////////////
// Write your code here
//////////////////////////////////////////////////////////////

always @(posedge clk) begin
  if (exmem_bubble) begin
    mem_pc_plus_4 <= 0;
    mem_pc_target <= 0;
    mem_taken <= 0;

    mem_memread <= 0;
    mem_memwrite <= 0;

    mem_toreg <= 0;
    mem_regwrite <= 0;

    mem_alu_result <= 0;
    mem_writedata <= 0;
    mem_funct3 <= 0;
    mem_rd <= 0;
  end
  else begin
    mem_pc_plus_4 <= ex_pc_plus_4;
    mem_pc_target <= ex_pc_target;
    mem_taken <= ex_taken;

    mem_memread <= ex_memread;
    mem_memwrite <= ex_memwrite;

    mem_toreg <= ex_toreg;
    mem_regwrite <= ex_regwrite;

    mem_alu_result <= ex_alu_result;
    mem_writedata <= ex_writedata;
    mem_funct3 <= ex_funct3;
    mem_rd <= ex_rd;
  end
end

//////////////////////////////////////////////////////////////


endmodule


