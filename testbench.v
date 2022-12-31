`timescale 1ns / 1ns

module tb;
parameter SIZE = 14, DEPTH = 1024;

reg clk;
initial begin
  clk = 1;
  forever
	  #5 clk = ~clk;
end

reg rst;
initial begin
  rst = 1;
  repeat (10) @(posedge clk);
  rst <= #1 0;
  repeat (1000) @(posedge clk);
  $finish;
end

wire wrEn;
wire [SIZE-1:0] addr_toRAM;
wire [31:0] data_toRAM, data_fromRAM;

VerySimpleCPU inst_VerySimpleCPU(
  .clk(clk),
  .rst(rst),
  .wrEn(wrEn),
  .data_fromRAM(data_fromRAM),
  .addr_toRAM(addr_toRAM),
  .data_toRAM(data_toRAM)
);

blram #(SIZE, DEPTH) inst_blram(
  .clk(clk),
  .rst(rst),
  .i_we(wrEn),
  .i_addr(addr_toRAM),
  .i_ram_data_in(data_toRAM),
  .o_ram_data_out(data_fromRAM)
);

endmodule

module blram(clk, rst, i_we, i_addr, i_ram_data_in, o_ram_data_out);

parameter SIZE = 10, DEPTH = 1024;

input clk;
input rst;
input i_we;
input [SIZE-1:0] i_addr;
input [31:0] i_ram_data_in;
output reg [31:0] o_ram_data_out;

reg [31:0] memory[0:DEPTH-1];

always @(posedge clk) begin
  o_ram_data_out <= #1 memory[i_addr[SIZE-1:0]];
  if (i_we)
		memory[i_addr[SIZE-1:0]] <= #1 i_ram_data_in;
end 

initial begin
	$dumpfile("dump.vcd"); $dumpvars;
memory[0] = 32'h806401f4;
memory[1] = 32'h80190190;
memory[2] = 32'ha019412f;
memory[3] = 32'h60190065;
memory[4] = 32'hc04b4064;
memory[5] = 32'ha064012f;
memory[6] = 32'h104bc001;
memory[7] = 32'h8019012f;
memory[8] = 32'h701901fe;
memory[9] = 32'hc04b8064;
memory[10] = 32'hd04b0001;
memory[11] = 32'h80640190;
memory[100] = 32'h0;
memory[101] = 32'h0;
memory[200] = 32'h0;
memory[201] = 32'h0;
memory[300] = 32'h0;
memory[301] = 32'h6;
memory[302] = 32'hb;
memory[303] = 32'h1f5;
memory[400] = 32'h0;
memory[500] = 32'ha;
memory[501] = 32'h17;
memory[502] = 32'h7;
memory[503] = 32'hf4;
memory[504] = 32'ha;
memory[505] = 32'h17;
memory[506] = 32'h7;
memory[507] = 32'hf4;
memory[508] = 32'ha;
memory[509] = 32'h17;
memory[510] = 32'h7;
end

endmodule