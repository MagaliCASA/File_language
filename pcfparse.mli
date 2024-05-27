type token =
  | FLOAT of (
# 5 "pcfparse.mly"
        float
# 6 "pcfparse.mli"
)
  | IDENT of (
# 6 "pcfparse.mly"
        string
# 11 "pcfparse.mli"
)
  | TRUE
  | FALSE
  | STRING of (
# 8 "pcfparse.mly"
        string
# 18 "pcfparse.mli"
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

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Pcfast.expr
