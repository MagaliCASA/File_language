(* Ce fichier contient la d�finition du type OCaml des arbres de
 * syntaxe abstraite du langage, ainsi qu'un imprimeur des phrases
 * du langage.
*)

type expr =
  | EFloat of float                             (* 3.5 *)
  | EString of string                           (* "hello" *)
  | EBool of bool                               (* true, false *)
  | EIdent of string                            (* nom_de_fichier ou chemin*)
  | EAdd of (expr * string * expr)              (* ex : effectuer 2 opérations *)
  | EOp of string                               (* ex : exit *)
  | EFile_Monop of (string * expr)              (* ex : copy fichier1.txt *)
  | EFile_Binop of (string * expr * expr)       (* ex : move fichier1.txt documents/premier_essai/ *)
;;

let rec print oc = function
  | EFloat n -> Printf.fprintf oc " %f " n
  | EBool b -> Printf.fprintf oc " %s " (if b then "true" else "false")
  | EIdent s -> Printf.fprintf oc " %s " s
  | EAdd (e1, op, e2) -> Printf.fprintf oc " (%a %s %a) " print e1 op print e2
  | EString s -> Printf.fprintf oc " %s " s
  | EOp op -> Printf.fprintf oc " %s " op
  | EString s -> Printf.fprintf oc " %s " s
  | EFile_Binop (op,e1,e2) ->
      Printf.fprintf oc " (%s %a %a) " op print e1 print e2
  | EFile_Monop (op,e) -> 
      Printf.fprintf oc " %s%a " op print e
;;
