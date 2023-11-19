%token<string> REG LABEL
%token<int> NUM
%token SETIN SETIL MOVE ADD NOR JL SD LD EOF


%start prog
%type <Temple_asm.stm> prog

%%

prog: instrs EOF { print_string "PROG"; $1 }
      ;
 
instrs
      : { Temple_asm.EOP }
      | instr instrs { Temple_asm.Line ($1, $2) }
      ;
 
instr 
      : SETIN NUM { Temple_asm.SetiN $2 }
      | SETIL LABEL { Temple_asm.SetiL $2 }
      | MOVE REG { Temple_asm.Move $2 }
      | ADD REG { Temple_asm.Add $2 } 
      | NOR REG { Temple_asm.Nor $2 }
      | JL REG NUM REG { Temple_asm.Jl ($2,$3,$4) }
      | SD REG { Temple_asm.Sd $2 }
      | LD REG { Temple_asm.Ld $2 }
      ;