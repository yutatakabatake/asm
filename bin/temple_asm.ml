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
         | Label of string

type info_label = { label:string; address:int }
type info_address = { address:int; inst:inst }

let byte_size i = 
  match i with
  | SetiN _ -> 3
  | SetiL _ -> 3
  | Move _ -> 1
  | Add _ -> 1
  | Nor _ -> 1
  | Jl _ -> 2
  | Sd _ -> 1
  | Ld _ -> 1
  | _ -> 0

(*
let rec stm_to_string ast = 
          match ast with
          | Line (s1, s2) -> "Line (" ^ inst_to_string s1 ^ ", " ^ stm_to_string s2 ^ ")"
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
*)

let rec stm_to_string2 ast = 
  match ast with
  | Line (s1, s2) ->  inst_to_string2 s1 ^ "\n" ^ stm_to_string2 s2
  | EOP -> "\tEND\n"
and inst_to_string2 e =
  match e with
  | SetiN n -> "\tSETI " ^ "\t" ^ string_of_int n
  | SetiL v -> "\tSETI " ^ "\t" ^ v
  | Move v -> "\tMOVE " ^ "\t" ^ v 
  | Add v ->  "\tADD " ^ "\t" ^ v
  | Nor v -> "\tNOR " ^ "\t" ^ v 
  | Jl (e1, e2, e3) -> "\tJL " ^ "\t" ^ e1 ^ "\t"  ^ string_of_int e2 ^ "\t"  ^ e3
  | Sd v -> "\tSD "  ^ "\t" ^ v 
  | Ld v -> "\tLD "  ^ "\t" ^ v
  | Label v -> v ^ ":"

let print_ast2 ast = print_string (stm_to_string2 ast)

let label_to_string i =
  match i with
  | Label v -> v
  | _ -> "error"

let rec make_record stm : (info_label list * info_address list) =
  let rec f stm n =
   match stm with
   | Line(i, stm') -> let n' = byte_size i in
                      let (ls, is) = f stm' (n'+n) in
                      f' i n (ls, is)
   | _ -> ([],[])
                    in f stm 0
  and f' i n (ls, is) =
    match i with
    | Label _ -> ({label = label_to_string i; address = n}::ls,{address = n; inst = i}::is)
    | _ -> (ls, {address = n; inst = i}::is)

let print_ls ls = List.iter (fun r -> print_string (r.label ^ "\t" ^ string_of_int r.address ^ "\n")) ls
 
let print_is is = List.iter (fun r -> print_string (string_of_int r.address ^ "\t" ^ inst_to_string2 r.inst ^ "\n")) is

let print_record stm = let (ls, is) = make_record stm in
                        print_ls ls ;
                        print_is is