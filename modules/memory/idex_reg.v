// idex_reg.v

/* This module is the ID/EX stage pipeline registers.
*  It takes ID stage outputs and passes to the EX stage
*/

module idex_reg #(
  parameter DATA_WIDTH = 32
)(
  input clk,
  input idex_bubble, // if 1 flush

  //////////////////////////////////////
  // output of id stage
  //////////////////////////////////////
  input [DATA_WIDTH-1:0] id_PC,
  input [DATA_WIDTH-1:0] id_pc_plus_4,

  // ex control
  input id_branch,
  input id_add,
  input id_immediate,
  input [1:0] id_alusrc1,
  input [1:0] id_jump,

  // mem control
  input id_memread,
  input id_memwrite,

  // wb control
  input [1:0] id_toreg,
  input id_regwrite,

  input [DATA_WIDTH-1:0] id_sextimm,
  input [6:0] id_funct7,
  input [2:0] id_funct3,
  input [DATA_WIDTH-1:0] id_readdata1,
  input [DATA_WIDTH-1:0] id_readdata2,
  input [4:0] id_rs1,
  input [4:0] id_rs2,
  input [4:0] id_rd,

  //////////////////////////////////////
  // input to ex stage
  //////////////////////////////////////
  output reg [DATA_WIDTH-1:0] ex_PC,
  output reg [DATA_WIDTH-1:0] ex_pc_plus_4,

  // ex control
  output reg ex_branch,
  output reg ex_add,
  output reg ex_immediate,
  output reg [1:0] ex_alusrc1,
  output reg [1:0] ex_jump,

  // mem control
  output reg ex_memread,
  output reg ex_memwrite,

  // wb control
  output reg [1:0] ex_toreg,
  output reg ex_regwrite,

  output reg [DATA_WIDTH-1:0] ex_sextimm,
  output reg [6:0] ex_funct7,
  output reg [2:0] ex_funct3,
  output reg [DATA_WIDTH-1:0] ex_readdata1,
  output reg [DATA_WIDTH-1:0] ex_readdata2,
  output reg [4:0] ex_rs1,
  output reg [4:0] ex_rs2,
  output reg [4:0] ex_rd
);

//////////////////////////////////////////////////////////////
// Write your code here
//////////////////////////////////////////////////////////////

always @(posedge clk) begin
  if (idex_bubble) begin
    ex_PC <= 0;
    ex_pc_plus_4 <= 0;

    ex_branch <= 0;
    ex_add <=0;
    ex_immediate <= 0;
    ex_alusrc1 <= 0;
    ex_jump <= 0;

    ex_memread <= 0;
    ex_memwrite <= 0;

    ex_toreg <= 0;
    ex_regwrite <= 0;

    ex_sextimm <= 0;
    ex_funct7 <= 0;
    ex_funct3 <= 0;
    ex_readdata1 <= 0;
    ex_readdata2 <= 0;
    ex_rs1 <= 0;
    ex_rs2 <= 0;
    ex_rd <= 0;
  end
  else begin
    ex_PC <= id_PC;
    ex_pc_plus_4 <= id_pc_plus_4;

    ex_branch <= id_branch;
    ex_add <= id_add;
    ex_immediate <= id_immediate;
    ex_alusrc1 <= id_alusrc1;
    ex_jump <= id_jump;

    ex_memread <= id_memread;
    ex_memwrite <= id_memwrite;

    ex_toreg <= id_toreg;
    ex_regwrite <= id_regwrite;

    ex_sextimm <= id_sextimm;
    ex_funct7 <= id_funct7;
    ex_funct3 <= id_funct3;
    ex_readdata1 <= id_readdata1;
    ex_readdata2 <= id_readdata2;
    ex_rs1 <= id_rs1;
    ex_rs2 <= id_rs2;
    ex_rd <= id_rd;
  end
end

//////////////////////////////////////////////////////////////

endmodule


