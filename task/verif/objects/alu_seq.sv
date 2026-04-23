//  Class: alu_seq
//
class alu_seq extends uvm_sequence;

  //  Group: Variables
  rand int num_samples; //fi-lo porque qui-lo

  constraint num_samples_alu { num_samples inside { [9:10] }; }

  //  Group: Functions
  task body();
    alu_tx m_item; 
    repeat(num_samples) begin
      m_item = alu_tx::type_id::create("m_item"); 
      start_item(m_item); 
      assert(m_item.randomize()); 
       
      // m_item.print();
      m_item.print_2(); //printa
      finish_item(m_item); //cabô
    end
  endtask : body

  //  Constructor: new
  function new(string name = "alu_seq");
    super.new(name);
  endfunction: new

  `uvm_object_utils_begin( alu_seq )
      `uvm_field_int( num_samples, UVM_ALL_ON )
  `uvm_object_utils_end
  
endclass: alu_seq



