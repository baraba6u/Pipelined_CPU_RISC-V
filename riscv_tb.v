`timescale 1 ns/10 ps

module riscv_tb;

reg clk, rstn;
wire [31:0] inst;

integer i;

initial begin
  clk  = 1'b0;
  rstn = 1'b0;
  $display($time, " ** Start Simulation **");
  $display($time, " Instruction Memory ");
  $monitor($time, " [PC] pc : %d", my_cpu.PC);
  #60 rstn = 1'b1;
  #5000; 
  rstn = 1'b0;
  $display($time, " ** End Simulation **");
  
  ////////////////////////////////////////////////////////
  // [WARNING] : DO NOT ERASE when using "test.py"
  ////////////////////////////////////////////////////////
  $display($time, " REGISTER FILE");
  for (i=0;i<32;i=i+1) $display($time, " Reg[%d]: %d (%b)", i, $signed(my_cpu.m_register_file.reg_array[i]), my_cpu.m_register_file.reg_array[i]);
  $display($time, " DATA MEMORY");
  for (i=0;i<128;i=i+1) $display($time, " Mem[%d]: %d (%b)", i, $signed(my_cpu.m_data_memory.mem_array[i]), my_cpu.m_data_memory.mem_array[i]);
  ////////////////////////////////////////////////////////

  $finish;
end

always begin
  // remember that the cycle time was 20 in the single cycle implementation?
  // pipelining increases clock frequency!!
  #5 clk = ~clk;
end

// dump the state of the design
// VCD (Value Change Dump) is a standard dump format defined in Verilog.
initial begin
  $dumpfile("sim.vcd");
  $dumpvars(0, riscv_tb);
end

simple_cpu my_cpu(.clk(clk), .rstn(rstn));

endmodule
