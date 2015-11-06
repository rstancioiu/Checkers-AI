/** ------------------------------------------------
					Test module
------------------------------------------------  */

:-  module(test,[test_set/0,
				 test_get2D/0,
				 test_set2D/0,
				 test_move/0,
				 test_eat/0,
				 test_paths/0,
				 test_possible/0,
				 test_skills/0,
				 test_check/0,
	]).

:- use_module(utility).

% --------- set test -------- %
test_set_data([0,1,2]).
test_set_result([0,3,2]).
test_set :-
	test_set_data(L1),
	test_set_result(L2),
	utility:set(L1,1,3,L2).

% --------- get2D test -------- %
test_get2D_data([[0,36,2],[55,2,9]]).
test_get2D_result(55).
test_get2D :-
	test_get2D_data(L1),
	test_get2D_result(X),
	utility:get2D(L1,0,1,X).

% --------- set2D test -------- %
test_set2D_data([[0,2],[55,2,9],[0]]).
test_set2D_result([[0,2],[55,2,9],[99]]).
test_set2D :-
	test_set2D_data(L1),
	test_set2D_result(L2),
	utility:set2D(L1,0,2,99,L2).

% --------- move test -------- %
test_move_data([[1,0],[0,0]]).
test_move_result([[0,0],[0,1]]).
test_move :-
	test_move_data(B1),
	test_move_result(B2),
	utility:move(B1,0,0,1,1,B2).

% --------- eat test -------- %
test_eat_data([[1,0,0],[0,2,0],[0,0,0]]).
test_eat_result([[0,0,0],[0,0,0],[0,0,1]]).
test_eat :-
	test_eat_data(B1),
	test_eat_result(B2),
	utility:eat(B1,0,0,2,2,1,1,B2).

% ------- paths test ---- %
test_paths_data([[1,0,0,0,0,0,0,0,0,0],
			     [0,0,0,0,0,0,0,0,0,0],
			     [0,0,0,0,0,0,0,0,0,0],
			     [0,0,0,1,0,0,0,0,0,0],
			     [0,0,0,0,2,0,0,0,0,0],
			     [0,0,0,0,0,0,0,0,0,0],
			     [0,0,0,0,0,0,0,0,0,0],
			     [0,0,0,0,0,0,0,1,0,0],
			     [0,0,0,0,0,0,0,0,0,0],
			     [0,0,0,0,0,0,0,0,0,0]]).
test_paths :-
	test_paths_data(B),
	%Empty path
	utility:empty_path(B,0,0,2,2),
	%Empty path fails with obstacles
	not(utility:empty_path(B,0,0,5,5)),
	%Valid path
	utility:valid_path(B,3,3,6,6,4,4,1),
	%Valid path fails if empty
	not(utility:valid_path(B,0,0,2,2,1,1,1)),
	%Valid path fails with ending obstacle
	not(utility:valid_path(B,3,3,7,7,4,4,1)).

% ----- possible test ---- %
test_possible_data([[0,0,0,0,0,0,0,0,0,0],
			        [0,1,0,0,0,0,0,0,0,0],
			        [0,0,0,0,0,0,0,0,0,0],
			        [0,0,0,1,0,0,0,0,0,0],
			        [0,0,0,0,2,0,0,0,0,0],
			        [0,0,0,0,0,0,0,0,0,0],
			        [0,0,0,0,0,0,2,0,0,0],
			        [0,0,0,0,0,0,0,0,0,0],
			        [0,1,0,0,0,0,0,0,0,0],
			        [2,0,2,0,0,0,0,0,0,0]]).
test_possible_result([
	[1,1,[[0,2]],[]],
	[1,1,[[2,2]],[]],
	[3,3,[[2,4]],[]],
	[3,3,[[5,5]],[[4,4]]],
	[3,3,[[5,5],[7,7]],[[4,4],[6,6]]]
	]).

test_possible :-
	test_possible_data(B),
	test_possible_result(L3),
	findall([PX,PY,L1,L2],possible(B,1,PX,PY,L1,L2,0),L1),
	sort(L1,L2),
	L2=L3.

% ----- select_kills test ---- %
test_skills_data([
	[1,1,[[0,2]],[]],
	[1,1,[[2,2]],[]],
	[3,3,[[2,4]],[]],
	[3,3,[[5,5]],[[4,4]]],
	[3,3,[[5,5],[7,7]],[[4,4],[6,6]]]
	]).

test_skills_result([
	[3,3,[[5,5],[7,7]],[[4,4],[6,6]]]
	]).

test_skills :-
	test_skills_data(L1),
	test_skills_result(L3),
	select_kills(L1,L2),!,
	L2=L3.

% ---- game end test ----- %
test_check_board1([[0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0]]).

test_check_board2([[0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,1,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,3,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0],
	       		   [0,0,0,0,0,0,0,0,0,0]]).

test_check :-
	test_check_board1(B1),
	test_check_board2(B2),
	check_win(B1,0),
	check_win(B1,1),
	check_win(B2,1),
	not(check_win(B2,0)).
