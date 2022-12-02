// register_file.v
// this models 32, 32-bit registers

module register_file #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 5
)(
  input clk, 
  input  [ADDR_WIDTH-1:0] readreg1, readreg2, writereg,
  input  [DATA_WIDTH-1:0] writedata,
  input wen, 

  output [DATA_WIDTH-1:0] readdata1,
  output [DATA_WIDTH-1:0] readdata2
);

  // memory array
  reg [DATA_WIDTH-1:0] reg_array[0:2**ADDR_WIDTH-1];
  initial $readmemh("data/register.mem", reg_array); 

  // update regfile at the falling edge
  always @(negedge clk) begin 
    if (wen == 1'b1 && writereg!=0 ) reg_array[writereg] <= writedata;
    reg_array[0] <= 0; // x0 is always zero in RISC-V
  end

  assign readdata1 = reg_array[readreg1];
  assign readdata2 = reg_array[readreg2];

endmodule
