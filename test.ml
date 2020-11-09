open OUnit2
open Manual

(**  [pp_string s] pretty-prints string [s]. *)
let pp_string s = "\"" ^ s ^ "\""

(** [pp_list pp_elt lst] pretty-prints list [lst], using [pp_elt]
    to pretty-print each element of [lst]. *)
let pp_list pp_elt lst =
  let pp_elts lst =
    let rec loop n acc = function
      | [] -> acc
      | [h] -> acc ^ pp_elt h
      | h1 :: (h2 :: t as t') ->
        if n = 100 then acc ^ "..."  (* stop printing long list *)
        else loop (n + 1) (acc ^ (pp_elt h1) ^ "; ") t'
    in loop 0 "" lst
  in "[" ^ pp_elts lst ^ "]"

(* These tests demonstrate how to use [cmp_set_like_lists] and 
   [pp_list] to get helpful output from OUnit. *)
(* let cmp_demo = 
   [
    "order is irrelevant" >:: (fun _ -> 
        assert_equal ~cmp:cmp_set_like_lists ~printer:(pp_list pp_string)
          ["foo"; "bar"] ["bar"; "foo"]); *)
(* Uncomment this test to see what happens when a test case fails.
   "duplicates not allowed" >:: (fun _ -> 
    assert_equal ~cmp:cmp_set_like_lists ~printer:(pp_list pp_string)
      ["foo"; "foo"] ["foo"]);
*)


(********************************************************************
   End helper functions.
 ********************************************************************)

(* let init_todolist_test name cat_name task_name due_date priority 
    expected_output = 
   name >:: (fun _ -> 
      let expected = create_task cat_name task_name due_date 
          priority; (access_cat ()) in 
      assert_equal expected_output (expected)) *)

(* let create_task_test name cat_name task_name due_date priority 
    expected_output = 
   name >:: (fun _ -> 
      let expected = create_task cat_name task_name due_date 
          priority; (access_cat ()) in 
      assert_equal expected_output (expected)) *)

(* let create_task_test name cat_name task_name due_date priority 
    expected_output = 
   let expected = create_task cat_name task_name due_date 
      priority; to_list cat_name in
   name >:: (fun _ -> 
      assert_equal ~printer: (pp_list pp_string) expected_output expected) *)

(* let update_cat_test name cat_name expected_output = 
   name >:: (fun _ -> 
      assert_equal ~printer: (pp_list pp_string) expected_output 
        (to_list cat_name)) *)

let update_cat_test name categories cat_name expected_output = 
  name >:: (fun _ -> 
      assert_equal expected_output 
        (to_list ~cat:categories cat_name) ~printer: (pp_list pp_string)) 

(* let task1 = init_task "watch lecture" "10/28/20" 2
   let task2 = init_task "fill out OMM" "10/24/20" 1
   let task3 = init_task "do lab" "10/28/20" 2

   let test1_lst = [task1]
   let general_lst = [init_todolist "General" test1_lst] *)


(* let test2 = create_task "General" "fill out OMM" "10/24/20" 1 *)

(* let test2_lst = task2 :: test1_lst
   let general2_lst = [init_todolist "General" test2_lst]

   let test3_lst = task3 :: test2_lst
   let general3_lst = [init_todolist "General" test3_lst] *)

(* create task1 xyz
   create task2 xyz
   create task3 xyz
   all in general
*)

module CreateTask = struct
  let cat = empty_cat ()
  let task1 = create_task ~cat:cat "General" "watch lecture" "10/28/20" 2
  let task2 = create_task ~cat:cat "General" "fill out OMM" "10/24/20" 1
  let task2 = create_task ~cat:cat "General" "do lab" "10/28/20" 3

  (* adding three tasks to the same category *)
  let create_task_tests1 =
    [
      update_cat_test "Adding 3 tasks to the same category" cat "General"
        ["General"; "do lab"; "11/8/2020"; "10/28/20"; "3"; "fill out OMM"; 
         "11/8/2020"; "10/24/20"; "1"; "watch lecture"; "11/8/2020"; "10/28/20"; 
         "2"];

      (* adding two tasks to the same category *)
      (* create_task_test "adding task1 to General category" 
         "General" "watch lecture" "10/28/20" 2
         ["General"; "watch lecture"; "11/8/2020"; "10/28/20"; "2"];

         create_task_test "adding task2 to General category" 
         "General" "fill out OMM" "10/24/20" 1
         ["General"; "watch lecture"; "11/8/2020"; "10/28/20"; "2"; "fill out OMM"; "11/8/2020"; "10/24/20"; "1"]; *)

      (* create_task_test "adding task1 to General category" 
         "General" "watch lecture" "10/28/20" 2 general_lst; *)

      (* create_task_test "adding task2 to existing General category" 
         "General" "fill out OMM" "10/24/20" 1 general2_lst;

         create_task_test "adding task3 to existing General category" 
         "General" "do lab" "10/28/20" 3 general3_lst; *)
    ]
end

module SortedTest = struct

  let cat2 = empty_cat ()
  let task1 = create_task ~cat:cat2 "General" "watch lecture" "10/28/20" 2 
  let task2 = create_task ~cat:cat2 "General" "fill out OMM" "10/24/20" 1 
  let task2 = create_task ~cat:cat2 "General" "do lab" "10/28/20" 3 
  let sort = sort_list ~cat:cat2 "General"


  let sort_list_tests1 = [
    update_cat_test "Sorting General by priority" cat2 "General" 
      ["General"; "do lab"; "11/8/2020"; "10/28/20"; "3"; "watch lecture"; 
       "11/8/2020"; "10/28/20"; "2"; "fill out OMM"; "11/8/2020"; "10/24/20"; 
       "1"];
  ]

end

let to_list_test name cat_name expected_output = 
  name >:: (fun _ -> 
      assert_equal expected_output (to_list cat_name))

let to_list_tests = [
  to_list_test "General should have one task" "General" 
    ["General"; "watch lecture"; "10/28/20"; "2"];
]

let complete_task_test name t task expected_output =
  name >:: (fun _ -> assert_equal expected_output (complete_task t task))


let remove_tests =
  [

  ]

let suite =
  "test suite for Manual Mode"  >::: List.flatten [
    CreateTask.create_task_tests1;
    SortedTest.sort_list_tests1;
  ]

let _ = run_test_tt_main suite
