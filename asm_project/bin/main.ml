let _ = 
  try
      let lexbuf = Lexing.from_channel stdin in
          while true do
              let rlt = Temple_parser.prog Temple_lexer.token lexbuf in
              Temple_asm.print_ast rlt;
              print_string "\n";
              flush stdout
          done
  with Temple_lexer.Eof -> exit 0