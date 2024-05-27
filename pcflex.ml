# 1 "pcflex.mll"
 
 open Pcfparse ;;
  exception Eoi ;;

(* Emprunt� de l'analyseur lexical du compilateur OCaml *)
(* To buffer string literals *)

let initial_string_buffer = Bytes.create 256;;
  let string_buff = ref initial_string_buffer;;
  let string_index = ref 0;;

let reset_string_buffer () =
  string_buff := initial_string_buffer;
  string_index := 0;;

let store_string_char c =
  if !string_index >= Bytes.length (!string_buff) then begin
    let new_buff = Bytes.create (Bytes.length (!string_buff) * 2) in
    Bytes.blit (!string_buff) 0 new_buff 0 (Bytes.length (!string_buff));
    string_buff := new_buff
  end;
  Bytes.unsafe_set (!string_buff) (!string_index) c;
  incr string_index;;

let get_stored_string () =
  let s = Bytes.to_string (Bytes.sub (!string_buff) 0 (!string_index)) in
  string_buff := initial_string_buffer;
  s;;

(* To translate escape sequences *)

let char_for_backslash c = match c with
| 'n' -> '\010'
| 'r' -> '\013'
| 'b' -> '\008'
| 't' -> '\009'
| c   -> c

let char_for_decimal_code lexbuf i =
  let c = 100 * (Char.code(Lexing.lexeme_char lexbuf i) - 48) +
      10 * (Char.code(Lexing.lexeme_char lexbuf (i+1)) - 48) +
                  (Char.code(Lexing.lexeme_char lexbuf (i+2)) - 48) in
  if (c < 0 || c > 255)
  then raise (Failure ("Illegal_escape: " ^ (Lexing.lexeme lexbuf)))
  else Char.chr c;;

let char_for_hexadecimal_code lexbuf i =
  let d1 = Char.code (Lexing.lexeme_char lexbuf i) in
  let val1 = if d1 >= 97 then d1 - 87
  else if d1 >= 65 then d1 - 55
  else d1 - 48
  in
  let d2 = Char.code (Lexing.lexeme_char lexbuf (i+1)) in
  let val2 = if d2 >= 97 then d2 - 87
  else if d2 >= 65 then d2 - 55
  else d2 - 48
  in
  Char.chr (val1 * 16 + val2);;

exception LexError of (Lexing.position * Lexing.position) ;;
let line_number = ref 0 ;;

let incr_line_number lexbuf =
  let pos = lexbuf.Lexing.lex_curr_p in
  lexbuf.Lexing.lex_curr_p <- { pos with
    Lexing.pos_lnum = pos.Lexing.pos_lnum + 1 ;
    Lexing.pos_bol = pos.Lexing.pos_cnum }

# 71 "pcflex.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base =
   "\000\000\245\255\246\255\249\255\001\000\250\255\251\255\252\255\
    \078\000\160\000\238\000\255\255\253\255\247\255\095\001\248\255\
    \249\255\002\000\250\255\082\001\255\255\251\255\116\001\092\001\
    \254\255\102\001\253\255\155\001\252\255\126\000\253\255\254\255\
    \255\255\127\000\253\255\254\255\011\000\255\255\128\000\254\255\
    \004\000\255\255";
  Lexing.lex_backtrk =
   "\255\255\255\255\255\255\255\255\005\000\255\255\255\255\255\255\
    \001\000\001\000\001\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\005\000\255\255\007\000\255\255\255\255\004\000\004\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\001\000\255\255\255\255\255\255\
    \000\000\255\255";
  Lexing.lex_default =
   "\001\000\000\000\000\000\000\000\255\255\000\000\000\000\000\000\
    \255\255\255\255\255\255\000\000\000\000\000\000\015\000\000\000\
    \000\000\255\255\000\000\021\000\000\000\000\000\255\255\255\255\
    \000\000\255\255\000\000\255\255\000\000\031\000\000\000\000\000\
    \000\000\035\000\000\000\000\000\255\255\000\000\039\000\000\000\
    \255\255\000\000";
  Lexing.lex_trans =
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\011\000\005\000\005\000\018\000\004\000\041\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \011\000\000\000\003\000\000\000\000\000\000\000\000\000\000\000\
    \007\000\006\000\000\000\000\000\000\000\010\000\008\000\009\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\037\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\000\000\000\000\000\000\000\000\008\000\
    \000\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \032\000\000\000\041\000\000\000\000\000\040\000\000\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\036\000\000\000\000\000\000\000\008\000\000\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\000\000\013\000\000\000\000\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\000\000\000\000\000\000\000\000\008\000\
    \002\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \000\000\000\000\000\000\000\000\012\000\000\000\000\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\000\000\000\000\000\000\000\000\008\000\000\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\018\000\000\000\000\000\017\000\000\000\000\000\000\000\
    \000\000\000\000\024\000\000\000\024\000\000\000\000\000\000\000\
    \000\000\024\000\000\000\000\000\000\000\000\000\030\000\034\000\
    \255\255\020\000\023\000\023\000\023\000\023\000\023\000\023\000\
    \023\000\023\000\023\000\023\000\025\000\025\000\025\000\025\000\
    \025\000\025\000\025\000\025\000\025\000\025\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \000\000\000\000\000\000\000\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\024\000\000\000\
    \000\000\000\000\000\000\000\000\024\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\019\000\000\000\000\000\000\000\000\000\
    \024\000\000\000\000\000\000\000\024\000\000\000\024\000\000\000\
    \000\000\000\000\022\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\000\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\255\255\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\016\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000";
  Lexing.lex_check =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\004\000\017\000\000\000\040\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\000\000\255\255\255\255\255\255\255\255\255\255\
    \000\000\000\000\255\255\255\255\255\255\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\036\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\255\255\255\255\255\255\255\255\000\000\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \029\000\255\255\038\000\255\255\255\255\038\000\255\255\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\033\000\255\255\255\255\255\255\008\000\255\255\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\255\255\009\000\255\255\255\255\009\000\009\000\009\000\
    \009\000\009\000\009\000\009\000\009\000\009\000\009\000\009\000\
    \009\000\009\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\009\000\009\000\009\000\009\000\009\000\009\000\009\000\
    \009\000\009\000\009\000\009\000\009\000\009\000\009\000\009\000\
    \009\000\009\000\009\000\009\000\009\000\009\000\009\000\009\000\
    \009\000\009\000\009\000\255\255\255\255\255\255\255\255\009\000\
    \000\000\009\000\009\000\009\000\009\000\009\000\009\000\009\000\
    \009\000\009\000\009\000\009\000\009\000\009\000\009\000\009\000\
    \009\000\009\000\009\000\009\000\009\000\009\000\009\000\009\000\
    \009\000\009\000\009\000\010\000\010\000\010\000\010\000\010\000\
    \010\000\010\000\010\000\010\000\010\000\010\000\010\000\010\000\
    \255\255\255\255\255\255\255\255\010\000\255\255\255\255\010\000\
    \010\000\010\000\010\000\010\000\010\000\010\000\010\000\010\000\
    \010\000\010\000\010\000\010\000\010\000\010\000\010\000\010\000\
    \010\000\010\000\010\000\010\000\010\000\010\000\010\000\010\000\
    \010\000\255\255\255\255\255\255\255\255\010\000\255\255\010\000\
    \010\000\010\000\010\000\010\000\010\000\010\000\010\000\010\000\
    \010\000\010\000\010\000\010\000\010\000\010\000\010\000\010\000\
    \010\000\010\000\010\000\010\000\010\000\010\000\010\000\010\000\
    \010\000\014\000\255\255\255\255\014\000\255\255\255\255\255\255\
    \255\255\255\255\019\000\255\255\019\000\255\255\255\255\255\255\
    \255\255\019\000\255\255\255\255\255\255\255\255\029\000\033\000\
    \038\000\014\000\019\000\019\000\019\000\019\000\019\000\019\000\
    \019\000\019\000\019\000\019\000\023\000\023\000\023\000\023\000\
    \023\000\023\000\023\000\023\000\023\000\023\000\025\000\025\000\
    \025\000\025\000\025\000\025\000\025\000\025\000\025\000\025\000\
    \255\255\255\255\255\255\255\255\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\019\000\255\255\
    \255\255\255\255\255\255\255\255\019\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\014\000\255\255\255\255\255\255\255\255\
    \019\000\255\255\255\255\255\255\019\000\255\255\019\000\255\255\
    \255\255\255\255\019\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\255\255\027\000\027\000\027\000\027\000\
    \027\000\027\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\027\000\027\000\027\000\027\000\
    \027\000\027\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\019\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\014\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255";
  Lexing.lex_base_code =
   "";
  Lexing.lex_backtrk_code =
   "";
  Lexing.lex_default_code =
   "";
  Lexing.lex_trans_code =
   "";
  Lexing.lex_check_code =
   "";
  Lexing.lex_code =
   "";
}

