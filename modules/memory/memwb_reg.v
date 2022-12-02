// memwb_reg.v

/* This module is the MEM/WB stage pipeline registers.
*  It takes MEM stage outputs and passes to the WB stage
*/


module memwb_reg #(
  parameter DATA_WIDTH = 32
)(
  input clk,

  //////////////////////////////////////
  // output of mem stage
  //////////////////////////////////////
  input [DATA_WIDTH-1:0] mem_pc_plus_4,

  // wb control
  input [1:0] mem_toreg,
  input mem_regwrite,
  
  input [DATA_WIDTH-1:0] mem_readdata,
  input [DATA_WIDTH-1:0] mem_alu_result,
  input [4:0] mem_rd,
  
  //////////////////////////////////////
  // input to wb stage
  //////////////////////////////////////
  output reg [DATA_WIDTH-1:0] wb_pc_plus_4,

  // wb control
  output reg [1:0] wb_toreg,
  output reg wb_regwrite,
  
  output reg [DATA_WIDTH-1:0] wb_readdata,
  output reg [DATA_WIDTH-1:0] wb_alu_result,
  output reg [4:0] wb_rd
);

//////////////////////////////////////////////////////////////
// Write your code here
//////////////////////////////////////////////////////////////

always @(posedge clk) begin
  wb_pc_plus_4 <= mem_pc_plus_4;
  
  wb_toreg <= mem_toreg;
  wb_regwrite <= mem_regwrite;

  wb_readdata <= mem_readdata;
  wb_alu_result <= mem_alu_result;
  wb_rd <=mem_rd;
end

//////////////////////////////////////////////////////////////

endmodule


