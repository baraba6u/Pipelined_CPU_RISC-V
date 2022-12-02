// adder.v

// a simple adder

module adder #(
  parameter DATA_WIDTH = 32
)(
  input [DATA_WIDTH-1:0] inputx,
  input [DATA_WIDTH-1:0] inputy,

  output reg [DATA_WIDTH-1:0] result
);

always @(*) begin
  result = inputx + inputy;
end

endmodule
