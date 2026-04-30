//  Class: multiplier_monitor
//
class multiplier_monitor extends uvm_monitor;
  `uvm_component_utils(multiplier_monitor)

  //  Group: Components
  virtual multiplier_if vif;

  //  Group: Variables
  uvm_analysis_port #(multiplier_tx) mon_analysis_port;
  
  // uvm_active_passive_enum is_active = UVM_ACTIVE;

  //  Group: Functions
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);   
    assert(uvm_config_db#(virtual multiplier_if)::get(this, "", "vif", vif));
    mon_analysis_port = new("mon_analysis_port", this);

  endfunction: build_phase

  task run_phase(uvm_phase phase);
    multiplier_tx item;
    super.run_phase(phase);

    forever begin
      @ (posedge vif.clk);

      if (vif.valid_ip == 1'b1) begin
          item = new();
          // item.sel_ip = vif.sel_ip;
          item.data_ip_1 = vif.data_ip_1;
          item.data_ip_2 = vif.data_ip_2;
          //mon_analysis_port.write(item);
      end 
      else begin 
          if (vif.valid_op == 1'b1) begin
            item.data_op = vif.data_op;
            mon_analysis_port.write(item);
          end
      end
    end

  endtask: run_phase

  //  Constructor: new
  function new(string name = "multiplier_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction: new

endclass: multiplier_monitor




