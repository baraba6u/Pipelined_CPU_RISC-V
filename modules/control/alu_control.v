// alu_control.v


/* This unit generates a 4-bit ALU control input (operation)
 * based on add, immediate, funct7, and funct3 field.
 */


`include "modules/utils/defines.v" // change back to this
//`include "../utils/defines.v"   // change later. just for vivado simulation

module alu_control(
  input add,
  input immediate,
  input wire [6:0] funct7,
  input wire [2:0] funct3,

  output reg [3:0] operation
);

wire [3:0] funct;
wire [1:0] alu_op;

assign funct = {funct7[5], funct3};
assign alu_op = {immediate, add};

always @(*) begin
  case (alu_op)
    2'b00: begin // R-type
      case (funct)
        4'b0_000: operation = `OP_ADD;
        4'b1_000: operation = `OP_SUB;
        4'b0_100: operation = `OP_XOR;
        4'b0_110: operation = `OP_OR;
        4'b0_111: operation = `OP_AND;
        4'b0_001: operation = `OP_SLL;
        4'b0_101: operation = `OP_SRL;
        4'b1_101: operation = `OP_SRA;
        4'b0_010: operation = `OP_SLT;
        4'b0_011: operation = `OP_SLTU;
        default:  operation = `OP_EEE;
      endcase
    end
    2'b10: begin // I-type immediate arithmetic
      case (funct3)
        3'b000: operation = `OP_ADD;
        3'b100: operation = `OP_XOR;
        3'b110: operation = `OP_OR;
        3'b111: operation = `OP_AND;
        3'b001: operation = `OP_SLL;
        3'b101: begin
          if (funct7[5]) operation = `OP_SRA;
          else           operation = `OP_SRL;
        end
        3'b010: operation = `OP_SLT;
        3'b011: operation = `OP_SLTU;
      endcase
    end
    2'b01: begin // Should not fall here
      operation = `OP_EEE;
    end
    2'b11: begin // load, store, jalr
      operation = `OP_ADD;
    end
  endcase
end


endmodule
