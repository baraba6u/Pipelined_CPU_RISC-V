set MODULES=modules/operation/alu.v modules/control/ALU_control.v modules/utils/defines.v modules/memory/register_file.v modules/control/control.v modules/memory/data_memory.v modules/utils/mux_2x1.v modules/utils/mux_4x1.v modules/operation/immediate_generator.v modules/control/branch_control.v modules/operation/adder.v modules/memory/ifid_reg.v modules/memory/idex_reg.v modules/memory/exmem_reg.v modules/memory/memwb_reg.v modules/utils/mux_3x1.v modules/control/hazard.v modules/control/forwarding.v modules/memory/instruction_memory.v

set SOURCES=riscv_tb.v simple_cpu.v

iverilog -I modules -s riscv_tb -o simple_cpu %MODULES% %SOURCES%
