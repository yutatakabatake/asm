seti 0
move $m0
seti 0
move $m1
branch:
seti 10
move $m2
nor $m2
add $m30
add $m0
seti break
move $m4
jl $m28 110 $m4
nor $m31
add $m1
add $m0
move $m1
nor $m31
add $m0
add $m29
move $m0
seti branch
move $m5
jl $m28 000 $m5
break:
seti 1000
move $m3
nor $m31
add $m1
sd $m3
jl  $m31 111 $m28