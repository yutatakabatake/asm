let _ = 
    let lexbuf = Lexing.from_channel stdin in
        let rlt = Temple_parser.prog Temple_lexer.token lexbuf in
            Temple_asm.print_record rlt 