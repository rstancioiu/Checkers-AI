%Initialize board
:- dynamic board/1.
 board([[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,1,0,1,0,0,0],
		[0,0,0,0,0,2,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0]]).

%Show current board state
game :-
	board(B),
	show_board(B).

%Functions needed to print the board state
show_board([L1,L2,L3,L4,L5,L6,L7,L8,L9,L10]) :-
	show_line(L1),nl,show_line(L2),nl,show_line(L3),nl,show_line(L4),nl,show_line(L5),nl,show_line(L6),nl,show_line(L7),nl,show_line(L8),nl,show_line(L9),nl,show_line(L10),nl.
	
show_line([L1,L2,L3,L4,L5,L6,L7,L8,L9,L10]) :-
	write(L1),write(L2),write(L3),write(L4),write(L5),write(L6),write(L7),write(L8),write(L9),write(L10).
	
%set(Array, Indice, New element, New array ?)
set([_|T], 0, X, [X|T]) :- !.
set([H|T], I, X, [H|R]):- I > 0, NI is I-1, set(T, NI, X, R).

%get2D(2DArray, IndiceX, IndiceY, Value ?)
get2D(B,X,Y,VAL) :-
	nth0(Y, B, LINE),
	nth0(X, LINE, VAL).
	
%set2D(2DArray, IndiceX, IndiceY, New Element, New 2DArray ?)
set2D(B,X,Y,VAL,B2) :-
	nth0(Y, B, LINE),
	set(LINE, X, VAL, LINE2),
	set(B, Y, LINE2, B2).

%Reminder : how to actually update board
%	retract(board(_)),
%	assert(board(NEWB)),

%Turn pawn into queen
check_queen(B,X,Y,NEWB) :-
	get2D(B,X,Y,VAL),
	(((Y==0, VAL==2); (Y==9, VAL==1)) ->
		VAL2 is VAL+2,
		set2D(B,X,Y,VAL2,NEWB)
	;
	NEWB=B
).

move(B,OLDX,OLDY,X,Y,NEWB) :-
	%Backup old value, and set it to 0
	get2D(B,OLDX,OLDY,VAL),
	set2D(B,OLDX,OLDY,0,B2),
	%Set the value at new position
	set2D(B2,X,Y,VAL,B3),
	%Turn into queen if necessary
	check_queen(B3,X,Y,NEWB).

eat(B,OLDX,OLDY,X,Y,EX,EY,NEWB) :-
	%Kill ennemy
	set2D(B,EX,EY,0,B2),
	%Backup old value, and set it to 0
	get2D(B2,OLDX,OLDY,VAL),
	set2D(B2,OLDX,OLDY,0,B3),
	%Set the value at new position
	set2D(B3,X,Y,VAL,B4),
	%Turn into queen if necessary
	check_queen(B4,X,Y,NEWB).

%End condition
make_move(B,MOVE,B,C) :-
	nth0(2,MOVE,POS),
	C>0,
	length(POS,C),!.

%Use a move given by an IA to update the board
make_move(B,MOVE,NEWB,C) :-
	(C>0 ->
		PREVIOUS is C-1,
		nth0(PREVIOUS,POS,POSTMP),
		nth0(0,POSTMP,X),
		nth0(1,POSTMP,Y)
		;
		nth0(0,MOVE,X),
		nth0(1,MOVE,Y)
	),
	nth0(2,MOVE,POS),
	nth0(3,MOVE,KILLED),
	length(KILLED,NB),
	nth0(C,POS,POSI),
	(NB > 0 ->
		nth0(0,POSI,NEWX),
		nth0(1,POSI,NEWY),
		nth0(C,KILLED,KILLEDI),
		nth0(0,KILLEDI,EX),
		nth0(1,KILLEDI,EY),
		eat(B,X,Y,NEWX,NEWY,EX,EY,B2),
		C2 is C+1,
		make_move(B2,MOVE,NEWB,C2)
		;
		nth0(0,POSI,NEWX),
		nth0(1,POSI,NEWY),
		move(B,X,Y,NEWX,NEWY,NEWB)
	).
	
%Check empty path
empty_path(_,X,Y,X,Y) :- !.
empty_path(B,OLDX,OLDY,X,Y) :-
	TX is OLDX+sign(X-OLDX),
	TY is OLDY+sign(Y-OLDY),
	get2D(B,TX,TY,VAL),
	VAL==0,
	empty_path(B,TX,TY,X,Y).
	
%Find unique ennemy on path
valid_path(B,OLDX,OLDY,X,Y,EX,EY,OLDVAL) :-
	TX is OLDX+sign(X-OLDX),
	TX \= X,
	TY is OLDY+sign(Y-OLDY),
	get2D(B,TX,TY,TVAL),
	(TVAL==0 -> %if empty, recursive call
		valid_path(B,TX,TY,X,Y,EX,EY,OLDVAL)
		; % else, in case of ennemy, look for empty path
		AVG is (OLDVAL+TVAL)/2,
		float_fractional_part(AVG)>0,
		EX is TX,
		EY is TY,
		empty_path(B,TX,TY,X,Y)
	).
	
