/** ------------------------------------------------
				User functions module
------------------------------------------------  */ 

:-  module(xuser,[display_all_moves/2,
				 make_user_move/6
				]).
:-  use_module(utility).


display_all_moves(P,MOVE) :-
	board(B),
	findall([PX,PY,L1,L2],possible(B,P,PX,PY,L1,L2,0),LMOVES),
	select_kills(LMOVES,MOVES),
	member(MOVE,MOVES).

user_move(M,EX,EY,LIST) :-
	member(MOVE,LIST),
	nth0(2,MOVE,L1),
	last(L1,D),
	nth0(0,D,EXP),
	nth0(1,D,EYP),
	EX==EXP,
	EY==EYP,
	M=MOVE.

make_user_move(P,SX,SY,EX,EY,MOVE) :-
	board(B),
	findall([SX,SY,L1,L2],possible(B,P,SX,SY,L1,L2,0),LMOVES),
	select_kills(LMOVES,MOVES),
	user_move(MOVE,EX,EY,MOVES),
	make_move(B,MOVE,NEWB,0),
	retract(board(_)),
	assert(board(NEWB)),!.