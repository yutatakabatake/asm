type stm = Line of inst * stm
         | EOP
and inst = SetiN of int
         | SetiL of string
         | Move of string
         | Add of string
         | Nor of string
         | Jl of string * int * string
         | Sd of string
         | Ld of string

let rec stm_to_string ast = 
          match ast with
          | Line (s1,s2) -> inst_to_string s1 ^ ", " ^ stm_to_string s2
          | EOP -> "END"
and inst_to_string e =
          match e with
          | SetiN n -> "SETI " ^ string_of_int n
          | SetiL v -> "SETI " ^ v
          | Move v -> "MOVE " ^ v 
          | Add v ->  "ADD " ^ v
          | Nor v -> "NOR " ^ v 
          | Jl (e1, e2, e3) -> "JL " ^ e1 ^ string_of_int e2 ^ e3
          | Sd v -> "SD " ^ v 
          | Ld v -> "LD " ^ v

let print_ast ast = print_string (stm_to_string ast)