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

   constraint alu_sub { 
     if (sel_ip == 3'b001) 
      data_ip_1 >= data_ip_2; // Para evitar underflow
   }
   
   constraint just_sum {
      sel_ip == 3'b000;
   } 

   constraint alu_data_width { 
     if ((sel_ip == 3'b100) || (sel_ip == 3'b011))
        data_ip_2 <= `DATA_WIDTH; // Corrigido
   }

   constraint alu__incr_dec { 
     if ((sel_ip == 3'b101) || (sel_ip == 3'b110)){ 
        data_ip_2 == 0; // Se é INCR/DECR o data_ip_2 não importa
     }
   }

  function void print_2;
    `uvm_info("PRINT_ITEM", $sformatf("%p", this), UVM_LOW)
  endfunction : print_2

  function new(string name = "alu_tx");
    super.new(name);
  endfunction: new 

endclass: alu_tx