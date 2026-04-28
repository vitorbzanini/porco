//  Module: alu_top
//
module alu_top_multiplier
  /*  package imports  */
  #(
    parameter DATA_WIDTH  = 8,
    parameter SEL_WIDTH   = 3
  )(
    input                               clk, rst,
    input                               valid_ip, ready_ip,
    input       [(DATA_WIDTH-1):0]      data_ip_1, data_ip_2,
    input       [(SEL_WIDTH-1):0]       sel_ip,
    output reg                          valid_op, ready_op,
    output reg  [((DATA_WIDTH*2)-1):0]  data_op
  );

  reg                       available_r;  // Shows if the output registers are available.
  reg                       valid_int_ip_r;   // Internal valids for ip
  reg [(DATA_WIDTH-1):0 ]   data_ip_1_r, data_ip_2_r;
  reg [(SEL_WIDTH-1):0  ]   sel_ip_r;

  // ALU connections
  wire  [(DATA_WIDTH-1):0 ]     data_ip_1_w;
  wire  [(DATA_WIDTH-1):0 ]     data_ip_2_w;
  wire  [((DATA_WIDTH*2)-1):0]  data_op_w;

  // ALU Instantiation
  multiplier mult (
      .in1        (data_ip_1),
      .in2        (data_ip_2),
      .start      (valid_ip),
      .reset      (rst),
      .clk        (clk),
      .out        (data_op_w),
      .done       (valid_op)  
    );

  // checker porco
  always @ (posedge clk) begin
    if (valid_op) begin 
      //$display("Entrou %d , %d e saiu %x", data_ip_1, data_ip_2, data_op);
    end else begin 
      //$display("available_r = %d, valid_int_ip_r = %d, ready_ip = %d", available_r, valid_int_ip_r, ready_ip);
    end
  end
  
endmodule: alu_top_multiplier
