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
	show1(B).
	
show1([L1,L2,L3,L4,L5,L6,L7,L8,L9,L10]) :-
	show2(L1),nl,show2(L2),nl,show2(L3),nl,show2(L4),nl,show2(L5),nl,show2(L6),nl,show2(L7),nl,show2(L8),nl,show2(L9),nl,show2(L10),nl.

show2([L1,L2,L3,L4,L5,L6,L7,L8,L9,L10]) :-
	write(L1),write(L2),write(L3),write(L4),write(L5),write(L6),write(L7),write(L8),write(L9),write(L10).

replace([_|T], 0, X, [X|T]) :- !.
replace([H|T], I, X, [H|R]):- I > 0, NI is I-1, replace(T, NI, X, R).

move1(OLDX,OLDY,X,Y) :-
	board(B),
	nth0(OLDY, B, LINE),
	nth0(OLDX, LINE, VAL),
	replace(LINE, OLDX, 0, LINE2),
	replace(B, OLDY, LINE2, NEWB),
	nth0(Y, NEWB, NEWLINE),
	replace(NEWLINE, X, VAL, NEWLINE2),
	replace(NEWB, Y, NEWLINE2, NEWB2),
	show1(NEWB2).