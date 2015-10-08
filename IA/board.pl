:- dynamic board/1.
board([[0,1,0,1,0,1,0,1,0,1],
			 [1,0,1,0,1,0,1,0,1,0],
			 [0,1,0,1,0,1,0,1,0,1],
			 [1,0,1,0,1,0,1,0,1,0],
			 [0,0,0,0,0,0,0,0,0,0],
			 [0,0,0,0,0,0,0,0,0,0],
			 [0,2,0,2,0,2,0,2,0,2],
			 [2,0,2,0,2,0,2,0,2,0],
			 [0,2,0,2,0,2,0,2,0,2],
			 [2,0,2,0,2,0,2,0,2,0]]).

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
	
move(OLDX,OLDY,X,Y) :-
	board(B),
	%Backup old value, and set it to 0
	get2D(B,OLDX,OLDY,VAL),
	set2D(B,OLDX,OLDY,0,B2),
	%Set the value at new position
	set2D(B2,X,Y,VAL,B3),
	retract(board(_)),
	assert(board(B3)).