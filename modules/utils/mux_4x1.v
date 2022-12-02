// mux_4x1.v

module mux_4x1
#(parameter DATA_WIDTH = 32)(
  input [1:0] select,
  input [DATA_WIDTH-1:0] in1,
  input [DATA_WIDTH-1:0] in2,
  input [DATA_WIDTH-1:0] in3,
  input [DATA_WIDTH-1:0] in4,
  
  output reg [DATA_WIDTH-1:0] out
);

// combinational logic
always @ (*) begin
  case(select)
    2'b00: out = in1;
    2'b01: out = in2;
    2'b10: out = in3;
    2'b11: out = in4;
    default: out = 32'h0000_0000; // should never fall here
  endcase
end

endmodule
