// hazard.v

/* This module determines if pipeline stalls or flushing is required
* ifid_flush : flush the ifid stage pipeline regs
* ifid_bubble : stall the ifid stage pipeline regs
* idex_bubble : flush the idex stage pipeline regs
* exmem_bubble : flush the exmem stage pipeline regs
*/

// pcwrite
//  00 : pc+4        - branch x taken
//  01 : pc          - stall
//  10 : branch      - branch taken

module hazard (
  input clk,
  input [4:0] rs1,
  input [4:0] rs2,
  
  // stall signal, data flow hazard
  input idex_memread,        // Inst(ex) = load?
  input [4:0] idex_rd,       // Inst(ex) addr 

  // flush signal, control flow hazard
  input exmem_taken,         // branch taken -> flush

  output reg [1:0] pcwrite,  // for 
  output reg ifid_bubble,    // stall

  output reg ifid_flush,     // flush IF/ID pipeline register
  output reg idex_bubble,     // flush ID/EX pipeline register
  output reg exmem_bubble   // fluish EX/MEM pipeline register
);

wire stall_condition;
assign stall_condition = ((rs1 == idex_rd) || (rs2 == idex_rd)) && idex_memread;

always @(negedge clk) begin

  if (exmem_taken) begin
    // control flow hazard overwrites data flow hazard
    pcwrite <= 2'b10;
    ifid_flush <= 1;
    idex_bubble <= 1;
    exmem_bubble <= 1;
    ifid_bubble <= 0;
  end
  else begin
    ifid_flush <= 0;
    exmem_bubble <= 0;
    if (stall_condition) begin
      pcwrite <= 2'b01;
      ifid_bubble <= 1;
      idex_bubble <= 1;
    end
    else begin
      pcwrite <= 2'b00;
      ifid_bubble <= 0;
      idex_bubble <= 0;
    end
  end
end

endmodule

