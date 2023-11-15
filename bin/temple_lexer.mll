{
    open Temple_parser
    exception Eof
}

let label = (['a'-'z']|['A'-'Z'])+['0'-'9']*
let num = ['0'-'9']['0'-'9']
let setin = ['S''s']['E''e']['T''t']['I''i']['N''n']
let setil = ['S''s']['E''e']['T''t']['I''i']['L''l']
let move = ['M''m']['O''o']['V''v']['E''e']
let add = ['A''a']['D''d']['D''d']
let nor = ['N''n']['O''o']['R''r']
let jl = ['J''j']['L''l']
let sd = ['S''s']['D''d']
let ld = ['L''l']['D''d']
 
rule token = parse
  | "$m" num as str { REG str }
  | num as vl { NUM (int_of_string(vl)) }
  | label as str { LABEL str }
  | setin { SETIN }
  | setil { SETIL }
  | move { MOVE }
  | add { ADD }
  | nor { NOR }
  | jl { JL }
  | sd { SD }
  | ld { LD }
  | [' ' '\t'] { token lexbuf }
  | eof { raise Eof }