let rec prochain_lexeme lexbuf =
   __ocaml_lex_prochain_lexeme_rec lexbuf 0
and __ocaml_lex_prochain_lexeme_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 74 "pcflex.mll"
      ( prochain_lexeme lexbuf )
# 285 "pcflex.ml"

  | 1 ->
let
# 75 "pcflex.mll"
                                                  lxm
# 291 "pcflex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 76 "pcflex.mll"
      ( match lxm with
        | "zip"          -> ZIP 
        | "copy"         -> COPY 
        | "open"         -> OPEN
        | "move"         -> MOVE 
        | "rename"       -> RENAME 
        | "duplicate"    -> DUPLICATE 
        | "delete"       -> DELETE 
        | "in"           -> IN
        | "to"           -> TO
        | "ls"           -> LS
        | "undo"         -> UNDO
        | "and"          -> AND
        | "create"       -> CREATE
        | "creation"     -> CREATION
        | "modification" -> MODIFICATION
        | "size"         -> SIZE
        | "path"         -> PATH
        | "exit"         -> EXIT
        | _              -> IDENT(lxm)
      )
# 317 "pcflex.ml"

  | 2 ->
# 99 "pcflex.mll"
          ( ARROW )
# 322 "pcflex.ml"

  | 3 ->
# 100 "pcflex.mll"
          ( LPAR )
