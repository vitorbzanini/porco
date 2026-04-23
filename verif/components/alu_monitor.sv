//  Class: alu_monitor
//
class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)

  //  Group: Components
  virtual alu_if vif;

  //  Group: Variables
  uvm_analysis_port #(alu_tx) mon_analysis_port;
  
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  //  Group: Functions
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);   
    assert(uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif));
    assert(uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active));
    mon_analysis_port = new("mon_analysis_port", this);

  endfunction: build_phase

  task run_phase(uvm_phase phase);
    alu_tx item;
    super.run_phase(phase);

    forever begin
      @ (posedge vif.clk);

      //$display("MONITOR is_active = %0d", is_active);

      if (vif.valid_ip == 1'b1) begin
          item = new();
          item.sel_ip = vif.sel_ip;
          item.data_ip_1 = vif.data_ip_1;
          item.data_ip_2 = vif.data_ip_2;
          //mon_analysis_port.write(item);
      end 
      else begin 
          if (vif.valid_op == 1'b1) begin

            // $display("MONITOR: entradas %d e %d e saida = %0h ", vif.data_ip_1, vif.data_ip_2, vif.data_op);

            //item = new();
            //item.sel_ip = vif.sel_ip;
            item.data_op = vif.data_op;
            //item.data_ip_1 = vif.data_ip_1;
            //item.data_ip_2 = vif.data_ip_2;
            mon_analysis_port.write(item);
          end
      end
    end

  endtask: run_phase

  //  Constructor: new
  function new(string name = "alu_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction: new

endclass: alu_monitor




