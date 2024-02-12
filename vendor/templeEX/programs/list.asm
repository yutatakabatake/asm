seti 0
move $m0
move $m1
HAJIME:
seti 10
move $m2
nor $m2
add $m30
add $m1
seti OWARI
move $m5
jl $m28 100 $m5
seti 1000
add $m0 
move $m6
seti 1
add $m1
sd $m6
seti 2 
add $m0
move $m0
seti 1
add $m1
move $m1
seti HAJIME
move $m7
jl $m7 111 $m28
OWARI:
jl $m31 111	$m28