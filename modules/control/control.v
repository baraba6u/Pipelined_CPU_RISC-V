// control.v

// The main control module takes as input the opcode field of an instruction
// (i.e., instruction[6:0]) and generates a set of control signals.

// branch
//  - 1 : B-type
//  - 0 : else

// toreg
//  - register wb source
//  - 0 : alu
//  - 1 : mem
//  - 2 : PC + 4

// alusrc1
//  - inputx of alu
//  - 0 : from register output or bypassing logic
//  - 1 : 0
//  - 2 : PC

// add 
//  - alu control
//  - when set, the alu operation is add no matter what

// immediate 
//  - alu control
//  - set if the instruction has a immediate field (e.g. I-type instructions)

// jump
// - 00 : else
// - 01 : jal
// - 11 : jalr

module control(
  input [6:0] opcode,

  output branch,
  output memread,
  output[1:0] toreg,
  output add,
  output memwrite,
  output regwrite,
  output immediate,
  output[1:0] alusrc1,
  output[1:0] jump
);

reg [11:0] controls;

// combinational logic
always @(*) begin
  case (opcode)

    // R-type
    7'b0110011: controls = 12'b00_00_0010_00_00;
    // I-type immediate
    7'b0010011: controls = 12'b00_00_0011_00_00;
    // I-type load
    7'b0000011: controls = 12'b01_01_1011_00_00;
    // S-type store
    7'b0100011: controls = 12'b00_xx_1101_00_00;
    // B-type conditional branch
    7'b1100011: controls = 12'b10_xx_x001_xx_00;
    // J-type jal
    7'b1101111: controls = 12'b00_10_x011_xx_01;
    // I-type jalr
    7'b1100111: controls = 12'b00_10_1011_00_11;
    
    default:    controls = 12'b00_00_0000_00_00;
  endcase
end

assign {branch, memread, toreg, add, memwrite, regwrite, immediate, alusrc1, jump} = controls;

endmodule
