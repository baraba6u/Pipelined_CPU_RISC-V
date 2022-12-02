all: simple_cpu

MODULES = modules/control/alu_control.v 						\
					modules/control/branch_control.v					\
					modules/control/control.v									\
					modules/control/forwarding.v							\
					modules/control/hazard.v									\
					modules/memory/data_memory.v							\
					modules/memory/exmem_reg.v								\
					modules/memory/idex_reg.v									\
					modules/memory/ifid_reg.v									\
					modules/memory/instruction_memory.v				\
					modules/memory/memwb_reg.v								\
					modules/memory/register_file.v						\
					modules/operation/adder.v									\
					modules/operation/alu.v										\
					modules/operation/immediate_generator.v		\
					modules/utils/defines.v										\
					modules/utils/mux_2x1.v										\
					modules/utils/mux_3x1.v										\
					modules/utils/mux_4x1.v										

SOURCES = ./riscv_tb.v ./simple_cpu.v 

simple_cpu: $(MODULES) $(SOURCES)
	iverilog -I modules/ -s riscv_tb -o $@ $^

clean:
	rm -f simple_cpu *.vcd
