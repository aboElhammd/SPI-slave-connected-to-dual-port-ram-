vlib work
vlog -f src_files.list +cover
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave /top/ram_if/*
run 0
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/scoreboard/rd_addr \
sim:/uvm_root/uvm_test_top/env/scoreboard/wr_addr \
sim:/uvm_root/uvm_test_top/env/scoreboard/tx_valid_ref \
sim:/uvm_root/uvm_test_top/env/scoreboard/dout_ref \
sim:/top/DUT/wr_ptr \
sim:/top/DUT/rd_ptr 
coverage save top.ucdb -onexit 
run -all
quit -sim
vcover report top.ucdb -details -annotate -all -output RAM_coverage.txt

