# Makefile para compilar DPI e rodar simulação (ModelSim/Questa)

TOP = top_tb

VLOG = vlog
VSIM = vsim

INCDIRS = verif verif/headers verif/objects verif/components
INCFLAGS = $(foreach d,$(INCDIRS),+incdir+$(d))

SV_SOURCES = \
	verif/alu_pkg.sv \
	verif/alu_if.sv \
	rtl/multiplier.sv \
	rtl/multiplier_top.sv \
	verif/top_tb.sv

DPI_C = dpi/common.c
DPI_LIB = dpi/dpi_common
DPI_SO = $(DPI_LIB).so

SIM_ARGS = +UVM_TESTNAME=alu_test +UVM_NO_RELNOTES +UVM_VERBOSITY=UVM_LOW

TIME=-all

.PHONY: all help sim sim-gui dpi clean

all: sim

help:
	@echo "Uso: make [target]"
	@echo "Targets:" 
	@echo "  sim    - compila DPI e roda simulação em batch (terminal)"
	@echo "  sim-gui - compila DPI e roda simulação em modo GUI"
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
	@echo "Iniciando simulação em batch ($(VSIM))..."
	@$(VSIM) -c -voptargs=+acc $(TOP) $(SIM_ARGS) -sv_lib $(DPI_LIB) -do "run ${TIME}; quit -f"

sim-gui: dpi
	@command -v $(VLOG) >/dev/null 2>&1 || { echo "vlog não encontrado. Instale ModelSim/Questa ou ajuste o PATH."; exit 1; }
	@command -v $(VSIM) >/dev/null 2>&1 || { echo "vsim não encontrado. Instale ModelSim/Questa ou ajuste o PATH."; exit 1; }
	@echo "Compilando fontes SystemVerilog..."
	@$(VLOG) -sv -timescale=1ns/1ns $(INCFLAGS) $(SV_SOURCES)
	@echo "Iniciando simulação em GUI ($(VSIM))..."
	@$(VSIM) -voptargs=+acc $(TOP) $(SIM_ARGS) -sv_lib $(DPI_LIB) -do "run ${TIME}; quit -f"

clean:
	@echo "Removendo artefatos..."
	-@rm -rf $(DPI_SO)
	-@rm -rf $(DPI_LIB)
	-@rm -rf transcript vsim.wlf ucli.key *.log *.log.*
	-@rm -rf work