%basic move, BACKWARDS=1 or 0, STRICT=1 or 0
is_legal_move(B,OLDX,OLDY,X,Y,DMAX,BACKWARDS,STRICT) :-
	%Inside board
	between(0,9,X),
	between(0,9,Y),
	%Diagonnal move
	T is abs(X-OLDX)-abs(Y-OLDY),
	T==0,
	%Check forward only if needed and if pawn
	(BACKWARDS==0, DMAX<5 ->
		get2D(B,OLDX,OLDY,OLDVAL),
		T2 is OLDY-(2*OLDVAL-3),
		T2==Y;
		true
	),
	%Reachable destination
	(abs(X-OLDX)) =<	DMAX,
	%Empty destination
	get2D(B,X,Y,VAL),
	VAL==0,
	%Empty path for strict moves
	(STRICT==1 ->
		empty_path(B,OLDX,OLDY,X,Y);
		true
	).

%basic eat pawn
is_legal_eat(B,OLDX,OLDY,X,Y,DMAX,EX,EY) :-
	DMAX==1,
	is_legal_move(B,OLDX,OLDY,X,Y,DMAX+1,1,0),
	get2D(B,OLDX,OLDY,OLDVAL),
	EX is (OLDX+X)/2,
	EY is (OLDY+Y)/2,
	integer(EX),
	integer(EY),
	get2D(B,EX,EY,TVAL),
	TVAL>0,
  	AVG is (OLDVAL+TVAL)/2,
	float_fractional_part(AVG)>0.
	
%basic eat queen
is_legal_eat(B,OLDX,OLDY,X,Y,DMAX,EX,EY) :-
	DMAX>1,
	is_legal_move(B,OLDX,OLDY,X,Y,DMAX,1,0),
	get2D(B,OLDX,OLDY,OLDVAL),
	valid_path(B,OLDX,OLDY,X,Y,EX,EY,OLDVAL).

%POSSIBLE : list all possible choices for entity @coords OLDX,OLDY
%L1 contains positions and L2 ennemies killed on the path
%CURSOR is used to browse L1 and L2

%Possible move if it's a legal move and it's the only option of the list
possible(B,P,OLDX,OLDY,L1,L2,0) :-
	length(L1,1),
	length(L2,0),
	get2D(L1,0,0,X),
	get2D(L1,1,0,Y),
	nth0(0, L1, LINE),
	length(LINE,2),
	get2D(B,OLDX,OLDY,VAL),
	VAL>0,
	TMP is VAL mod 2,
	TMP==P,
	(VAL>2 ->
		DMAX is 10,
		BACKWARDS is 1;
		DMAX is 1,
		BACKWARDS is 0
	),
	is_legal_move(B,OLDX,OLDY,X,Y,DMAX,BACKWARDS,0).

%Possible eats if they're all legals and follow each other
possible(B,P,OLDX,OLDY,L1,L2,CURSOR) :-
	possible_eat(B,P,OLDX,OLDY,L1,L2,CURSOR).

%End condition
possible_eat(_,_,_,_,L1,L2,C) :-
	C>0,
	length(L1,C),
	length(L2,C),!.

possible_eat(B,P,OLDX,OLDY,L1,L2,CURSOR) :-
	get2D(B,OLDX,OLDY,VAL),
	VAL>0,
	TMP is VAL mod 2,
	TMP==P,
	(VAL>2 ->
		DMAX is 10;
		DMAX is 1
	),
	is_legal_eat(B,OLDX,OLDY,X,Y,DMAX,EX,EY),
	get2D(L1,0,CURSOR,X),
	get2D(L1,1,CURSOR,Y),
	nth0(CURSOR, L1, LINE),
	length(LINE,2),
	get2D(L2,0,CURSOR,EX),
	get2D(L2,1,CURSOR,EY),
	nth0(CURSOR, L2, LINE2),
	length(LINE2,2),
	CURSOR2 is CURSOR+1,
	eat(B,OLDX,OLDY,X,Y,EX,EY,NEWB),
	possible_eat(NEWB,P,X,Y,L1,L2,CURSOR2).

%Random member polyfill
rand_member(A, LIST) :-
	length(LIST, LEN),
	X is random(LEN),
	nth0(X, LIST, A).

%End condition
max_kills(MOVES,MAX,C,FINALMAX) :-
	C>0,
	length(MOVES,C),
	FINALMAX=MAX,!.

%Get number of kills
max_kills(MOVES,MAX,C,FINALMAX) :-
	nth0(C, MOVES, M),
	nth0(3, M, KILLS),
	length(KILLS,L),
	NEWMAX is max(MAX,L),
	NEWC is C+1,
	max_kills(MOVES,NEWMAX,NEWC,FINALMAX).

%Check if a move contains enough kills to be legal
is_max_kills(M,LMOVES,MAX) :-
	member(M,LMOVES),
	nth0(3,M,KILLS),
	length(KILLS,L),
	L >= MAX.

