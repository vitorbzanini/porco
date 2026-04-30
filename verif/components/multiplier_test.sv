class multiplier_test extends uvm_test;
  `uvm_component_utils(multiplier_test)

  multiplier_env   m_env;
  virtual multiplier_if vif;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_env = multiplier_env::type_id::create("m_env", this);

    assert(uvm_config_db#(virtual multiplier_if)::get(this, "", "vif", vif)); 
    
    uvm_config_db#(virtual multiplier_if)::set(this, "m_env.m_agt_in.*", "vif", vif);
    uvm_config_db#(virtual multiplier_if)::set(this, "m_env.m_agt_out.*", "vif", vif);
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase
  
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction: end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    multiplier_seq seq = multiplier_seq::type_id::create("seq");
    phase.raise_objection(this);
    
    // Inicia a sequence
    seq.start(m_env.m_agt_in.m_seqr);
    
    #100ns;
    phase.drop_objection(this);  
  endtask: run_phase
  
  function new(string name = "multiplier_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

endclass: multiplier_test