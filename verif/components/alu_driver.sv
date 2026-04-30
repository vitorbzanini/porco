// Arquivo: verif/components/alu_driver.sv
class alu_driver extends uvm_driver #(alu_tx);
  `uvm_component_utils(alu_driver)

  virtual alu_if vif;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif));
  endfunction: build_phase
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    // 1. INICIALIZAÇÃO (Acaba com os sinais vermelhos!)
    vif.valid_ip  <= 1'b0;
    vif.data_ip_1 <= '0;
    vif.data_ip_2 <= '0;
    
    // 2. Espera o Reset abaixar antes de fazer qualquer coisa
    wait(vif.rst == 1'b0);
    @(posedge vif.clk);

    forever begin
      alu_tx m_item;
      seq_item_port.get_next_item(m_item);
      
      // 3. Injeta a transação
      drive_item(m_item);
      
      seq_item_port.item_done();
    end
  endtask: run_phase

  task drive_item(alu_tx m_item);
    // Sincroniza com a borda de subida do clock
    @(posedge vif.clk iff vif.ready_op === 1'b1);

    // Coloca os dados no barramento e levanta a flag de válido
    vif.valid_ip  <= 1'b1; // Forçamos para 1 para garantir que o DUT veja
    vif.data_ip_1 <= m_item.data_ip_1;
    vif.data_ip_2 <= m_item.data_ip_2;

    // Aguarda um ciclo para o DUT registrar os dados
    @(posedge vif.clk);

    // Abaixa o valid para não enviar o mesmo dado repetidamente (simula um pulso)
    vif.valid_ip <= 1'b0;
    
    // Opcional: Adiciona um pequeno atraso entre as transações
    @(posedge vif.clk);
  endtask : drive_item

  function new(string name = "alu_driver", uvm_component parent);
    super.new(name, parent);
  endfunction: new
endclass: alu_driver