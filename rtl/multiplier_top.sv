//  Module: alu_top
//
module alu_top_multiplier
  /*  package imports  */
  #(
    parameter DATA_WIDTH  = 8,
    parameter SEL_WIDTH   = 3
  )(
    input                               clk, rst,
    input                               valid_ip,
    input       [(DATA_WIDTH-1):0]      data_ip_1, data_ip_2,
    output reg                          valid_op, ready_op,
    output reg  [((DATA_WIDTH*2)-1):0]  data_op
  );

  logic ready_op_w;

  assign ready_op = ready_op_w;

  always_ff@ (posedge clk, posedge rst)				//SHIFT REGISTER A 32 bit
  begin 
    if (rst == 1'b1) begin
      ready_op_w <= 1'b1;
    end
    else  begin 
      if (valid_ip) ready_op_w <= 1'b0;
      else if (valid_op) ready_op_w <= 1'b1;
    end
  end

  // Multiplier Instantiation
  multiplier mult (
      .in1        (data_ip_1),
      .in2        (data_ip_2),
      .start      (valid_ip),
      .reset      (rst),
      .clk        (clk),
      .out        (data_op),
      .done       (valid_op)  
    );

endmodule: alu_top_multiplier
