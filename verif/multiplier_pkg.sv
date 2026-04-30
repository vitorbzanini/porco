package multiplier_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  `include "multiplier_config.svh"
  

  `include "multiplier_tx.sv"
  `include "multiplier_seq.sv"
  `include "multiplier_sequencer.sv"
  `include "multiplier_driver.sv"
  `include "multiplier_monitor.sv"
  `include "multiplier_agent.sv"
  `include "multiplier_scoreboard.sv" // <-- INCLUÍDO AQUI
  `include "multiplier_env.sv"
  `include "multiplier_test.sv"
endpackage: multiplier_pkg