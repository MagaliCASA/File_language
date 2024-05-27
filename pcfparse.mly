%{
open Pcfast ;;

%}
%token <float> FLOAT
%token <string> IDENT
%token TRUE FALSE
%token <string> STRING
%token ZIP COPY OPEN MOVE RENAME DUPLICATE DELETE LS UNDO AND CREATE INFO CREATION MODIFICATION SIZE PATH EXIT
%token LPAR RPAR SEMISEMI
%token LET REC IN FUN ARROW
%token IF THEN ELSE TO IN
%token EOF

%start main
%type <Pcfast.expr> main

%%

main: expr SEMISEMI { $1 }
    | SEMISEMI main { $2 }
;

expr:
| IDENT                            
         { EIdent ($1) }
| file_operation                      
         { $1 }
;

seqident:
  IDENT seqident  { $1 :: $2 }
| /* rien */      { [] }
;

file_operation:
| ZIP IDENT                       { EFile_Monop ("ZIP", EIdent $2) }
| COPY IDENT TO IDENT             { EFile_Binop ("COPY", EIdent $2, EIdent $4) }
| OPEN IDENT                      { EFile_Monop ("OPEN", EIdent $2) }
| MOVE IDENT TO IDENT             { EFile_Binop ("MOVE", EIdent $2, EIdent $4) }
| RENAME IDENT IN IDENT           { EFile_Binop ("RENAME", EIdent $2, EIdent $4) }
| DUPLICATE IDENT                 { EFile_Monop ("DUPLICATE", EIdent $2) }
| DELETE IDENT                    { EFile_Monop ("DELETE", EIdent $2) }
| LS                              { EOp "LS" }
| UNDO                            { EOp "UNDO" }
| IDENT AND IDENT                 { EAdd (EIdent $1, "AND", EIdent $3) }
| CREATE IDENT                    { EFile_Monop ("CREATE", EIdent $2) }
| CREATION  IDENT                 { EFile_Monop ("CREATION", EIdent $2) }
| MODIFICATION IDENT              { EFile_Monop ("MODIFICATION", EIdent $2) }
| SIZE IDENT                      { EFile_Monop ("SIZE", EIdent $2) }
| PATH IDENT                      { EFile_Monop ("PATH", EIdent $2) }
| EXIT                            { EOp "EXIT" }
;
