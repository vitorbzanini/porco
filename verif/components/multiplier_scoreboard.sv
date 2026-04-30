import "DPI" function int multiplier(input int a, input int n);  

class multiplier_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(multiplier_scoreboard)
  
  uvm_analysis_imp #(multiplier_tx, multiplier_scoreboard) item_collected_export;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_export = new("item_collected_export", this);
  endfunction

  virtual function void write(multiplier_tx pkt);
    bit [31:0] expected_res; // DATA_WIDTH*2
    
    expected_res = multiplier(pkt.data_ip_1, pkt.data_ip_2); 

    if(pkt.data_op == expected_res)
      `uvm_info("SCBD_MATCH", $sformatf("Sucesso! Exp:%0h Obtido:%0h", expected_res, pkt.data_op), UVM_LOW)
    else
      `uvm_error("SCBD_MISMATCH", $sformatf("Erro! Exp:%0h Obtido:%0h", expected_res, pkt.data_op))
  endfunction
endclass