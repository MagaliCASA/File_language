type token =
  | FLOAT of (
# 5 "pcfparse.mly"
        float
# 6 "pcfparse.ml"
)
  | IDENT of (
# 6 "pcfparse.mly"
        string
# 11 "pcfparse.ml"
)
  | TRUE
  | FALSE
  | STRING of (
# 8 "pcfparse.mly"
        string
# 18 "pcfparse.ml"
)
  | ZIP
  | COPY
  | OPEN
  | MOVE
  | RENAME
  | DUPLICATE
  | DELETE
  | LS
  | UNDO
  | AND
  | CREATE
  | INFO
  | CREATION
  | MODIFICATION
  | SIZE
  | PATH
  | EXIT
  | LPAR
  | RPAR
  | SEMISEMI
  | LET
  | REC
  | IN
  | FUN
  | ARROW
  | IF
  | THEN
  | ELSE
  | TO
  | EOF

open Parsing
let _ = parse_error;;
# 2 "pcfparse.mly"
open Pcfast ;;

# 56 "pcfparse.ml"
let yytransl_const = [|
  259 (* TRUE *);
  260 (* FALSE *);
  262 (* ZIP *);
  263 (* COPY *);
  264 (* OPEN *);
  265 (* MOVE *);
  266 (* RENAME *);
  267 (* DUPLICATE *);
  268 (* DELETE *);
  269 (* LS *);
  270 (* UNDO *);
  271 (* AND *);
  272 (* CREATE *);
  273 (* INFO *);
  274 (* CREATION *);
  275 (* MODIFICATION *);
  276 (* SIZE *);
  277 (* PATH *);
  278 (* EXIT *);
  279 (* LPAR *);
  280 (* RPAR *);
  281 (* SEMISEMI *);
  282 (* LET *);
  283 (* REC *);
  284 (* IN *);
  285 (* FUN *);
  286 (* ARROW *);
  287 (* IF *);
  288 (* THEN *);
  289 (* ELSE *);
  290 (* TO *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  257 (* FLOAT *);
  258 (* IDENT *);
  261 (* STRING *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\002\000\002\000\004\000\004\000\003\000\003\000\
\003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\003\000\003\000\003\000\003\000\000\000"

let yylen = "\002\000\
\002\000\002\000\001\000\001\000\002\000\000\000\002\000\004\000\
\002\000\004\000\004\000\002\000\002\000\001\000\001\000\003\000\
\002\000\002\000\002\000\002\000\002\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\014\000\015\000\000\000\000\000\000\000\000\000\
\000\000\022\000\000\000\023\000\000\000\004\000\000\000\007\000\
\000\000\009\000\000\000\000\000\012\000\013\000\017\000\018\000\
\019\000\020\000\021\000\002\000\001\000\016\000\000\000\000\000\
\000\000\008\000\010\000\011\000"

let yydgoto = "\002\000\
\020\000\021\000\022\000\000\000"

let yysindex = "\001\000\
\254\254\000\000\242\254\001\255\011\255\013\255\019\255\020\255\
\022\255\023\255\000\000\000\000\024\255\025\255\026\255\027\255\
\028\255\000\000\254\254\000\000\006\255\000\000\030\255\000\000\
\255\254\000\000\000\255\007\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\034\255\035\255\
\036\255\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\014\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\021\000\000\000\000\000\000\000"

let yytablesize = 40
let yytable = "\003\000\
\023\000\001\000\024\000\004\000\005\000\006\000\007\000\008\000\
\009\000\010\000\011\000\012\000\025\000\013\000\026\000\014\000\
\015\000\016\000\017\000\018\000\027\000\028\000\019\000\029\000\
\030\000\031\000\032\000\033\000\034\000\035\000\037\000\038\000\
\039\000\040\000\041\000\042\000\043\000\044\000\003\000\036\000"

let yycheck = "\002\001\
\015\001\001\000\002\001\006\001\007\001\008\001\009\001\010\001\
\011\001\012\001\013\001\014\001\002\001\016\001\002\001\018\001\
\019\001\020\001\021\001\022\001\002\001\002\001\025\001\002\001\
\002\001\002\001\002\001\002\001\002\001\002\001\025\001\002\001\
\034\001\034\001\028\001\002\001\002\001\002\001\025\001\019\000"

let yynames_const = "\
  TRUE\000\
  FALSE\000\
  ZIP\000\
  COPY\000\
  OPEN\000\
  MOVE\000\
  RENAME\000\
  DUPLICATE\000\
  DELETE\000\
  LS\000\
  UNDO\000\
  AND\000\
  CREATE\000\
  INFO\000\
  CREATION\000\
  MODIFICATION\000\
  SIZE\000\
  PATH\000\
  EXIT\000\
  LPAR\000\
  RPAR\000\
  SEMISEMI\000\
  LET\000\
  REC\000\
  IN\000\
  FUN\000\
  ARROW\000\
  IF\000\
  THEN\000\
  ELSE\000\
  TO\000\
  EOF\000\
  "

let yynames_block = "\
  FLOAT\000\
  IDENT\000\
  STRING\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 20 "pcfparse.mly"
                    ( _1 )
# 201 "pcfparse.ml"
               : Pcfast.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Pcfast.expr) in
    Obj.repr(
# 21 "pcfparse.mly"
                    ( _2 )
# 208 "pcfparse.ml"
               : Pcfast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 26 "pcfparse.mly"
         ( EIdent (_1) )
# 215 "pcfparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'file_operation) in
    Obj.repr(
# 28 "pcfparse.mly"
         ( _1 )
# 222 "pcfparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'seqident) in
    Obj.repr(
# 32 "pcfparse.mly"
                  ( _1 :: _2 )
# 230 "pcfparse.ml"
               : 'seqident))
; (fun __caml_parser_env ->
    Obj.repr(
# 33 "pcfparse.mly"
                  ( [] )
# 236 "pcfparse.ml"
               : 'seqident))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 37 "pcfparse.mly"
                                  ( EFile_Monop ("ZIP", EIdent _2) )
# 243 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 38 "pcfparse.mly"
                                  ( EFile_Binop ("COPY", EIdent _2, EIdent _4) )
# 251 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 39 "pcfparse.mly"
                                  ( EFile_Monop ("OPEN", EIdent _2) )
# 258 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 40 "pcfparse.mly"
                                  ( EFile_Binop ("MOVE", EIdent _2, EIdent _4) )
# 266 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 41 "pcfparse.mly"
                                  ( EFile_Binop ("RENAME", EIdent _2, EIdent _4) )
# 274 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 42 "pcfparse.mly"
                                  ( EFile_Monop ("DUPLICATE", EIdent _2) )
# 281 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 43 "pcfparse.mly"
                                  ( EFile_Monop ("DELETE", EIdent _2) )
# 288 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    Obj.repr(
# 44 "pcfparse.mly"
                                  ( EOp "LS" )
# 294 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    Obj.repr(
# 45 "pcfparse.mly"
                                  ( EOp "UNDO" )
# 300 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 46 "pcfparse.mly"
                                  ( EAdd (EIdent _1, "AND", EIdent _3) )
# 308 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 47 "pcfparse.mly"
                                  ( EFile_Monop ("CREATE", EIdent _2) )
# 315 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 48 "pcfparse.mly"
                                  ( EFile_Monop ("CREATION", EIdent _2) )
# 322 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 49 "pcfparse.mly"
                                  ( EFile_Monop ("MODIFICATION", EIdent _2) )
# 329 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 50 "pcfparse.mly"
                                  ( EFile_Monop ("SIZE", EIdent _2) )
# 336 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 51 "pcfparse.mly"
                                  ( EFile_Monop ("PATH", EIdent _2) )
# 343 "pcfparse.ml"
               : 'file_operation))
; (fun __caml_parser_env ->
    Obj.repr(
# 52 "pcfparse.mly"
                                  ( EOp "EXIT" )
# 349 "pcfparse.ml"
               : 'file_operation))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Pcfast.expr)