%Take a list of moves and return only legal moves based on "max kills" rule
select_kills(LMOVES,NEWMOVES) :-
	max_kills(LMOVES,0,0,FINALMAX),
	findall(M,is_max_kills(M,LMOVES,FINALMAX),NEWMOVES).

/** ------------------------------------------------
-----------------   RANDOM IA ----------------------
------------------------------------------------  */  
	
%Plays random move for player P
play_random(P,MOVE) :-
	board(B),
	findall([PX,PY,L1,L2],possible(B,P,PX,PY,L1,L2,0),LMOVES),
	select_kills(LMOVES,NEWMOVES),
	rand_member(MOVE,NEWMOVES),
	make_move(B,MOVE,NEWB,0),
	retract(board(_)),
	assert(board(NEWB)),!.

/** ------------------------------------------------
-----------------   USER ----------------------
------------------------------------------------  */ 

display_all_moves(P,MOVE) :-
	board(B),
	findall([PX,PY,L1,L2],possible(B,P,PX,PY,L1,L2,0),LMOVES),
	select_kills(LMOVES,MOVES),
	member(MOVE,MOVES).

user_move(_,_,_,_,_,LIST,C)  :-
	C>0,
	length(LIST,C),!.

user_move(A,SX,SY,EX,EY,LIST,C) :-
	nth0(C,LIST,MOVE),
	nth0(0,MOVE,SXP),
	nth0(1,MOVE,SYP),
	nth0(2,MOVE,L1),
	length(L1,LENP),
	LENP1 is LENP-1,
	nth0(LENP1,L1,D),
	nth0(0,D,EXP),
	nth0(1,D,EYP),
	( (SX==SXP,SY==SYP,EX==EXP,EY==EYP) -> 
		A=MOVE,!;
		C1 is C+1,
	user_move(A,SX,SY,EX,EY,LIST,C1),!
	).

make_user_move(P,SX,SY,EX,EY) :-
	board(B),
	findall([PX,PY,L1,L2],possible(B,P,PX,PY,L1,L2,0),LMOVES),
	select_kills(LMOVES,MOVES),
	user_move(MOVE,SX,SY,EX,EY,MOVES,0),
	make_move(B,MOVE,NEWB,0),
	retract(board(_)),
	assert(board(NEWB)),!.



/** ------------------------------------------------
-------------------   MIN MAX ----------------------
------------------------------------------------  */

owned_by(B,P,X,Y) :-
	get2D(B,X,Y,VAL),
	VAL>0,
	TMP is VAL mod 2,
	TMP==P.

evaluate(B,P,E) :-
	findall([X,Y],owned_by(B,P,X,Y),L),
	OTHERP is 1-P,
	findall([X,Y],owned_by(B,OTHERP,X,Y),L2),
	length(L,NBP),
	length(L2,NBOP),
	E is (NBP+(20-NBOP)).

max(X,Y,Y) :- X =< Y.
max(X,Y,X) :- X>Y.
min(X,Y,Y) :- X >= Y.
min(X,Y,X) :- X<Y.

%End condition
ia_cmp(_,MOVES,_,_,_,E,_,_,CURSOR,ECUR,_) :-
	CURSOR>0,
	length(MOVES,CURSOR),
	E=ECUR,!.

ia_cmp(B,MOVES,P,DEPTH,Dinit,E,MOVEWIN,Pinit,CURSOR,ECUR,GOAL) :-
	nth0(CURSOR,MOVES,MOVE),
	make_move(B,MOVE,B2,0),
	minimax(B2,_,DEPTH,Dinit,E2,P,Pinit),
	(call(GOAL,E2,ECUR,E2), E2\=ECUR ->
		NEWWIN is E2,
		MOVEWIN=MOVE
		;
		NEWWIN is ECUR
	),
	NEWC is CURSOR+1,
	ia_cmp(B,MOVES,P,DEPTH,Dinit,E,MOVEWIN,Pinit,NEWC,NEWWIN,GOAL).

minimax(B,MOV,DEPTH,Dinit,E,P,Pinit):-
	(DEPTH==0 ->
		evaluate(B,Pinit,E)
		;
		findall([PX,PY,L1,L2],possible(B,P,PX,PY,L1,L2,0),LMOVES),
		select_kills(LMOVES,NEWMOVES),
		P2 is 1-P,
		D2 is DEPTH-1,
		(P==Pinit ->
			ia_cmp(B,NEWMOVES,P2,D2,Dinit,E,R,Pinit,0,0,max)
			;
			ia_cmp(B,NEWMOVES,P2,D2,Dinit,E,R,Pinit,0,9999,min)
		),
		(DEPTH==Dinit ->
			MOV=R
			;
			true
		)
	).

play_minimax(P,MOVE) :-
	board(B),
	minimax(B,MOVE,1,1,_,P,P),
	make_move(B,MOVE,NEWB,0),
	retract(board(_)),
	assert(board(NEWB)),!.
