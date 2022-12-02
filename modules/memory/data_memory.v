// data_memory.v

module data_memory #(
  parameter DATA_WIDTH = 32, MEM_ADDR_SIZE = 8
)(
  input  clk,
  input  [DATA_WIDTH-1:0] address,
  input  [DATA_WIDTH-1:0] writedata,
  input  memread,
  input  memwrite,
  input  [1:0] maskmode,
  input  sext,

  output reg [DATA_WIDTH-1:0] readdata
);

  // memory
  reg [DATA_WIDTH-1:0] mem_array [0:2**MEM_ADDR_SIZE-1]; // change memory size
  initial $readmemh("data/data_memory.mem", mem_array);
  // wire reg for writedata
  wire [MEM_ADDR_SIZE-1:0] address_internal; // 256 = 8-bit address

  assign address_internal = address[MEM_ADDR_SIZE+1:2]; // 256 = 8-bit address

  // update at negative edge
  always @(negedge clk) begin 
    if (memwrite == 1'b1) begin
      case(maskmode)
        2'b00: mem_array[address_internal] <= writedata[7:0];
        2'b01: mem_array[address_internal] <= writedata[15:0];
        2'b10: mem_array[address_internal] <= writedata[31:0]; 
      endcase
    end
  end

  // combinational logic
  always @(*) begin
    if (memread == 1'b1) begin
      case (sext)
        1'b0: begin
          case (maskmode)
            2'b00: readdata = { {24{mem_array[address_internal][7]}}, mem_array[address_internal][7:0]};
            2'b01: readdata = { {16{mem_array[address_internal][15]}}, mem_array[address_internal][15:0]};
            2'b10: readdata = mem_array[address_internal];
            default: readdata = 32'h0000_0000;
          endcase
        end
        1'b1: begin // zero-extend
          case (maskmode)
            2'b00: readdata = { 24'h0000_00, mem_array[address_internal][7:0]};
            2'b01: readdata = { 16'h0000, mem_array[address_internal][15:0]};
            default: readdata = 32'h0000_0000;
          endcase
        end
      endcase
    end else begin
      readdata = 32'h0000_0000;
    end
  end

endmodule
