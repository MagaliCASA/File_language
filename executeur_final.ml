(* Doc de la lib Unix : https://v2.ocaml.org/api/Unix.html *)
open Unix

(* Execute une commande et attend sa fin pour rendre la main. *)
let exec_command c_name args =
  match Unix.fork () with
  | 0 ->
      (* Fils, donc nouveau processus. Il doit remplacer son image par celle
         de la commande à exécuter. Le premier argument de argv[] est le nom
         de la commande elle-même. *)
      Unix.execvp c_name (Array.of_list (c_name :: args))
  | child_pid -> (
    (* Père, donc le processus original. Il doit attendre la fin de son
       fils. Ici, on attend explicitement la fin de CE fils. Si l'on voulait
       attendre la fin de n'importe quel fils (fork() multiples), on pourrait
       utiliser Unix. wait(). *)
      match Unix.waitpid [Unix.WUNTRACED] child_pid with
      | (dead_pid, Unix.WEXITED ret_code) ->
          Printf.printf "Process %d terminated normally with return code %d.\n"
            dead_pid ret_code
      | (dead_pid, Unix.WSIGNALED signal) ->
          Printf.printf "Process %d interrupted by signal %d.\n" dead_pid signal
      | (aslept_pid, Unix.WSTOPPED signal) ->
          (* A priori pas nécessaire si l'on retire le flag WUNTRACED de
             waidpid(). *)
          Printf.printf "Oops, process %d only aslept by signal %d.\n"
            aslept_pid signal
     )
;;

let exec_command_with_output cmd args =
  (* Utilisez Unix.open_process_args_in pour passer les arguments directement *)
  let in_channel = Unix.open_process_args_in cmd args in
  let buffer = Buffer.create 1024 in
  (* Lire la sortie du processus correctement *)
  (try
    while true do
      Buffer.add_channel buffer in_channel 1024
    done
  with End_of_file -> ());
  let output = Buffer.contents buffer in
  let status = Unix.close_process_in in_channel in
  (output, status)

