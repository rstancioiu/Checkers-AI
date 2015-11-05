/** ------------------------------------------------
				Random IA module
------------------------------------------------  */

:-  module(iarandom,[play_random/2]).
:-  use_module(utility).

%Random member polyfill
rand_member(A, LIST) :-
	length(LIST, LEN),
	X is random(LEN),
	nth0(X, LIST, A).

%Plays random move for player P
play_random(P,MOVE) :-
	board(B),
	findall([PX,PY,L1,L2],possible(B,P,PX,PY,L1,L2,0),LMOVES),
	select_kills(LMOVES,NEWMOVES),
	rand_member(MOVE,NEWMOVES),
	make_move(B,MOVE,NEWB,0),
	retract(board(_)),
	assert(board(NEWB)),!.