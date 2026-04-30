class alu_tx extends uvm_sequence_item;

  rand bit valid_ip;
  rand bit [`SEL_WIDTH-1:0] sel_ip;
  rand bit [`DATA_WIDTH-1:0] data_ip_1;
  rand bit [`DATA_WIDTH-1:0] data_ip_2;
  bit [(`DATA_WIDTH*2)-1:0] data_op; // Removido rand pois é a saída gerada

  `uvm_object_utils_begin( alu_tx )
      `uvm_field_int( valid_ip, UVM_ALL_ON )
      `uvm_field_int( sel_ip, UVM_ALL_ON )
      `uvm_field_int( data_ip_1, UVM_ALL_ON )
      `uvm_field_int( data_ip_2, UVM_ALL_ON )
      `uvm_field_int( data_op, UVM_ALL_ON )
  `uvm_object_utils_end
  
  function new(string name = "alu_tx");
    super.new(name);
  endfunction: new 

endclass: alu_tx