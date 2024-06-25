type stm = Line of inst * stm
         | EOP
and inst = SetiN of int
         | SetiL of string
         | Move of string
         | Add of string
         | Nor of string
         | Jl of string * int * string
         | Jllabel of string * int * string        
         | Sd of string
         | Ld of string
         | Srl
         | Label of string

type inst_type = TypeF of int * int
               | TypeJ of int * int * int * int
               | TypeI of int * int * int

type info_label = { label:string; addressl:int }
type info_address = { address:int; insts:inst }
type info_inst_type = { addressi:int; inst_type:inst_type option }

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
  | Srl -> 1
  | _ -> 0

let rec look_up_label info_labels label = 
  match info_labels with
  | [] -> 0
  | { label = l; addressl = a }::t -> if l = label then a 
                                      else look_up_label t label

let judge_inst_type i info_labels = 
  match i with
  | SetiN n -> Some (TypeI (0b101, 0, n))
  | SetiL v -> Some (TypeI (0b101, 0, look_up_label info_labels v))
  | Move v -> Some (TypeF (0b011, int_of_string (String.sub v 2 (String.length v - 2))))
  | Add v -> Some (TypeF (0b001, int_of_string (String.sub v 2 (String.length v - 2))))
  | Nor v -> Some (TypeF (0b000, int_of_string (String.sub v 2 (String.length v - 2))))
  | Jl (e1, e2, e3) -> Some (TypeJ (0b110, int_of_string (String.sub e1 2 (String.length e1 - 2)), e2, int_of_string (String.sub e3 2 (String.length e3 - 2))))
  | Jllabel (e1, e2, e3) -> Some (TypeJ (0b110, int_of_string (String.sub e1 2 (String.length e1 - 2)), e2, look_up_label info_labels e3))
  | Sd v -> Some (TypeF (0b100, int_of_string (String.sub v 2 (String.length v - 2))))
  | Ld v -> Some (TypeF (0b010, int_of_string (String.sub v 2 (String.length v - 2))))
  | Srl -> Some (TypeF (0b111, 0))
  | _ -> None

let inst_type_to_string i =
   match i with
   | None -> ""
   | Some(TypeF(n1, n2)) -> string_of_int n1 ^ ":" ^ string_of_int n2 ^ "\t"
   | Some(TypeJ(n1, n2, n3, n4)) -> string_of_int n1 ^ ":" ^ string_of_int n2 ^ ":" ^ string_of_int n3 ^ ":" ^ string_of_int n4
   | Some(TypeI(n1, n2, n3)) -> if n3 <= 999 then string_of_int n1 ^ ":" ^ string_of_int n2 ^ ":" ^ string_of_int n3 ^ "\t"
                                else string_of_int n1 ^ ":" ^ string_of_int n2 ^ ":" ^ string_of_int n3

let inst_type_to_num i = 
  match i with
  | Some(TypeF(n1, n2)) -> string_of_int (32 * n1 + n2) ^ "\t"
  | Some(TypeJ(n1, n2, n3, n4)) -> string_of_int (32 * n1 + n2) ^ ":" ^ string_of_int (32 * n3 + n4)
  | Some(TypeI(n1, n2, n3)) -> if (n3 mod 256) <= 99 then string_of_int (32 * n1 + n2) ^ ":" ^ string_of_int (n3 / 256) ^ ":" ^ string_of_int (n3 mod 256) ^ "\t"
  else string_of_int (32 * n1 + n2) ^ ":" ^ string_of_int (n3 / 256) ^ ":" ^ string_of_int (n3 mod 256)
  | None -> ""

let f num n = 
  let num1 = num lsr n in
  let num2 = num1 land 1 in
  string_of_int num2

let g num =
  let rec ff num n = 
    if n > 0 then f num n ^ ff num (n-1)
    else f num n
  in ff num 7

(* アドレス等を表示する用　区切りが: *)
let inst_type_to_8bit1 i = 
  match i with
  | Some(TypeF(n1, n2)) -> g (32 * n1 + n2)
  | Some(TypeJ(n1, n2, n3, n4)) -> g (32 * n1 + n2) ^ ":" ^ g (32 * n3 + n4)
  | Some(TypeI(n1, n2, n3)) -> g (32 * n1 + n2) ^ ":" ^ g (n3 mod 256) ^ ":" ^ g (n3 / 256) (*n2,n3が間違ってる*)
  | None -> ""

(* バイナリを表示する用　区切りが改行 *)
let inst_type_to_8bit2 i = 
  match i with
  | Some(TypeF(n1, n2)) -> g (32 * n1 + n2)
  | Some(TypeJ(n1, n2, n3, n4)) -> g (32 * n1 + n2) ^ "\n" ^ g (32 * n3 + n4)
  | Some(TypeI(n1, n2, n3)) -> g (32 * n1 + n2) ^ "\n" ^ g (n3 mod 256) ^ "\n" ^ g (n3 / 256)
  | None -> ""

