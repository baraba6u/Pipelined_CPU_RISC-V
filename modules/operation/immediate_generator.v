// immediate_generator.v

module immediate_generator #(
  parameter DATA_WIDTH = 32
)(
  input [DATA_WIDTH-1:0] instruction,

  output reg [DATA_WIDTH-1:0] sextimm
);

wire [6:0] opcode;
assign opcode = instruction[6:0];

always @(*) begin
  case (opcode)
    // I-type
    7'b0010011: sextimm = { {20{instruction[31]}}, instruction[31:20] };

    // Load
    7'b0000011: sextimm = { {20{instruction[31]}}, instruction[31:20] };

    // Store
    7'b0100011: sextimm = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };

    // Branch
    7'b1100011: sextimm = { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], {1'b0} };

    // JAL
    7'b1101111: sextimm = { {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], {1'b0} }; 

    // JALR
    7'b1100111: sextimm = { {20{instruction[31]}}, instruction[31:20] }; 
    default:    sextimm = 32'h0000_0000;
  endcase
end


endmodule
