%Initialize board
:- dynamic board/1.
board([[0,2,0,1,0,1,0,1,0,1],
		[1,0,1,0,1,0,1,0,1,0],
		[0,1,0,1,0,1,0,1,0,1],
		[1,0,3,0,1,0,1,0,1,0],
		[0,0,0,2,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,2,0,0,0,2,0,2,0,2],
		[2,0,2,0,2,0,0,0,2,0],
		[0,1,0,2,0,2,0,2,0,2],
		[1,0,0,0,2,0,2,0,2,0]]).

%Show current board state
game :- 
	write('********************'),nl,
	write(' Prolog Checkers    '),nl,
	write('********************'),nl,
	board(B),
	show_board(B).

%Functions needed to print the board state
show_board([L1,L2,L3,L4,L5,L6,L7,L8,L9,L10]) :-
	show_line(L1),nl,show_line(L2),nl,show_line(L3),nl,show_line(L4),nl,show_line(L5),nl,show_line(L6),nl,show_line(L7),nl,show_line(L8),nl,show_line(L9),nl,show_line(L10),nl.
	
show_line([L1,L2,L3,L4,L5,L6,L7,L8,L9,L10]) :-
	write(L1),write(L2),write(L3),write(L4),write(L5),write(L6),write(L7),write(L8),write(L9),write(L10).

%Count how many times a predicate P is true
count(P,Count) :-
  findall(1,P,L),
  length(L,Count).
	
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
%	assert(board(B3)),

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
	float_fractional_part(AVG)>0,!.
	
%basic eat queen
is_legal_eat(B,OLDX,OLDY,X,Y,DMAX,EX,EY) :-
	DMAX>1,
	is_legal_move(B,OLDX,OLDY,X,Y,DMAX,1,0),
	get2D(B,OLDX,OLDY,OLDVAL),
	valid_path(B,OLDX,OLDY,X,Y,EX,EY,OLDVAL).

%list all possible choices for entity @coords OLDX,OLDY
%L1 contains positions and L2 ennemies killed on the path
%CURSOR is used to browse L1 and L2

%Possible move if it's a legal move and it's the only option of the list
possible(OLDX,OLDY,L1,L2,0) :-
	board(B),
	length(L1,1),
	length(L2,0),
	get2D(L1,0,0,X),
	get2D(L1,1,0,Y),
	nth0(0, L1, LINE),
	length(LINE,2),
	get2D(B,OLDX,OLDY,VAL),
	VAL>0,
	(VAL>2 ->
		DMAX is 10,
		BACKWARDS is 1;
		DMAX is 1,
		BACKWARDS is 0
	),
	is_legal_move(B,OLDX,OLDY,X,Y,DMAX,BACKWARDS,0).

%Possible eats if they're all legals and follow each other
possible(OLDX,OLDY,L1,L2,CURSOR) :-
	board(B),
	possible_eat(B,OLDX,OLDY,L1,L2,CURSOR).

possible_eat(B,OLDX,OLDY,L1,L2,CURSOR) :-
	get2D(B,OLDX,OLDY,VAL),
	VAL>0,
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
	possible_eat(NEWB,X,Y,L1,L2,CURSOR2).

%End condition
possible_eat(_,_,_,L1,L2,C) :-
	C>0,
	length(L1,C),
	length(L2,C).

%Answers yes if entity @coords X,Y is owned by player P
owned_by(P,X,Y) :-
	board(B),
	get2D(B,X,Y,VAL),
	VAL>0,
	TMP is VAL mod 2,
	TMP==P.

%Plays random move for player P
play_random(P,POS,MOVE) :-
	findall([X,Y],owned_by(P,X,Y),L),
	random_member(POS,L),
	nth0(0,POS,PX),
	nth0(1,POS,PY),
	findall([L1,L2],possible(PX,PY,L1,L2,0),LMOVES),
	length(LMOVES,LEN),
	LEN>0,
	random_member(MOVE,LMOVES).