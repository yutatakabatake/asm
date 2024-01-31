#!/bin/sh

rm *.vcd
rm a.out 

iverilog -o a.out *.v

./a.out

# gtkwave testfix.vcd &
