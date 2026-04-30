//  Class: alu_seq
//
import "DPI-C" function void reset_vectors();
import "DPI-C" function int  next_vector(output bit [15:0] data1,
                                          output bit [15:0] data2);

class alu_seq extends uvm_sequence;

  //  Group: Functions
  task body();
    alu_tx m_item; 
    bit [15:0] data1, data2;

    reset_vectors();

    while(next_vector(data1, data2)) begin
      m_item = alu_tx::type_id::create("m_item"); 
      
      start_item(m_item); 

      m_item.data_ip_1 = data1;
      m_item.data_ip_2 = data2;

      finish_item(m_item); 
    end
  endtask : body

  //  Constructor: new
  function new(string name = "alu_seq");
    super.new(name);
  endfunction: new

  // Need to be initialized to register on UVM factory
  `uvm_object_utils_begin( alu_seq )
  `uvm_object_utils_end

endclass: alu_seq



