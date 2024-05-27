open Sys;;
open Pcfast ;;

let check_file_or_directory path =
  if Sys.file_exists path then
    if Sys.is_directory path then
      "dossier"
    else
      "fichier"
  else
    failwith "Le chemin spécifié n'existe pas"
;;

let format_timestamp timestamp =
  let tm = Unix.localtime timestamp in
  let year = 1900 + tm.tm_year in
  let month = tm.tm_mon + 1 in
  let day = tm.tm_mday in
  let hour = tm.tm_hour in
  let minute = tm.tm_min in
  let second = tm.tm_sec in
  Printf.sprintf "%04d-%02d-%02d %02d:%02d:%02d" year month day hour minute second
;;

let replace_extension_with_zip path =
  let rec last_element = function
    | [] -> ""
    | [x] -> x
    | _ :: t -> last_element t
  in
  let split_path = String.split_on_char '/' path in
  let file_name = last_element split_path in
  let extension =
    match String.split_on_char '.' file_name with
    | [_] -> "" (* Pas d'extension *)
    | [_; ext] -> "." ^ ext (* Extension présente *)
    | _ -> "" (* Fichier caché avec un '.' dans le nom *)
  in
  let base_name =
    if String.equal file_name "" then
      "unnamed"
    else
      String.sub file_name 0 (String.length file_name - String.length extension)
  in
  let new_extension = ".zip" in
  let new_file_name = base_name ^ new_extension in
  let directory_path =
    String.sub path 0 (String.length path - String.length file_name)
  in
  directory_path ^ new_file_name
;;

let renomer_copie path =
  let rec dernier_element = function
    | [] -> ""
    | [x] -> x
    | _ :: t -> dernier_element t
  in
  let split_path = String.split_on_char '/' path in
  let file_name = dernier_element split_path in
  let extension =
    match String.split_on_char '.' file_name with
    | [_] -> "" (* Pas d'extension *)
    | [_; ext] -> "." ^ ext (* Extension présente *)
    | _ -> "" (* Fichier caché avec un '.' dans le nom *)
  in
  let base_nom =
    if String.equal file_name "" then
      "unnamed"
    else
      String.sub file_name 0 (String.length file_name - String.length extension)
  in
  base_nom ^ "_copie" ^ extension
;;

type pcfval =
  | Floatval of float
  | Boolval of bool
  | Stringval of string
  | Funval of (pcfval -> pcfval)
  | Unitval of unit

and environment = (string * pcfval) list
;;

let string_of_any result =
  match result with
  | Floatval f -> string_of_float f (* Si le résultat est un flottant *)
  | Stringval s -> s (* Si le résultat est déjà une chaîne de caractères *)
  | Boolval b -> string_of_bool b(* Si le résultat est un booléen *) 
  | _ -> failwith "Impossible de convertir en chaîne de caractères"
;;

let rec printval = function
  | Floatval n -> Printf.printf "%f" n
  | Boolval b -> Printf.printf "%s" (if b then "T" else "F")
  | Stringval s -> Printf.printf "\"%s\"" s
  | Funval f -> Printf.printf "<fun>"
  | Unitval _ -> ()
;;

let init_env = [] ;;

let extend rho x v = (x, v) :: rho ;;

let lookup var_name rho =
  try List.assoc var_name rho
  with Not_found -> raise (Failure (Printf.sprintf "Undefined ident '%s'" var_name))
;;

let list_current_directory () =
  let current_dir = Unix.getcwd () in
  let (output, status) =
    try
      Executeur_final.exec_command_with_output "ls" [| current_dir |]
    with
    | e ->
        Printf.printf "Erreur lors de l'exécution de la commande : %s\n" (Printexc.to_string e);
        ("", Unix.WEXITED 1)
  in
  match status with
  | Unix.WEXITED 0 ->
      Printf.printf "Contenu du répertoire %s:\n%s\n" current_dir output
  | Unix.WEXITED code ->
      Printf.printf "Erreur (code de sortie %d) lors de l'exécution de la commande 'ls' sur le répertoire %s\n" code current_dir
  | Unix.WSIGNALED signal ->
      Printf.printf "Commande 'ls' terminée par le signal %d sur le répertoire %s\n" signal current_dir
  | Unix.WSTOPPED signal ->
      Printf.printf "Commande 'ls' arrêtée par le signal %d sur le répertoire %s\n" signal current_dir
;;

let rec semant e rho =
  match e with
  | EFloat n -> Floatval n
  | EBool b -> Boolval b
  | EString s -> Stringval s
  | EIdent v -> Stringval v
  | EFile_Monop (op, e) -> (
      match op with
      | "ZIP" -> Unitval (Executeur_final.exec_command (match (check_file_or_directory (string_of_any (semant e rho))) with | "fichier" -> "zip" | "dossier" -> "zip -r" | _ -> raise (Failure (Printf.sprintf "Ni fichier ni dossier"))) [replace_extension_with_zip (string_of_any (semant e rho)) ;string_of_any (semant e rho)])
      | "OPEN" -> Unitval (Executeur_final.exec_command (match (check_file_or_directory (string_of_any (semant e rho))) with | "fichier" -> "open" | "dossier" -> "cd" | _ -> raise (Failure (Printf.sprintf "Ni fichier ni dossier"))) [string_of_any (semant e rho)])
      | "DUPLICATE" -> Unitval (Executeur_final.exec_command "cp" [string_of_any (semant e rho); renomer_copie (string_of_any(semant e rho))])
      | "DELETE" -> Unitval (Executeur_final.exec_command "rm" [string_of_any (semant e rho)])
      | "CREATE" -> Unitval (Executeur_final.exec_command "touch" [string_of_any (semant e rho)])
      | "CREATION" -> Unitval (let stats = Unix.stat (string_of_any (semant e rho)) in Printf.printf "Creation time: %s\n" (format_timestamp stats.st_ctime);)
      | "MODIFICATION" -> Unitval (let stats = Unix.stat (string_of_any (semant e rho)) in Printf.printf "Modification time: %s\n" (format_timestamp stats.st_mtime);)
      | "SIZE" -> Unitval (let stats = Unix.stat (string_of_any (semant e rho)) in Printf.printf "Size: %d\n" stats.st_size;)
      | "PATH" -> Unitval (let current_dir = Unix.getcwd () in Printf.printf "Path: %s\n" (Filename.concat current_dir (string_of_any (semant e rho)));)
      | _ -> raise (Failure (Printf.sprintf "Unknown op: %s" op))
    )
  | EFile_Binop (op, e1, e2) -> (
      match op with
      | "COPY" -> Unitval (Executeur_final.exec_command "cp -R" [string_of_any (semant e1 rho); string_of_any (semant e2 rho)])
      | "MOVE" | "RENAME" -> Unitval (Executeur_final.exec_command "mv" [string_of_any (semant e1 rho); string_of_any (semant e2 rho)])
      | _ -> raise (Failure (Printf.sprintf "Invalid operands for operator: %s" op))
    )
| EAdd (arg1, op, arg2) -> (
    match op with
    | "AND" -> (
        match (arg1, arg2) with
        | (EFile_Monop (monop1, e1), EFile_Monop (monop2, e2)) ->
            let _ = Executeur_final.exec_command monop1 [string_of_any (semant e1 rho)] in
            let _ = Executeur_final.exec_command monop2 [string_of_any (semant e2 rho)] in
            Unitval ()
        | (EFile_Monop (monop1, e1), EFile_Binop (binop2, e2, e3)) ->
            let _ = Executeur_final.exec_command monop1 [string_of_any (semant e1 rho)] in
            let _ = Executeur_final.exec_command binop2 [string_of_any (semant e2 rho); string_of_any (semant e3 rho)] in
            Unitval ()
        | (EFile_Binop (binop1, e1, e2), EFile_Monop (monop2, e3)) ->
            let _ = Executeur_final.exec_command binop1 [string_of_any (semant e1 rho); string_of_any (semant e2 rho)] in
            let _ = Executeur_final.exec_command monop2 [string_of_any (semant e3 rho)] in
            Unitval ()
        | (EFile_Binop (binop1, e1, e2), EFile_Binop (binop2, e3, e4)) ->
            let _ = Executeur_final.exec_command binop1 [string_of_any (semant e1 rho); string_of_any (semant e2 rho)] in
            let _ = Executeur_final.exec_command binop2 [string_of_any (semant e3 rho); string_of_any (semant e4 rho)] in
            Unitval ()
        | _ -> raise (Failure "Invalid arguments for AND operation")
      )
    | _ -> raise (Failure (Printf.sprintf "Unknown op: %s" op))
)
  | EOp op -> (
    match op with
    | "LS" -> Unitval (list_current_directory ())
    | _ -> raise (Failure "Invalid arguments for operation")
  )
;;

let eval e = semant e init_env ;;