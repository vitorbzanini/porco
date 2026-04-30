`include "alu_config.svh"
// `include "alu_if.sv"
// `include "alu_pkg.sv"
`include "uvm_macros.svh"

module top_tb;
  import uvm_pkg::*;
  import alu_pkg::*;

  logic clk, rst;

  localparam DATA_WIDTH = `DATA_WIDTH;
  localparam SEL_WIDTH = `SEL_WIDTH;

  alu_if #( .DATA_WIDTH(DATA_WIDTH), .SEL_WIDTH(SEL_WIDTH))dut_if0 
  (.clk(clk), .rst(rst));

  // Instanciação do DUT conectando à interface
  alu_top_multiplier #(
    .DATA_WIDTH(`DATA_WIDTH),
    .SEL_WIDTH(`SEL_WIDTH)
  ) dut (
    .clk      (clk),
    .rst      (rst),
    .valid_ip (dut_if0.valid_ip),
    .data_ip_1(dut_if0.data_ip_1),
    .data_ip_2(dut_if0.data_ip_2),
    .valid_op (dut_if0.valid_op),
    .ready_op (dut_if0.ready_op),
    .data_op  (dut_if0.data_op)
  );

  initial begin    
    clk = 1'b0;
    rst = 1'b1;
    #10 rst = 1'b0; // Libera do reset inicial
    forever #2 clk = ~clk;
  end

    initial begin
      uvm_config_db#(virtual alu_if)::set(null, "uvm_test_top", "vif", dut_if0);
      run_test("alu_test");
    end
endmodule: top_tb