seti 0
move $m0
move $m1
branch:
seti 10
move $m2
nor $m2
add $m30
add $m0
seti break
move $m4
jl $m28 100 $m4
nor $m31
add $m1
add $m0
move $m1
nor $m31
add $m0
add $m30
move $m0
seti branch
move $m5
jl $m5 111 $m28
break:
seti 1000
move $m6
nor $m31
add $m1
sd $m6
jl  $m31 111 $m28