vlib work
vlog -f src_files.list +cover
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave -position insertpoint  \
sim:/top/WR_test_if/clk
add wave -position insertpoint  \
sim:/top/WR_test_if/rst_n
add wave -position insertpoint  \
sim:/top/WR_test_if/SS_n
add wave -position insertpoint  \
sim:/top/WR_test_if/MOSI
add wave -position insertpoint  \
sim:/top/WR_test_if/MISO
add wave -position insertpoint  \
sim:/top/WR_ref_if/MISO_ref
coverage save top.ucdb -onexit 
run -all
quit -sim
vcover report top.ucdb -details -annotate -all -output partIII_coverage.txt