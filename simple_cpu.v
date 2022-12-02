// simple_cpu.v
// a pipelined RISC-V microarchitecture (RV32I)

///////////////////////////////////////////////////////////////////////////////////////////////////////
// [*] In simple_cpu.v you should connect the correct wires to the correct ports
//     - All modules are given so there is no need to add new modules
//     - However, you are still free to add simple modules like multiplexers,
//       adders, etc.
//
// [*] FYI : you should declare wires or registers before you use them like most
//           programming languages
///////////////////////////////////////////////////////////////////////////////////////////////////////
  
module simple_cpu
#(parameter DATA_WIDTH = 32)(
  input clk,
  input rstn
);

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Instruction Fetch (IF)
///////////////////////////////////////////////////////////////////////////////////////////////////////


// wire and register for program counter
reg [DATA_WIDTH-1:0] PC;
wire [DATA_WIDTH-1:0] next_pc;

// program counter
always @(posedge clk) begin
  if (rstn == 1'b0) begin
    PC <= 32'h00000000;
  end
  else PC <= next_pc;
end

// wire for pc+4
wire [DATA_WIDTH-1:0] ifid_in_pc_plus_4;

// pc+4
adder m_pc_plus_4_adder(
  .inputx(PC),
  .inputy(32'h0000_0004),

  .result(ifid_in_pc_plus_4)
);

// wire for 3x1 m_next_pc_mux
wire [DATA_WIDTH-1:0] exmem_out_mem_pc_target; // from EX/MEM pipeline register
wire [1:0] pcwrite; // from hazard detection unit

// 3x1 mux input for pc
mux_3x1 m_next_pc_mux(
  .select(pcwrite), 
  .in1(ifid_in_pc_plus_4),
  .in2(PC),
  .in3(exmem_out_mem_pc_target),

  .out(next_pc)
);

// wire for instruction memory
wire [DATA_WIDTH-1:0] ifid_in_instruction;

// instruction memory
instruction_memory m_instruction_memory(
  .address(PC),

  .instruction(ifid_in_instruction)
);

// wires for hazard detection unit
wire ifid_flush, ifid_bubble;
wire exmem_bubble, idex_bubble;
wire exmem_out_mem_taken; // from EX/MEM pipeline register

// wires for IF/ID pipeline register
wire [DATA_WIDTH-1:0] ifid_out_pc;
wire [DATA_WIDTH-1:0] ifid_out_pc_plus_4;
wire [DATA_WIDTH-1:0] ifid_out_instruction;

// IF/ID pipeline register
ifid_reg m_ifid_reg(
  .clk(clk),
  .ifid_flush(ifid_flush),
  .ifid_bubble(ifid_bubble),
  .if_PC(PC),
  .if_pc_plus_4(ifid_in_pc_plus_4),
  .if_instruction(ifid_in_instruction),

  .id_PC(ifid_out_pc),
  .id_pc_plus_4(ifid_out_pc_plus_4),
  .id_instruction(ifid_out_instruction)
);


///////////////////////////////////////////////////////////////////////////////////////////////////////
// Instruction Decode (ID)
///////////////////////////////////////////////////////////////////////////////////////////////////////

// hazard detection unit
hazard m_hazard(
  .clk(clk),
  .rs1(ifid_out_instruction[19:15]),
  .rs2(ifid_out_instruction[24:20]),
  .idex_memread(idex_out_ex_memread),
  .idex_rd(idex_out_ex_rd),
  .exmem_taken(exmem_out_mem_taken),
  
  .pcwrite(pcwrite),
  .ifid_flush(ifid_flush),
  .ifid_bubble(ifid_bubble),
  .exmem_bubble(exmem_bubble),
  .idex_bubble(idex_bubble)
);

// wires for control unit
wire [1:0] id_toreg, id_jump;
wire id_branch, id_memread, id_add, id_memwrite, id_regwrite, id_immediate;

// control unit
control m_control(
  .opcode(ifid_out_instruction[6:0]),

  .branch(id_branch),
  .memread(id_memread),
  .toreg(id_toreg),
  .add(id_add),
  .memwrite(id_memwrite),
  .regwrite(id_regwrite),
  .immediate(id_immediate),
  .jump(id_jump)
);

// wires for immediate generator
wire [DATA_WIDTH-1:0] id_sextimm;

// immediate generator
immediate_generator m_immediate_generator(
  .instruction(ifid_out_instruction),

  .sextimm(id_sextimm)
);

// wires for register
wire [DATA_WIDTH-1:0] id_readdata1, id_readdata2;
wire [4:0] memwb_out_wb_rd; // from MEM/WB pipeline register
wire memwb_out_wb_regwrite; // from MEM/WB pipeline register

// register file
register_file m_register_file(
  .clk(clk),
  .readreg1(ifid_out_instruction[19:15]),
  .readreg2(ifid_out_instruction[24:20]),
  .writereg(memwb_out_wb_rd),
  .wen(memwb_out_wb_regwrite),
  .writedata(wb_write_back_mux_out),

  .readdata1(id_readdata1),
  .readdata2(id_readdata2)
);

// wires for ID/EX pipeline register
wire [DATA_WIDTH-1:0] idex_out_ex_pc, idex_out_ex_pc_plus_4;
wire idex_out_ex_branch, idex_out_ex_add, idex_out_ex_immediate;
wire [1:0] idex_out_ex_jump;
wire idex_out_ex_memread, idex_out_ex_memwrite;
wire [1:0] idex_out_ex_toreg;
wire idex_out_ex_regwrite;
wire [DATA_WIDTH-1:0] idex_out_ex_sextimm, idex_out_ex_readdata1, idex_out_ex_readdata2;
wire [6:0] idex_out_ex_funct7;
wire [2:0] idex_out_ex_funct3;
wire [4:0] idex_out_ex_rs1, idex_out_ex_rs2, idex_out_ex_rd;

// ID/EX pipeline register
idex_reg m_idex_reg(
  .clk(clk),
  .idex_bubble(idex_bubble),
  .id_PC(ifid_out_pc),
  .id_pc_plus_4(ifid_out_pc_plus_4),
  .id_branch(id_branch),
  .id_add(id_add),
  .id_immediate(id_immediate),
  .id_jump(id_jump),
  .id_memread(id_memread),
  .id_memwrite(id_memwrite),
  .id_toreg(id_toreg),
  .id_regwrite(id_regwrite),
  .id_sextimm(id_sextimm),
  .id_funct7(ifid_out_instruction[31:25]),
  .id_funct3(ifid_out_instruction[14:12]),
  .id_readdata1(id_readdata1),
  .id_readdata2(id_readdata2),
  .id_rs1(ifid_out_instruction[19:15]),
  .id_rs2(ifid_out_instruction[24:20]),
  .id_rd(ifid_out_instruction[11:7]),

  .ex_PC(idex_out_ex_pc),
  .ex_pc_plus_4(idex_out_ex_pc_plus_4),
  .ex_branch(idex_out_ex_branch),
  .ex_add(idex_out_ex_add),
  .ex_immediate(idex_out_ex_immediate),
  .ex_jump(idex_out_ex_jump),
  .ex_memread(idex_out_ex_memread),
  .ex_memwrite(idex_out_ex_memwrite),
  .ex_toreg(idex_out_ex_toreg),
  .ex_regwrite(idex_out_ex_regwrite),
  .ex_sextimm(idex_out_ex_sextimm),
  .ex_funct7(idex_out_ex_funct7),
  .ex_funct3(idex_out_ex_funct3),
  .ex_readdata1(idex_out_ex_readdata1),
  .ex_readdata2(idex_out_ex_readdata2),
  .ex_rs1(idex_out_ex_rs1),
  .ex_rs2(idex_out_ex_rs2),
  .ex_rd(idex_out_ex_rd)
);


///////////////////////////////////////////////////////////////////////////////////////////////////////
// Execute (EX) 
///////////////////////////////////////////////////////////////////////////////////////////////////////

// wire for branch target addr
wire [DATA_WIDTH-1:0] ex_pc_plus_immediate;

// branch target adder, generates pc+imm
adder m_branch_target_adder(
  .inputx(idex_out_ex_pc),
  .inputy(idex_out_ex_sextimm),

  .result(ex_pc_plus_immediate)
);

// wires for branch control unit
wire ex_branch_taken;
wire [DATA_WIDTH-1:0] ex_rs1_mux_out, ex_rs2_mux_out;

// branch control unit
branch_control m_branch_control(
  .branch(idex_out_ex_branch),
  .funct3(idex_out_ex_funct3),
  .inputx(ex_rs1_mux_out),
  .inputy(ex_rs2_mux_out),
  
  .taken(ex_branch_taken)
);

// taken signal for both branch taken + jal/jalr jump
wire ex_branch_taken_and_jump = ex_branch_taken || idex_out_ex_jump[0];

// wires for ALU
wire [DATA_WIDTH-1:0] ex_alu_result;

// wire for m_targetPC_mux
wire [DATA_WIDTH-1:0] ex_target_pc;

// 2x1 mux for target pc
// between pc+imm (branch & jal) & rs1+imm (jalr)
mux_2x1 m_targetPC_mux(
  .select(idex_out_ex_jump[1]),
  .in1(ex_pc_plus_immediate), // pc+imm  (branch & jal)
  .in2(ex_alu_result), // rs1+imm (jalr)

  .out(ex_target_pc) // to next_pc_mux
);

// wire for ALU control
wire [3:0] ex_alu_operation;

// ALU control unit
alu_control m_alu_control(
  .add(idex_out_ex_add),
  .immediate(idex_out_ex_immediate),
  .funct7(idex_out_ex_funct7),
  .funct3(idex_out_ex_funct3),

  .operation(ex_alu_operation)
);

// wires for forwarding unit
wire [1:0] forwardA, forwardB;

// wires for 2 3x1 mux
wire [DATA_WIDTH-1:0] exmem_out_mem_alu_result;  // from EX/MEM pipeline register
wire [DATA_WIDTH-1:0] wb_write_back_mux_out; // from 3x1 write_back_mux

// 3x1 mux for rs1 data - data forwarding
mux_3x1 m_rs1_mux(
  .select(forwardA), 
  .in1(idex_out_ex_readdata1),
  .in2(exmem_out_mem_alu_result),
  .in3(wb_write_back_mux_out),

  .out(ex_rs1_mux_out)
);

// 3x1 mux for rs2 data - data forwarding
mux_3x1 m_rs2_mux(
  .select(forwardB),
  .in1(idex_out_ex_readdata2),
  .in2(exmem_out_mem_alu_result),
  .in3(wb_write_back_mux_out),

  .out(ex_rs2_mux_out)
);

// wires for ALU inputs
wire [DATA_WIDTH-1:0] ex_alu_input2;

// 2x1 mux for ALU inputy
mux_2x1 m_alu_src2_mux(
  .select(idex_out_ex_immediate),
  .in1(ex_rs2_mux_out),
  .in2(idex_out_ex_sextimm),

  .out(ex_alu_input2)
);

// ALU
alu m_alu(
  .operation(ex_alu_operation),
  .inputx(ex_rs1_mux_out), 
  .inputy(ex_alu_input2), 

  .result(ex_alu_result)
);

// wires for forwarding unit
wire [4:0] exmem_out_mem_rd;
wire exmem_out_mem_regwrite;

// forwarding unit
forwarding m_forwarding(
  .clk(clk),
  .rs1(idex_out_ex_rs1),
  .rs2(idex_out_ex_rs2),
  .exmemrd(exmem_out_mem_rd),
  .exmemrw(exmem_out_mem_regwrite),
  .memwbrd(memwb_out_wb_rd),
  .memwbrw(memwb_out_wb_regwrite),

  .forwardA(forwardA),
  .forwardB(forwardB)
);

// wires for EX/MEM pipeline register
wire [DATA_WIDTH-1:0] exmem_out_mem_pc_plus_4, exmem_out_mem_writedata;
wire exmem_out_mem_memread, exmem_out_mem_memwrite;
wire [1:0] exmem_out_mem_toreg;
wire [2:0] exmem_out_mem_funct3;

// EX/MEM pipeline register
exmem_reg m_exmem_reg(
  .clk(clk),
  .exmem_bubble(exmem_bubble),
  .ex_pc_plus_4(idex_out_ex_pc_plus_4),
  .ex_pc_target(ex_target_pc),
  .ex_taken(ex_branch_taken_and_jump), 
  .ex_memread(idex_out_ex_memread),
  .ex_memwrite(idex_out_ex_memwrite),
  .ex_toreg(idex_out_ex_toreg),
  .ex_regwrite(idex_out_ex_regwrite),
  .ex_alu_result(ex_alu_result),
  .ex_writedata(ex_rs2_mux_out),
  .ex_funct3(idex_out_ex_funct3),
  .ex_rd(idex_out_ex_rd),
  
  .mem_pc_plus_4(exmem_out_mem_pc_plus_4),
  .mem_pc_target(exmem_out_mem_pc_target),
  .mem_taken(exmem_out_mem_taken), 
  .mem_memread(exmem_out_mem_memread),
  .mem_memwrite(exmem_out_mem_memwrite),
  .mem_toreg(exmem_out_mem_toreg),
  .mem_regwrite(exmem_out_mem_regwrite),
  .mem_alu_result(exmem_out_mem_alu_result),
  .mem_writedata(exmem_out_mem_writedata),
  .mem_funct3(exmem_out_mem_funct3),
  .mem_rd(exmem_out_mem_rd)
);


////////////////////////////////////////////////////
// Memory (MEM) 
////////////////////////////////////////////////////

// wire for main memory
wire [DATA_WIDTH-1:0] mem_readdata;

// main memory
data_memory m_data_memory(
  .clk(clk),
  .address(exmem_out_mem_alu_result),
  .writedata(exmem_out_mem_writedata), 
  .memread(exmem_out_mem_memread),
  .memwrite(exmem_out_mem_memwrite),
  .maskmode(exmem_out_mem_funct3[1:0]),
  .sext(exmem_out_mem_funct3[2]),

  .readdata(mem_readdata)
);

// wires for MEM/WB pipeline register
wire [DATA_WIDTH-1:0] memwb_out_wb_pc_plus_4, memwb_out_wb_readdata, memwb_out_wb_alu_result;
wire [1:0] memwb_out_wb_toreg;

// MEM/WB pipeline register
memwb_reg m_memwb_reg(
  .clk(clk),
  .mem_pc_plus_4(exmem_out_mem_pc_plus_4),
  .mem_toreg(exmem_out_mem_toreg),
  .mem_regwrite(exmem_out_mem_regwrite),
  .mem_readdata(mem_readdata),
  .mem_alu_result(exmem_out_mem_alu_result),
  .mem_rd(exmem_out_mem_rd),

  .wb_pc_plus_4(memwb_out_wb_pc_plus_4),
  .wb_toreg(memwb_out_wb_toreg),
  .wb_regwrite(memwb_out_wb_regwrite),
  .wb_readdata(memwb_out_wb_readdata),
  .wb_alu_result(memwb_out_wb_alu_result),
  .wb_rd(memwb_out_wb_rd)
);

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Write Back (WB) 
///////////////////////////////////////////////////////////////////////////////////////////////////////

/* m_write_back_mux: selects what to write back */
mux_3x1 m_write_back_mux(
  .select(memwb_out_wb_toreg),
  .in1(memwb_out_wb_alu_result), // alu
  .in2(memwb_out_wb_readdata), // mem
  .in3(memwb_out_wb_pc_plus_4), // pc+4

  .out(wb_write_back_mux_out)
);


endmodule
