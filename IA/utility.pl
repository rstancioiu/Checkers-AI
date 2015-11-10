/** ------------------------------------------------
				Utility module
------------------------------------------------  */

:- module(utility,[init/0,
				   game/0,
				   board/1,
				   make_move/4,
				   possible/7,
				   select_kills/2,
				   check_win/2,
				   check_win_player/1,
				   check_draw/0,
				   owned_by/4,
				   pawns_owned_by/4,
				   queens_owned_by/4
				   ]).

%Initialize board
:- dynamic board/1.
init :-
	(board(_) ->
		retract(board(_)),
		init
		;
		assert(board([[0,1,0,1,0,1,0,1,0,1],
	          		 [1,0,1,0,1,0,1,0,1,0],
	         		 [0,1,0,1,0,1,0,1,0,1],
	         		 [1,0,1,0,1,0,1,0,1,0],
	         		 [0,0,0,0,0,0,0,0,0,0],
	         		 [0,0,0,0,0,0,0,0,0,0],
	         		 [0,2,0,2,0,2,0,2,0,2],
	         		 [2,0,2,0,2,0,2,0,2,0],
	         		 [0,2,0,2,0,2,0,2,0,2],
	         		 [2,0,2,0,2,0,2,0,2,0]]))
	).

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
	set2D(B2,X,Y,VAL,NEWB).

eat(B,OLDX,OLDY,X,Y,EX,EY,NEWB) :-
	%Kill ennemy
	set2D(B,EX,EY,0,B2),
	%Backup old value, and set it to 0
	get2D(B2,OLDX,OLDY,VAL),
	set2D(B2,OLDX,OLDY,0,B3),
	%Set the value at new position
	set2D(B3,X,Y,VAL,NEWB).

%End condition
make_move(B,MOVE,FINALB,C) :-
	nth0(2,MOVE,POS),
	C>0,
	length(POS,C),
	last(POS,FINALPOS),
	nth0(0,FINALPOS,X),
	nth0(1,FINALPOS,Y),
	%Turn into queen if necessary
	check_queen(B,X,Y,FINALB).

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
		move(B,X,Y,NEWX,NEWY,B2),
		C2 is C+1,
		make_move(B2,MOVE,NEWB,C2)
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
	is_legal_move(B,OLDX,OLDY,X,Y,DMAX,BACKWARDS,1).

%Possible eats if they are all legals and follow each other
possible(B,P,OLDX,OLDY,L1,L2,CURSOR) :-
	possible_eat(B,P,OLDX,OLDY,L1,L2,CURSOR).

%End condition
possible_eat(_,_,_,_,L1,L2,C) :-
	C>0,
	length(L1,C),
	length(L2,C).

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

%End condition
max_kills(MOVES,MAX,C,FINALMAX) :-
	C>0,
	length(MOVES,C),
	FINALMAX=MAX.

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

owned_by(B,P,X,Y) :-
	get2D(B,X,Y,VAL),
	VAL>0,
	TMP is VAL mod 2,
	TMP==P.

pawns_owned_by(B,P,X,Y) :-
	get2D(B,X,Y,VAL),
	VAL<3,
	VAL>0,
	TMP is VAL mod 2,
	TMP==P.

queens_owned_by(B,P,X,Y) :-
	get2D(B,X,Y,VAL),
	VAL>2,
	TMP is VAL mod 2,
	TMP==P.

check_win_player(P1) :-
	board(B),
	check_win(B,P1).

%Win if the other player cannot move or has nothing left on board
check_win(B,P1) :-
	P2 is 1-P1,
	findall([PX,PY,L1,L2],possible(B,P2,PX,PY,L1,L2,0),L),
	length(L,LEN),
	LEN==0.

check_draw :-
	board(B),
	findall([X,Y],owned_by(B,0,X,Y),L1),
	findall([X,Y],queens_owned_by(B,0,X,Y),QL1),
	findall([X,Y],owned_by(B,1,X,Y),L2),
	findall([X,Y],queens_owned_by(B,1,X,Y),QL2),
	length(L1,LEN1),length(L2,LEN2),length(QL1,LENQ1),length(QL2,LENQ2),
	((LEN1==1,LEN2==1,LENQ1==1,LENQ2==1);(LEN1==2,LEN2==1,LENQ1==2,LENQ2==1);
		(LEN1==1,LEN2==2,LENQ1==1,LENQ2==2);(LEN1==1,LEN2==2,LENQ1==1,LENQ2==1);
		(LEN1==2,LEN2==1,LENQ1==1,LENQ2==1))
	.