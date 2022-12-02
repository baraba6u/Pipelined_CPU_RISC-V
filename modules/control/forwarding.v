// forwarding.v

/* This module determines if values from EX/MEM, MEM/WB stages needs to be
* forwarded to the current EX stage
*/

// forwarding signal
// - 00 : from ID/EX      , distance = 3 or no RAW dependency
// - 01 : from EX/MEM     , distance = 1
// - 10 : from MEM/WB mux , distance = 2

module forwarding (
  input clk,
  input [4:0] rs1, //idex_rs1
  input [4:0] rs2, //idex_rs2
  input [4:0] exmemrd,
  input exmemrw, //register wb signal
  input [4:0] memwbrd,
  input memwbrw, //register wb signal 

  output reg [1:0] forwardA,
  output reg [1:0] forwardB
);


always @(negedge clk) begin // forwardA
  if ((rs1 != 0) && (rs1 == exmemrd) && exmemrw) forwardA <= 2'b01;
  else if((rs1 != 0) && (rs1 == memwbrd) && memwbrw) forwardA <= 2'b10;
  else forwardA <= 2'b00;
end

always @(negedge clk) begin // forwardB
  if ((rs2 != 0) && (rs2 == exmemrd) && exmemrw) forwardB <= 2'b01;
  else if((rs2 != 0) && (rs2 == memwbrd) && memwbrw) forwardB <= 2'b10;
  else forwardB <= 2'b00;
end


endmodule

