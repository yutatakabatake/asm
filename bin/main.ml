let _ = 
    let lexbuf = Lexing.from_channel stdin in
    try
        let rlt = Temple_parser.prog Temple_lexer.token lexbuf in
            Temple_asm.print_record2 rlt;
            Temple_asm.print_record3 rlt
    with exn ->
        begin
            print_string (Lexing.lexeme lexbuf);
            raise exn
        end