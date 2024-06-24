{
    open Temple_parser
}

let label = (['a'-'z']|['A'-'Z']|['_'])+['0'-'9']*
let num = ['0'-'9']['0'-'9']*
let seti = ['S''s']['E''e']['T''t']['I''i']
let move = ['M''m']['O''o']['V''v']['E''e']
let add = ['A''a']['D''d']['D''d']
let nor = ['N''n']['O''o']['R''r']
let jl = ['J''j']['L''l']
let sd = ['S''s']['D''d']
let ld = ['L''l']['D''d']
let srl = ['S''s']['R''r']['L''l']
let comment = ['/']['/']_*['\n']
 
rule token = parse
  | seti { SETI }
  | move { MOVE }
  | add { ADD }
  | nor { NOR }
  | jl { JL }
  | sd { SD }
  | ld { LD }
  | srl { SRL }
  | label as str { LABEL (String.uppercase_ascii str) }
  | "$m" num as str { REG str }
  | num as vl { NUM (int_of_string vl) }
  | ":" { COLON }
  | [' ' '\t' '\n' '\r'] { token lexbuf }
  | comment { token lexbuf }
  | eof { EOF }