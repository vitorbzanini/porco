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

  logic [3:0] cont;
  logic ready_op_w;

  assign ready_op = ready_op_w;

  always_ff@ (posedge clk, posedge rst)				//SHIFT REGISTER A 32 bit
  begin 
    if (rst == 1'b1) begin
      ready_op_w <= 1'b1;
      cont       <= 4'b0000; 
    end
    else  begin 
      if (valid_ip) ready_op_w <= 1'b0;
      else if (valid_op)  cont <= cont + 4'b0001;
      else if(cont > 4'b0110) begin 
        ready_op_w <= 1'b1;
        cont       <= 4'b0000; 
      end
      else if(cont >= 4'b0001) cont <= cont + 4'b0001;
    end
  end

  // ALU Instantiation
  multiplier mult (
      .in1        (data_ip_1),
      .in2        (data_ip_2),
      .start      (valid_ip),
      .reset      (rst),
      .clk        (clk),
      .out        (data_op),
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
