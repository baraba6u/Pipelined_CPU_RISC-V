// instruction_memory.v

/* This module is the instruction memory */

module instruction_memory
#(parameter DATA_WIDTH = 32)(
  input [DATA_WIDTH-1:0] address,

  output reg [DATA_WIDTH-1:0] instruction
);

localparam NUM_INSTS = 64;

reg[DATA_WIDTH-1:0] inst_memory[0:NUM_INSTS-1];
initial $readmemb("data/inst.mem", inst_memory);

always @(*) begin
  instruction = inst_memory[address[7:2]];
end


endmodule
