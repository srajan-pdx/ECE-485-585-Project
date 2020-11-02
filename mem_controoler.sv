typedef enum { DATA_RD_REQ, DATA_WR_REQ,INST_FETCH_REQ } e_req_type;
typedef enum { ACT, PRE, RD, WR,REF} e_dram_cmd_type;
module mem_controller(
   input cpu_clk,
   input dram_clk,
   input reset_n,
   input cpu_cycle,
   input e_req_type mem_req_type,
   input mem_addr,
   output dram_cycle,
   output dram_cmd,
   output bank_group,
   output bank,
   output row,
   output column
);

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


//Bit
//0..2      byte-index into 8-byte cache line
//3..12     column address (A0-A9)
//13.14     bank*
//15        row address (A11)
//16..26    row address (A0-A10)
//27..28    row address (A12-A13)
//* Bank is selected by XORing row bits 18,19 with bits 13,14 respectively

// row 33-17
// high col 16-10 
//bank 9-8
//bg 7-6
//low col: 5-3
//byte select 2-0
assign bank_group = mem_addr[7:6];
assign bank = mem_addr[9:8];
assign row = mem_addr[33:17];
assign column = {mem_addr[16:10],mem_addr[5:3]};

endmodule



