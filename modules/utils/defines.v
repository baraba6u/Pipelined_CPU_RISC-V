`ifndef __defines_vh__
`define __defines_vh__

// ALU function
`define OP_ADD  4'b0000
`define OP_SUB  4'b0001
`define OP_XOR  4'b0010
`define OP_OR   4'b0011
`define OP_AND  4'b0100
`define OP_SLL  4'b0101
`define OP_SRL  4'b0110
`define OP_SRA  4'b0111
`define OP_SLT  4'b1000
`define OP_SLTU 4'b1001

`define OP_EEE  4'b1111   // error

`endif // __defines_vh__
