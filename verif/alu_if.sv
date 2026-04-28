`ifndef alu_if__sv
`define alu_if__sv
//  Interface: alu_if
//
interface alu_if
  /*  package imports  */
  #(
    parameter DATA_WIDTH  = 16,
    parameter SEL_WIDTH   = 3
  )(
    input clk, rst
  );
  logic                         valid_ip, ready_ip;
  logic [(DATA_WIDTH-1):0]      data_ip_1, data_ip_2;
  logic [(SEL_WIDTH-1):0]       sel_ip;
  logic                         valid_op, ready_op;
  logic [((DATA_WIDTH*2)-1):0]  data_op;

 /* modport alu_mp_in(
  input clk, rst, valid_ip, sel_ip, data_ip_1, data_ip_2, 
  output ready_op);

  modport alu_mp_out(
  input clk, rst, ready_ip, output valid_op, data_op);
  */


endinterface: alu_if

`endif