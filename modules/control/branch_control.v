// branch_control.v

/* This unit generates branch T/NT signal based on
* branch, funct3, inputx, inputy
*/

module branch_control
#(parameter DATA_WIDTH = 32)
(
  input branch,
  input [2:0] funct3,
  input [DATA_WIDTH-1:0] inputx,
  input [DATA_WIDTH-1:0] inputy,

  output reg taken 
);


always @(*) begin
  if (branch) begin
    case (funct3)
      3'b000: taken = (inputx == inputy)? 1: 0;
      3'b001: taken = (inputx != inputy)? 1: 0;
      3'b100: taken = ($signed(inputx) < $signed(inputy))? 1: 0;
      3'b101: taken = ($signed(inputx) >= $signed(inputy))? 1: 0;
      3'b110: taken = ($unsigned(inputx) < $unsigned(inputy))? 1: 0;
      3'b111: taken = ($unsigned(inputx) >= $unsigned(inputy))? 1: 0;
      default: taken = 0;
    endcase
  end
  else begin
    taken = 0;
  end
end


endmodule
