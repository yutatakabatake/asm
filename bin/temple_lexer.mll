{
    open Temple_parser
}

let label = (['a'-'z']|['A'-'Z'])+['0'-'9']*
let num = ['0'-'9']['0'-'9']*
let setin = ['S''s']['E''e']['T''t']['I''i']['N''n']
let setil = ['S''s']['E''e']['T''t']['I''i']['L''l']
let move = ['M''m']['O''o']['V''v']['E''e']
let add = ['A''a']['D''d']['D''d']
let nor = ['N''n']['O''o']['R''r']
let jl = ['J''j']['L''l']
let sd = ['S''s']['D''d']
let ld = ['L''l']['D''d']
 
rule token = parse
  | setin { print_string ("setin: " ^Lexing.lexeme lexbuf) ; SETIN }
  | setil { print_string ("setil: " ^Lexing.lexeme lexbuf) ; SETIL}
  | move { print_string ("move: " ^Lexing.lexeme lexbuf) ; MOVE }
  | add { print_string ("add: " ^Lexing.lexeme lexbuf) ; ADD }
  | nor { print_string ("nor: " ^Lexing.lexeme lexbuf) ; NOR}
  | jl { print_string ("jl: " ^Lexing.lexeme lexbuf) ; JL }
  | sd { print_string ("sd: " ^Lexing.lexeme lexbuf) ; SD }
  | ld {print_string ("ld: " ^Lexing.lexeme lexbuf) ; LD }
  | label as str { print_string ("label: " ^Lexing.lexeme lexbuf) ; LABEL str }
  | "$m" num as str { print_string ("reg: " ^ Lexing.lexeme lexbuf) ; REG str}
  | num as vl{ print_string ("num: " ^Lexing.lexeme lexbuf) ; NUM (int_of_string vl) }
  | [' ' '\t' '\n' '\r'] { token lexbuf }
  | eof { EOF }