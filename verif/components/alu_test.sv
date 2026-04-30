class alu_test extends uvm_test;
  `uvm_component_utils(alu_test)

  alu_env   m_env;
  virtual alu_if vif;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_env = alu_env::type_id::create("m_env", this);

    assert(uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif)); 
    
    uvm_config_db#(virtual alu_if)::set(this, "m_env.m_agt_in.*", "vif", vif);
    uvm_config_db#(virtual alu_if)::set(this, "m_env.m_agt_out.*", "vif", vif);
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase
  
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction: end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    alu_seq seq = alu_seq::type_id::create("seq");
    phase.raise_objection(this);
    
    // Inicia a sequence
    seq.start(m_env.m_agt_in.m_seqr);
    
    #100ns;
    phase.drop_objection(this);  
  endtask: run_phase
  
  function new(string name = "alu_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

endclass: alu_test