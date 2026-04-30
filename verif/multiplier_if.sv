`ifndef multiplier_if__sv
`define multiplier_if__sv
//  Interface: multiplier_if
//
interface multiplier_if
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

endinterface: multiplier_if

`endif