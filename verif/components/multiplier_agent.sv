//  Class: multiplier_agent
//
class multiplier_agent extends uvm_agent;

 //uvm_analysis_port #(multiplier_tx) multiplier_ap; não deveria ter uma ap aqui?

  //  Group: Components
  multiplier_sequencer   m_seqr;  
  multiplier_driver      m_drv;
  multiplier_monitor     m_mon;  

  //  Group: Variables
  uvm_analysis_port #(multiplier_tx) mon_analysis_port;
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  `uvm_component_utils_begin(multiplier_agent)
  `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  //  Group: Functions
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_analysis_port = new( "mon_analysis_port", this);
    m_mon   = multiplier_monitor   ::type_id::create("m_mon" , this);
    assert(uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active));
    
    if (is_active == UVM_ACTIVE) begin
      m_seqr  = multiplier_sequencer ::type_id::create("m_seqr", this);
      m_drv   = multiplier_driver    ::type_id::create("m_drv" , this);
    end
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE)
      m_drv.seq_item_port.connect(m_seqr.seq_item_export);
    
    m_mon.mon_analysis_port.connect(mon_analysis_port);
  endfunction: connect_phase

  //  Constructor: new
  function new(string name = "multiplier_agent", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
endclass: multiplier_agent