let rec stm_to_string2 ast = 
  match ast with
  | Line (s1, s2) ->  inst_to_string2 s1 ^ "\n" ^ stm_to_string2 s2
  | EOP -> "\tEND\n"
and inst_to_string2 e =
  match e with
  | SetiN n -> if n > 999 then "\tSETI " ^ "\t" ^ string_of_int n 
               else "\tSETI " ^ "\t" ^ string_of_int n 
  | SetiL v -> "\tSETI " ^ "\t" ^ v
  | Move v -> "\t\t\tMOVE " ^ "\t" ^ v
  | Add v ->  "\t\t\tADD " ^ "\t" ^ v
  | Nor v -> "\t\t\tNOR " ^ "\t" ^ v
  | Jl (e1, e2, e3) -> "\t\tJL " ^ "\t" ^ e1 ^ "\t"  ^ string_of_int e2 ^ "\t"  ^ e3
  | Jllabel (e1, e2, e3) -> "\t\tJL " ^ "\t" ^ e1 ^ "\t"  ^ string_of_int e2 ^ "\t"  ^ e3
  | Sd v -> "\t\t\tSD "  ^ "\t" ^ v
  | Ld v -> "\t\t\tLD "  ^ "\t" ^ v
  | Srl -> "\t\t\tSRL"
  | Label v -> "\t\t\t\t\t" ^ v ^ ":"

let inst_to_string3 e =
  match e with
  | SetiN n -> "SETI " ^ "\t" ^ string_of_int n 
  | SetiL v -> "SETI " ^ "\t" ^ v
  | Move v -> "MOVE " ^ "\t" ^ v
  | Add v ->  "ADD " ^ "\t" ^ v
  | Nor v -> "NOR " ^ "\t" ^ v
  | Jl (e1, e2, e3) -> "JL " ^ "\t" ^ e1 ^ "\t"  ^ string_of_int e2 ^ "\t"  ^ e3
  | Jllabel (e1, e2, e3) -> "JL " ^ "\t" ^ e1 ^ "\t"  ^ string_of_int e2 ^ "\t"  ^ e3
  | Sd v -> "SD "  ^ "\t" ^ v
  | Ld v -> "LD "  ^ "\t" ^ v
  | Srl -> "SRL"
  | Label v -> v ^ ":"

let print_ast2 ast = print_string (stm_to_string2 ast)

let label_to_string i =
  match i with
  | Label v -> v
  | Jllabel (_, _, e3) -> e3
  | _ -> "error"

(* labelとinstとそれぞれのアドレスを格納 *)
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
    | Label _ -> ({label = label_to_string i; addressl = n}::ls,{address = n; insts = i}::is)
    | Jllabel (_, _, _) -> ({label = label_to_string i; addressl = n}::ls,{address = n; insts = i}::is)
    | _ -> (ls, {address = n; insts = i}::is)

let print_ls ls = List.iter (fun r -> print_string (r.label ^ "\t" ^ string_of_int r.addressl ^ "\n")) ls

let print_is is = List.iter (fun r -> print_string (string_of_int r.address ^ "\t" ^ inst_to_string2 r.insts ^ "\n")) is

let print_record stm = let (ls, is) = make_record stm in
                        print_ls ls ;
                        print_is is

let make_info_inst_type_list stm : info_inst_type list = let (ls, is) = make_record stm in
                                              let it = [] in 
                                                let rec f t = 
                                                  match t with 
                                                  | [] -> it
                                                  | { address= a; insts= i }::t -> { addressi = a; inst_type = judge_inst_type i ls }::(f t) 
                                                in f is

let print_info_inst_type_list stm = List.iter (fun r -> print_string (string_of_int r.addressi ^ "\t" ^ inst_type_to_string r.inst_type ^ "\n")) (make_info_inst_type_list stm)

(* アドレス等を同時に表示 *)
let print_record2 stm = let (_, is) = make_record stm in
                        let it = make_info_inst_type_list stm in
                        let rec f is it =
                          match (is, it) with
                          |(h_is::t_is, h_it::t_it) -> print_string ("//" ^ string_of_int h_it.addressi ^ "\t" ^ inst_type_to_string h_it.inst_type ^ "\t");
                                                       print_string (inst_type_to_num h_it.inst_type ^ "\t");
                                                       print_string (inst_type_to_8bit1 h_it.inst_type ^ "\t");
                                                       print_string (inst_to_string2 h_is.insts ^ "\n");
                                                       f t_is t_it
                          | _ -> print_string "//\t\t\t\t\t\t\t\t\t\tEND\n"
                        in f is it

(* バイナリとコメントで元の命令を表示 *)
let print_bin stm = let (_, is) = make_record stm in
                        let it = make_info_inst_type_list stm in
                        let rec f is it =
                          match (is, it) with
                          |(h_is::t_is, h_it::t_it) -> print_string (inst_type_to_8bit2 h_it.inst_type);
                                                       print_string ("\t//" ^ inst_to_string3 h_is.insts ^ "\n");
                                                       f t_is t_it
                          | _ -> print_string "\n"
                        in f is it