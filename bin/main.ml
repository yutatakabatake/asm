let _ = 
    let lexbuf = Lexing.from_channel stdin in
    try
        let rlt = Temple_parser.prog Temple_lexer.token lexbuf in
            Temple_asm.print_bin rlt
    with exn ->
        begin
            print_string (Lexing.lexeme lexbuf);
            raise exn
        end