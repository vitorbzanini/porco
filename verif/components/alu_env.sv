class alu_env extends uvm_env;
  `uvm_component_utils(alu_env)

  alu_agent      m_agt_in;  
  alu_agent      m_agt_out; 
  alu_scoreboard m_scbd;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    m_agt_in  = alu_agent::type_id::create("m_agt_in", this);
    m_agt_out = alu_agent::type_id::create("m_agt_out", this);
    m_scbd    = alu_scoreboard::type_id::create("m_scbd", this);

    uvm_config_db #(uvm_active_passive_enum) :: set (this, "m_agt_in", "is_active", UVM_ACTIVE);
    uvm_config_db #(uvm_active_passive_enum) :: set (this, "m_agt_out", "is_active", UVM_PASSIVE);
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_agt_out.mon_analysis_port.connect(m_scbd.item_collected_export);
  endfunction: connect_phase
  
  function new(string name = "alu_env", uvm_component parent);
    super.new(name, parent);
  endfunction: new  
endclass: alu_env


