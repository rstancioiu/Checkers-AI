:- dynamic board/1.
board([[0,2,0,1,0,1,0,1,0,1],
			 [1,0,1,0,1,0,1,0,1,0],
			 [0,1,0,1,0,1,0,1,0,1],
			 [1,0,3,0,1,0,1,0,1,0],
			 [0,0,0,0,0,0,0,0,0,0],
			 [0,0,0,0,0,0,0,0,0,0],
			 [0,2,0,0,0,2,0,2,0,2],
			 [2,0,2,0,2,0,2,0,2,0],
			 [0,1,0,2,0,2,0,2,0,2],
			 [1,0,0,0,2,0,2,0,2,0]]).

game :- 
	write('********************'),nl,
	write(' Prolog Checkers    '),nl,
	write('********************'),nl,
	board(B),
	show_board(B).
	
show_board([L1,L2,L3,L4,L5,L6,L7,L8,L9,L10]) :-
	show_line(L1),nl,show_line(L2),nl,show_line(L3),nl,show_line(L4),nl,show_line(L5),nl,show_line(L6),nl,show_line(L7),nl,show_line(L8),nl,show_line(L9),nl,show_line(L10),nl.
	
show_line([L1,L2,L3,L4,L5,L6,L7,L8,L9,L10]) :-
	write(L1),write(L2),write(L3),write(L4),write(L5),write(L6),write(L7),write(L8),write(L9),write(L10).

%Count how many times P is true
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

%Turn pawn into queen
check_queen(X,Y) :-
	board(B),
	get2D(B,X,Y,VAL),
	(((Y==0, VAL==2); (Y==9, VAL==1)) ->
		VAL2 is VAL+2,
		set2D(B,X,Y,VAL2,B2),	
		retract(board(_)),
		assert(board(B2))
	;
	true
	).
	
move(OLDX,OLDY,X,Y,DMAX) :-
	board(B),
	is_legal_move(OLDX,OLDY,X,Y,DMAX,0,1),
	%Backup old value, and set it to 0
	get2D(B,OLDX,OLDY,VAL),
	set2D(B,OLDX,OLDY,0,B2),
	%Set the value at new position
	set2D(B2,X,Y,VAL,B3),
	%Turn into queen if necessary
	retract(board(_)),
	assert(board(B3)),
	check_queen(X,Y).

eat(OLDX,OLDY,X,Y,DMAX) :-
	board(B),
	is_legal_eat(OLDX,OLDY,X,Y,DMAX,EX,EY),
	%Kill ennemy
	set2D(B,EX,EY,0,B2),
	%Backup old value, and set it to 0
	get2D(B2,OLDX,OLDY,VAL),
	set2D(B2,OLDX,OLDY,0,B3),
	%Set the value at new position
	set2D(B3,X,Y,VAL,B4),
	%Turn into queen if necessary
	retract(board(_)),
	assert(board(B4)),
	check_queen(X,Y).

%Check empty path
empty_path(X,Y,X,Y) :- !.
empty_path(OLDX,OLDY,X,Y) :-
	board(B),
	TX is OLDX+sign(X-OLDX),
	TY is OLDY+sign(Y-OLDY),
	get2D(B,TX,TY,VAL),
	VAL==0,
	empty_path(TX,TY,X,Y).
	
%Find unique ennemy on path
valid_path(OLDX,OLDY,X,Y,EX,EY,OLDVAL) :-
	board(B),
	TX is OLDX+sign(X-OLDX),
	TX \= X,
	TY is OLDY+sign(Y-OLDY),
	get2D(B,TX,TY,TVAL),
	(TVAL==0 -> %if empty, recursive call
		valid_path(TX,TY,X,Y,EX,EY,OLDVAL)
		; % else, in case of ennemy, look for empty path
		AVG is (OLDVAL+TVAL)/2,
		float_fractional_part(AVG)>0,
		EX is TX,
		EY is TY,
		empty_path(TX,TY,X,Y)
	).
	
%basic move, BACKWARDS=1 or 0, STRICT=1 or 0
is_legal_move(OLDX,OLDY,X,Y,DMAX,BACKWARDS,STRICT) :-
	board(B),
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
		empty_path(OLDX,OLDY,X,Y);
		true
	).

%basic eat pawn
is_legal_eat(OLDX,OLDY,X,Y,DMAX,EX,EY) :-
	board(B),
	DMAX==1,
	is_legal_move(OLDX,OLDY,X,Y,DMAX+1,1,0),
	get2D(B,OLDX,OLDY,OLDVAL),
	EX is (OLDX+X)/2,
	EY is (OLDY+Y)/2,
	get2D(B,EX,EY,TVAL),
  AVG is (OLDVAL+TVAL)/2,
	float_fractional_part(AVG)>0,!.
	
%basic eat queen
is_legal_eat(OLDX,OLDY,X,Y,DMAX,EX,EY) :-
	board(B),
	DMAX>1,
	is_legal_move(OLDX,OLDY,X,Y,DMAX,1,0),
	get2D(B,OLDX,OLDY,OLDVAL),
	valid_path(OLDX,OLDY,X,Y,EX,EY,OLDVAL).