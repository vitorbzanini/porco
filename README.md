# Multiplicador com UVM e DPI

Projeto de verificação em SystemVerilog para um multiplicador sequencial de 16 bits, com bancada UVM e apoio de DPI em C para geração de vetores e cálculo de referência.

## Visão geral

O repositório contém três partes principais:

- `rtl/`: implementação do DUT, incluindo o módulo `multiplier` e o wrapper `multiplier_top`.
- `verif/`: ambiente de verificação UVM, com interface, pacote, transação, sequence, driver, monitor, agent, env, scoreboard e teste.
- `dpi/`: código C usado pela simulação para fornecer vetores e função de referência para o scoreboard.

O fluxo atual de simulação já está funcional e o teste `multiplier_test` executa com sucesso no Questa/ModelSim, com comparação entre saída do DUT e resultado esperado gerado via DPI.

## Arquitetura do DUT

O bloco principal é um multiplicador sequencial em `rtl/multiplier.sv`.

- Entradas: `in1`, `in2`, `start`, `reset`, `clk`.
- Saídas: `out` e `done`.
- Implementação: usa registradores de deslocamento, acumulador e uma FSM com estados `IDLE`, `RUN` e `DONE`.

O wrapper `rtl/multiplier_top.sv` conecta o multiplicador à interface de verificação e expõe sinais de controle como `ready_op` e `valid_op`.

## Ambiente UVM

O ambiente em `verif/` segue uma organização clássica:

- `verif/top_tb.sv`: top-level da simulação, instancia a interface, o DUT e chama `run_test("multiplier_test")`.
- `verif/multiplier_pkg.sv`: pacote que reúne todos os elementos UVM.
- `verif/multiplier_if.sv`: interface entre testbench e DUT.
- `verif/objects/multiplier_tx.sv`: transação UVM com dados de entrada e saída.
- `verif/objects/multiplier_seq.sv`: sequence que consome vetores do DPI.
- `verif/components/multiplier_driver.sv`: aplica as transações no DUT quando `ready_op` está ativo.
- `verif/components/multiplier_monitor.sv`: observa os sinais da interface e encaminha transações ao scoreboard.
- `verif/components/multiplier_scoreboard.sv`: compara a saída do DUT com o valor esperado.
- `verif/components/multiplier_env.sv`: monta agentes e scoreboard.
- `verif/components/multiplier_test.sv`: configura a árvore UVM e executa a sequence.

Há dois agentes no ambiente:

- `m_agt_in`: ativo, com sequencer e driver.
- `m_agt_out`: passivo, usado para observação.

## DPI e vetores de teste

O arquivo `dpi/common.c` compila uma biblioteca compartilhada (`dpi/dpi_common.so`) usada pela simulação.

No lado SystemVerilog, a sequence chama duas funções DPI-C:

- `reset_vectors()`: reinicia a fonte de vetores.
- `next_vector(...)`: fornece os próximos operandos.

O scoreboard também chama a função DPI `multiplier(a, n)` para calcular o resultado esperado e verificar a resposta do DUT.

## Como compilar e simular

O projeto foi pensado para rodar com Questa/ModelSim.

### Dependências

- `gcc`
- `vlog`
- `vsim`
- suporte a UVM do simulador

### Comandos

Compilar a biblioteca DPI:

```bash
make dpi
```

Rodar a simulação em batch:

```bash
make sim
```

Rodar em modo GUI:

```bash
make sim-gui
```

Limpar artefatos gerados:

```bash
make clean
```

## Estrutura de arquivos

```text
Makefile
run.do
dpi/
  common.c
rtl/
  multiplier.sv
  multiplier_top.sv
verif/
  multiplier_if.sv
  multiplier_pkg.sv
  top_tb.sv
  components/
  headers/
  objects/
work/
```

## Resultado atual da verificação

A simulação registrada no repositório terminou sem erros ou falhas de scoreboard.

- `UVM_ERROR`: 0
- `UVM_FATAL`: 0
- `SCBD_MATCH`: 38 comparações bem-sucedidas

## Observações

- O `run.do` é útil para uso interativo no Questa/ModelSim, mas o fluxo principal automatizado está no `Makefile`.
