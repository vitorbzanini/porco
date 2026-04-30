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
  logic                         valid_ip;
  logic [(DATA_WIDTH-1):0]      data_ip_1, data_ip_2;
  logic                         valid_op, ready_op;
  logic [((DATA_WIDTH*2)-1):0]  data_op;

endinterface: alu_if

`endif