#!/bin/sh

rm *.vcd
rm a.out

cd ../original

iverilog -o ../programs/a.out *.v ../programs/$1_testfix.v

cd ../programs
./a.out

# gtkwave testfix.vcd &
