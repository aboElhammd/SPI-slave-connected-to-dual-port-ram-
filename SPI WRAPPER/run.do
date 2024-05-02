vlib work
vlog -f src_files.list +define+ASSERTIONS  +cover 
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave /top/WRAPPER_TESTED/* 
run 0 
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/ag/mon/i \
sim:/uvm_root/uvm_test_top/env/ag/mon/cs \
sim:/uvm_root/uvm_test_top/env/ag/mon/VAR_MOSI 
coverage save top.ucdb -onexit 
run -all
quit -sim
vcover report top.ucdb -details -annotate -all -output WRAPPER_coverage.txt