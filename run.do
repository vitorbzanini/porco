# Limpa o console
transcript on

# 1. Compilação
# Adicionei -sv para forçar SystemVerilog e -timescale para evitar warnings do UVM
vlog -sv -timescale=1ns/1ns \
     +incdir+verif/ \
     +incdir+verif/headers/ \
     +incdir+verif/objects/ \
     +incdir+verif/components/ \
     verif/multiplier_pkg.sv \
     verif/multiplier_if.sv \
     rtl/multiplier.sv \
     rtl/multiplier_top.sv \
     verif/top_tb.sv

# 2. Inicia a Simulação chamando o motor do UVM
# +UVM_TESTNAME diz para a factory qual teste instanciar
# +UVM_NO_RELNOTES desativa aquele textão gigante de versão do UVM no terminal
vsim -voptargs=+acc top_tb +UVM_TESTNAME=multiplier_test +UVM_NO_RELNOTES +UVM_VERBOSITY=UVM_LOW -sv_lib verif_c/mydpi

# 3. Configura as formas de onda
add wave -position insertpoint sim:/top_tb/dut_if0/*
add wave -position insertpoint sim:/top_tb/dut/*

# 4. Roda a simulação até o UVM decidir parar (quando o drop_objection zerar)
run -all