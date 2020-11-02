//typedef enum { DATA_RD_REQ, DATA_WR_REQ,INST_FETCH_REQ } e_req_type;
//typedef enum { ACT, PRE, RD, WR,REF} e_dram_cmd_type;

module tb_mem_controller ();
//`timescale 1ns/1ps

parameter DRAM_CLK_PERIOD = 10; //6250;
parameter CPU_CLK_PERIOD = 5; //3125;
//clk
logic cpu_clk_3p2ghz;
logic dram_clk_1p6ghz;

logic cpu_clk;
logic dram_clk;
logic reset_n;
logic [31:0] cpu_cycle;
e_req_type mem_req_type;
logic [31:0] mem_addr;
logic [31:0] dram_cycle;
e_dram_cmd_type dram_cmd;
logic [1:0] bank_group;
logic [1:0] bank;
logic [15:0]row;
logic [6:0]column;
integer cpu_file_h;
integer dram_file_h;

//ACT - BG bank row
//PRE - BG bank
// RD - BG Bank Column
// WR - BG Bank Column
//
initial begin
   cpu_file_h= $fopen("log_file.txt", "r");
   dram_file_h = $fopen("dram_cmd_file.txt","w");
   while(!$feof(cpu_file_h)) begin
	$fscanf(cpu_file_h,"%d %d %h\n",cpu_cycle,mem_req_type,mem_addr);
	$display("%4d %2d %h\n",cpu_cycle,mem_req_type,mem_addr);
	$fdisplay(dram_file_h,"%4d %2d %d %h %h",dram_cycle,bank_group,bank,row,column);
   end
	$fclose(dram_file_h);
	$fclose(cpu_file_h);
end
//readAndParse u_readAndParse();
mem_controller u_mem_controller(
   .cpu_clk(cpu_clk),
   .dram_clk(dram_clk),
   .reset_n(reset_n),
   .cpu_cycle(cpu_cycle),
   .mem_req_type(mem_req_type),
   .mem_addr(mem_addr),
   .dram_cycle(dram_cycle),
   .dram_cmd(dram_cmd),
   .bank_group(bank_group),
   .bank(bank),
   .row(row),
   .column(column));


assign cpu_clk = cpu_clk_3p2ghz;
assign dram_clk = dram_clk_1p6ghz;

initial begin
 #1;
   $display("memory controller");
   reset_n = 0;
   #100 reset_n =1;
end

// clk generator
initial begin
   //$timeformat(-9,3,"ns",8);
   cpu_clk_3p2ghz = 0;
   //forever  begin #(CPU_CLK_PERIOD/2) cpu_clk_3p2ghz = ~cpu_clk_3p2ghz;
//	$display(" cpu_clk_3p2ghz = %d ",cpu_clk_3p2ghz);
//end
end
initial begin
  // $timeformat(-9,3,"ns",8);
   dram_clk_1p6ghz = 0;
 //  forever  #(DRAM_CLK_PERIOD/2) dram_clk_1p6ghz= ~dram_clk_1p6ghz;
end

always begin 
	#(DRAM_CLK_PERIOD/2) dram_clk_1p6ghz= ~dram_clk_1p6ghz;
	$display("dram_clk_1p6ghz: %d", dram_clk_1p6ghz);
end
	
always #(CPU_CLK_PERIOD/2) cpu_clk_3p2ghz = ~cpu_clk_3p2ghz;
initial begin
   #100;
   $finish;
end
endmodule



