#!/bin/sh
#このファイルがvendor/templeEX/programsにあることを仮定している
set -x
TESTDIR=`pwd`
ASMDIR=$TESTDIR/../../../
TEMPLEDIR=$TESTDIR/../original

cd ${ASMDIR}
dune exec asm_project < ${TESTDIR}/$1.asm > ${TESTDIR}/$1.dat

cd ${TESTDIR}

rm *.vcd
rm a.out

cd ${TEMPLEDIR}

iverilog -o ${TESTDIR}/a.out *.v ${TESTDIR}/$1_testfix.v

cd ${TESTDIR}
./a.out

# gtkwave testfix.vcd &
