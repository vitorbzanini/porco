# Makefile para compilar DPI e rodar simulação (ModelSim/Questa)

TOP = top_tb

VLOG = vlog
VSIM = vsim

INCDIRS = verif verif/headers verif/objects verif/components
INCFLAGS = $(foreach d,$(INCDIRS),+incdir+$(d))

SV_SOURCES = \
	verif/alu_pkg.sv \
	verif/alu_if.sv \
	verif/components/*.sv \
	verif/objects/*.sv \
	rtl/alu_core.sv \
	rtl/alu_top.sv \
	verif/top_tb.sv

DPI_C = verif_c/multiplier.c
DPI_SO = verif_c/mydpi.so

SIM_ARGS = +UVM_TESTNAME=alu_test +UVM_NO_RELNOTES +UVM_VERBOSITY=UVM_LOW

.PHONY: all help sim dpi clean

all: sim

help:
	@echo "Uso: make [target]"
	@echo "Targets:" 
	@echo "  sim    - compila DPI e roda simulação com ModelSim/Questa"
	@echo "  dpi    - compila a biblioteca DPI ($(DPI_SO))"
	@echo "  clean  - remove artefatos gerados"

dpi: $(DPI_SO)

$(DPI_SO): $(DPI_C)
	@echo "Compilando DPI: $@"
	@gcc -shared -fPIC -o $@ $<

sim: dpi
	@command -v $(VLOG) >/dev/null 2>&1 || { echo "vlog não encontrado. Instale ModelSim/Questa ou ajuste o PATH."; exit 1; }
	@command -v $(VSIM) >/dev/null 2>&1 || { echo "vsim não encontrado. Instale ModelSim/Questa ou ajuste o PATH."; exit 1; }
	@echo "Compilando fontes SystemVerilog..."
	@$(VLOG) -sv -timescale=1ns/1ns $(INCFLAGS) $(SV_SOURCES)
	@echo "Iniciando simulação ($(VSIM))..."
	@$(VSIM) -voptargs=+acc $(TOP) $(SIM_ARGS) -sv_lib $(DPI_SO)

clean:
	@echo "Removendo artefatos..."
	-@rm -f $(DPI_SO)
	-@rm -f transcript vsim.wlf ucli.key *.log *.log.*
	-@rm -rf work