# 327 "pcflex.ml"

  | 4 ->
# 101 "pcflex.mll"
          ( RPAR )
# 332 "pcflex.ml"

  | 5 ->
# 102 "pcflex.mll"
              ( SEMISEMI )
# 337 "pcflex.ml"

  | 6 ->
# 103 "pcflex.mll"
          ( reset_string_buffer();
            in_string lexbuf;
            STRING (get_stored_string()) )
# 344 "pcflex.ml"

  | 7 ->
# 106 "pcflex.mll"
                 ( in_cpp_comment lexbuf )
# 349 "pcflex.ml"

  | 8 ->
# 107 "pcflex.mll"
                 ( in_c_comment lexbuf )
# 354 "pcflex.ml"

  | 9 ->
# 108 "pcflex.mll"
                 ( EOF )
# 359 "pcflex.ml"

  | 10 ->
# 109 "pcflex.mll"
          ( raise (LexError (lexbuf.Lexing.lex_start_p,
                             lexbuf.Lexing.lex_curr_p)) )
# 365 "pcflex.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_prochain_lexeme_rec lexbuf __ocaml_lex_state

and in_string lexbuf =
   __ocaml_lex_in_string_rec lexbuf 14
and __ocaml_lex_in_string_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 114 "pcflex.mll"
      ( () )
# 377 "pcflex.ml"

  | 1 ->
# 116 "pcflex.mll"
      ( store_string_char(char_for_backslash(Lexing.lexeme_char lexbuf 1));
        in_string lexbuf )
# 383 "pcflex.ml"

  | 2 ->
# 119 "pcflex.mll"
      ( store_string_char(char_for_decimal_code lexbuf 1);
        in_string lexbuf )
# 389 "pcflex.ml"

  | 3 ->
# 122 "pcflex.mll"
      ( store_string_char(char_for_hexadecimal_code lexbuf 2);
         in_string lexbuf )
# 395 "pcflex.ml"

  | 4 ->
let
# 124 "pcflex.mll"
              chars
# 401 "pcflex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos (lexbuf.Lexing.lex_start_pos + 2) in
# 125 "pcflex.mll"
      ( skip_to_eol lexbuf; raise (Failure("Illegal escape: " ^ chars)) )
# 405 "pcflex.ml"

  | 5 ->
let
# 126 "pcflex.mll"
               s
# 411 "pcflex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 127 "pcflex.mll"
      ( for i = 0 to String.length s - 1 do
          store_string_char s.[i];
        done;
        in_string lexbuf
      )
# 419 "pcflex.ml"

  | 6 ->
# 133 "pcflex.mll"
      ( raise Eoi )
# 424 "pcflex.ml"

  | 7 ->
let
# 134 "pcflex.mll"
         c
# 430 "pcflex.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 135 "pcflex.mll"
      ( store_string_char c; in_string lexbuf )
# 434 "pcflex.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_in_string_rec lexbuf __ocaml_lex_state

and in_cpp_comment lexbuf =
   __ocaml_lex_in_cpp_comment_rec lexbuf 29
and __ocaml_lex_in_cpp_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 138 "pcflex.mll"
         ( prochain_lexeme lexbuf )
# 446 "pcflex.ml"

  | 1 ->
# 139 "pcflex.mll"
         ( in_cpp_comment lexbuf )
# 451 "pcflex.ml"

  | 2 ->
# 140 "pcflex.mll"
         ( raise Eoi )
# 456 "pcflex.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_in_cpp_comment_rec lexbuf __ocaml_lex_state

and in_c_comment lexbuf =
   __ocaml_lex_in_c_comment_rec lexbuf 33
and __ocaml_lex_in_c_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 143 "pcflex.mll"
         ( prochain_lexeme lexbuf )
# 468 "pcflex.ml"

  | 1 ->
# 144 "pcflex.mll"
         ( in_c_comment lexbuf )
# 473 "pcflex.ml"

  | 2 ->
# 145 "pcflex.mll"
         ( raise Eoi )
# 478 "pcflex.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_in_c_comment_rec lexbuf __ocaml_lex_state

and skip_to_eol lexbuf =
   __ocaml_lex_skip_to_eol_rec lexbuf 38
and __ocaml_lex_skip_to_eol_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 148 "pcflex.mll"
            ( () )
# 490 "pcflex.ml"

  | 1 ->
# 149 "pcflex.mll"
            ( skip_to_eol lexbuf )
# 495 "pcflex.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_skip_to_eol_rec lexbuf __ocaml_lex_state

;;

