// ifid_reg.v

/* This module is the IF/ID stage pipeline registers.
*  It takes IF stage outputs and passes to the ID stage
*/

module ifid_reg #(
  parameter DATA_WIDTH = 32
)(
  input clk,
  input ifid_flush,  // if 1 flush
  input ifid_bubble, // if 1 stall

  //////////////////////////////////////
  // output of if stage
  //////////////////////////////////////
  input [DATA_WIDTH-1:0] if_PC,
  input [DATA_WIDTH-1:0] if_pc_plus_4,
  input [DATA_WIDTH-1:0] if_instruction,

  //////////////////////////////////////
  // input to id stage
  //////////////////////////////////////
  output reg [DATA_WIDTH-1:0] id_PC,
  output reg [DATA_WIDTH-1:0] id_pc_plus_4,
  output reg [DATA_WIDTH-1:0] id_instruction
);

//////////////////////////////////////////////////////////////
// Write your code here
//////////////////////////////////////////////////////////////

always @(posedge clk) begin
  if (!ifid_bubble) begin
    if (ifid_flush) begin
      id_PC <= 0;
      id_pc_plus_4 <= 0;
      id_instruction <= 0;
    end
    else begin
      id_PC <= if_PC;
      id_pc_plus_4 <= if_pc_plus_4;
      id_instruction <= if_instruction; 
    end
  end

end

//////////////////////////////////////////////////////////////

endmodule


