/** ------------------------------------------------
				Balanced IA module
------------------------------------------------  */

:-  module(iabalanced,[play_heuristique/2]).
:-  use_module(utility).

%Give a score to a single piece based on the player
piece_score(P,UV1,V1) :-
	(UV1==0 ->
		V1 is 0
		;
		TMP is UV1 mod 2,
		(TMP==P ->
			V1 is 1
			;
			V1 is -1
		)
	).

%End condition
sum_connexe(_,L,SCORE,C,SOMCUR) :-
	C>0,
	length(L,C),
	SCORE=SOMCUR.

%Get evaluations
sum_connexe(PL,L,SCORE,C,SOMCUR) :-
	board(B),
	nth0(C, L, P),
	nth0(0, P, X),
	nth0(1, P, Y),
	X2 is X-1,
	X3 is X+1,
	Y2 is Y-1,
	Y3 is Y+1,
	(X>0 ->
		(Y>0 ->
			utility:get2D(B,X2,Y2,UV1),
			piece_score(PL,UV1,V1)
			;
			V1 is 0
		),
		(Y<9 ->
			utility:get2D(B,X2,Y3,UV2),
			piece_score(PL,UV2,V2)
			;
			V2 is 0
		)
		;
		V1 is 0,
		V2 is 0
	),
	(X<9 ->
		X3 is X+1,
		(Y>0 ->
			utility:get2D(B,X3,Y2,UV3),
			piece_score(PL,UV3,V3)
			;
			V3 is 0
		),
		(Y<9 ->
			utility:get2D(B,X3,Y3,UV4),
			piece_score(PL,UV4,V4)
			;
			V4 is 0
		)
		;
		V3 is 0,
		V4 is 0
	),
	INC is V1+V2+V3+V4+SOMCUR,
	C2 is C+1,
	sum_connexe(PL,L,SCORE,C2,INC).

evaluate(P,B,SCORE) :-
	findall([X,Y],owned_by(B,P,X,Y),L1),
	%Chosen method : keep pawns together
	sum_connexe(P,L1,SCORE,0,0).

%End condition
max_score(_,MOVES,MAX,C,FINALMAX) :-
	C>0,
	length(MOVES,C),
	FINALMAX=MAX.

%Get evaluations
max_score(P,MOVES,MAX,C,FINALMAX) :-
	nth0(C, MOVES, M),
	board(B),
	make_move(B,M,B2,0),
	evaluate(P,B2,SCORE),
	NEWMAX is max(MAX,SCORE),
	NEWC is C+1,
	max_score(P,MOVES,NEWMAX,NEWC,FINALMAX).

%Check if a move has the best score
is_max_score(P,M,LMOVES,MAX) :-
	board(B),
	member(M,LMOVES),
	make_move(B,M,B2,0),
	evaluate(P,B2,SCORE),
	SCORE >= MAX.

%Take a list of moves and return best moves
select_best(P,LMOVES,NEWMOVES) :-
	max_score(P,LMOVES,-9999,0,FINALMAX),
	findall(M,is_max_score(P,M,LMOVES,FINALMAX),NEWMOVES).

%Random member polyfill
rand_member(A, LIST) :-
	length(LIST, LEN),
	X is random(LEN),
	nth0(X, LIST, A).

%Plays balanced move for player P
play_heuristique(P,MOVE) :-
	board(B),
	findall([PX,PY,L1,L2],possible(B,P,PX,PY,L1,L2,0),LMOVES),
	select_kills(LMOVES,NEWMOVES),
	select_best(P,NEWMOVES,FINALMOVES),
	rand_member(MOVE,FINALMOVES),
	make_move(B,MOVE,NEWB,0),
	retract(board(_)),
	assert(board(NEWB)),!.