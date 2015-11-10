/** ------------------------------------------------
				Min Max IA module
------------------------------------------------  */

:-  module(iaminmax,[play_minimax/3,
					 play_minimax_special/3,
					 play_minimax_alphabeta/3
					 ]).
:-  use_module(utility).

%Evaluation function for special minimax
%Valorizes pawns advancing on the board and queens
evaluate_special(BF,P,E) :-
	board(B),
	findall([Y],pawns_owned_by(B,P,X,Y),L1),
	findall([Y],pawns_owned_by(BF,P,X,Y),L3),
	findall([X,Y],queens_owned_by(B,P,X,Y),QL1),
	findall([X,Y],queens_owned_by(BF,P,X,Y),QL3),
	OTHERP is 1-P,
	findall([Y],pawns_owned_by(B,OTHERP,X,Y),L2),
	findall([Y],pawns_owned_by(BF,OTHERP,X,Y),L4),
	findall([X,Y],queens_owned_by(B,OTHERP,X,Y),QL2),
	findall([X,Y],queens_owned_by(BF,OTHERP,X,Y),QL4),
	sumlist(L1,NBPA1),sumlist(L2,NBPA2),sumlist(L3,NBPA3),sumlist(L4,NBPA4),
	length(QL1,NBQ1),length(QL2,NBQ2),length(QL3,NBQ3),length(QL4,NBQ4),
	((P==0) ->
		length(L1,LEN1),LEN1_AUX=9*LEN1,NBP1_AUX=LEN1_AUX-NBPA1,NBP1 is NBP1_AUX,
		length(L2,LEN2),LEN2_AUX=9*LEN2,NBP2_AUX=LEN2_AUX-NBPA2,NBP2 is NBP2_AUX,
		length(L3,LEN3),LEN3_AUX=9*LEN3,NBP3_AUX=LEN3_AUX-NBPA3,NBP3 is NBP3_AUX,
		length(L4,LEN4),LEN4_AUX=9*LEN4,NBP4_AUX=LEN4_AUX-NBPA4,NBP4 is NBP4_AUX
		;
		NBP1 is NBPA1,NBP2 is NBPA2,NBP3 is NBPA3,NBP4 is NBPA4
	),
	E is ((NBP4+NBP1-NBP2-NBP3)+(NBQ4+NBQ1-NBQ2-NBQ3)*25).

%Evaluation function for basic minmax : count pawns/queens owned
evaluate(B,P,E) :-
	findall([X,Y],owned_by(B,P,X,Y),L),
	OTHERP is 1-P,
	findall([X,Y],owned_by(B,OTHERP,X,Y),L2),
	length(L,NBP),
	length(L2,NBOP),
	E is (NBP+(20-NBOP)).

evaluate_special2(B,P,E) :-
	findall([X,Y],pawns_owned_by(B,P,X,Y),L1),
	findall([X,Y],queens_owned_by(B,P,X,Y),L3),
	OTHERP is 1-P,
	findall([X,Y],pawns_owned_by(B,OTHERP,X,Y),L2),
	findall([X,Y],queens_owned_by(B,P,X,Y),L4),
	length(L1,NBP),
	length(L2,NBOP),
	length(L3,NPQP),
	length(L4,NPQOP),
	E is ((NBP-NBOP)*2+(NPQP-NPQOP)*5).

max(X,Y,Y) :- X =< Y.
max(X,Y,X) :- X>Y.
min(X,Y,Y) :- X >= Y.
min(X,Y,X) :- X<Y.

%End condition
ia_cmp(_,MOVES,_,_,_,E,MOVECUR,MOVEWIN,_,CURSOR,ECUR,_,_) :-
	CURSOR>0,
	length(MOVES,CURSOR),
	E=ECUR,
	MOVEWIN=MOVECUR.

ia_cmp(B,MOVES,P,DEPTH,Dinit,E,MOVECUR,MOVEWIN,Pinit,CURSOR,ECUR,GOAL,EQ) :-
	nth0(CURSOR,MOVES,MOVE),
	make_move(B,MOVE,B2,0),
	P2 is 1-P,
	(check_win(B2,P2) ->
		MOVEWIN=MOVE,
		member(E,[-9999,9999]),
		call(GOAL,E,9999,E),
		call(GOAL,E,-9999,E)
		;
		minimax(B2,_,DEPTH,Dinit,E2,P,Pinit),
		((call(GOAL,E2,ECUR,E2)) ->
			(E2==ECUR ->
				NEWWIN is E2,
				EQ1 is EQ+1,
				X is random(EQ1),
				(X==0 ->
					NEWMOVECUR=MOVE
					;
					NEWMOVECUR=MOVECUR
				)
				;
				NEWWIN is E2,
				NEWMOVECUR=MOVE,
				EQ1 is 1
			)
			;
			EQ1 is EQ,
			NEWWIN is ECUR,
			NEWMOVECUR=MOVECUR
		),
		NEWC is CURSOR+1,
		ia_cmp(B,MOVES,P,DEPTH,Dinit,E,NEWMOVECUR,MOVEWIN,Pinit,NEWC,NEWWIN,GOAL,EQ1) 
	).

minimax(B,MOV,DEPTH,Dinit,E,P,Pinit):-
	(DEPTH==0 ->
		evaluate(B,Pinit,E)
		;
		findall([PX,PY,L1,L2],possible(B,P,PX,PY,L1,L2,0),LMOVES),
		select_kills(LMOVES,NEWMOVES),
		P2 is 1-P,
		D2 is DEPTH-1,
		(P==Pinit ->
			ia_cmp(B,NEWMOVES,P2,D2,Dinit,E,_,R,Pinit,0,-10000,max,0)
			;
			ia_cmp(B,NEWMOVES,P2,D2,Dinit,E,_,R,Pinit,0,10000,min,0)
		),
		(DEPTH==Dinit ->
			MOV=R
			;
			true
		)
	).

minimax_special(B,MOV,DEPTH,Dinit,E,P,Pinit):-
	(DEPTH==0 ->
		evaluate_special(B,Pinit,E)
		;
		findall([PX,PY,L1,L2],possible(B,P,PX,PY,L1,L2,0),LMOVES),
		select_kills(LMOVES,NEWMOVES),
		P2 is 1-P,
		D2 is DEPTH-1,
		(P==Pinit ->
			ia_cmp(B,NEWMOVES,P2,D2,Dinit,E,_,R,Pinit,0,-10000,max,0)
			;
			ia_cmp(B,NEWMOVES,P2,D2,Dinit,E,_,R,Pinit,0,10000,min,0)
		),
		(DEPTH==Dinit ->
			MOV=R
			;
			true
		)
	).

play_minimax(D,P,MOVE) :-
	board(B),
	minimax(B,MOVE,D,D,_,P,P),
	make_move(B,MOVE,NEWB,0),
	retract(board(_)),
	assert(board(NEWB)),!.

play_minimax_special(D,P,MOVE) :-
	board(B),
	minimax_special(B,MOVE,D,D,_,P,P),
	make_move(B,MOVE,NEWB,0),
	retract(board(_)),
	assert(board(NEWB)),!.

%End condition
ia_cmp_alphabeta(_,MOVES,_,_,_,E,MOVECUR,MOVEWIN,_,CURSOR,ECUR,_,_,_,_) :-
	CURSOR>0,
	length(MOVES,CURSOR),
	E=ECUR,
	MOVEWIN=MOVECUR.

ia_cmp_alphabeta(B,MOVES,P,DEPTH,Dinit,E,MOVECUR,MOVEWIN,Pinit,CURSOR,ECUR,GOAL,EQ,ALPHA,BETA) :-
	nth0(CURSOR,MOVES,MOVE),
	make_move(B,MOVE,B2,0),
	P2 is 1-P,
	(check_win(B2,P2) ->
		MOVEWIN=MOVE,
		member(E,[-9999,9999]),
		call(GOAL,E,9999,E),
		call(GOAL,E,-9999,E)
		;
		minimax_alphabeta(B2,_,DEPTH,Dinit,E2,P,Pinit,ALPHA,BETA),
		((call(GOAL,E2,ECUR,E2)) ->
			(E2==ECUR ->
				NEWWIN is E2,
				EQ1 is EQ+1,
				X is random(EQ1),
				(X==0 ->
					NEWMOVECUR=MOVE
					;
					NEWMOVECUR=MOVECUR
				)
				;
				NEWWIN is E2,
				NEWMOVECUR=MOVE,
				EQ1 is 1
			);
			EQ1 is EQ,
			NEWWIN is ECUR,
			NEWMOVECUR=MOVECUR
		),
		(call(GOAL,1,0,1) ->
			(ALPHA>NEWWIN ->
				ALPHA2 is ALPHA;
				ALPHA2 is NEWWIN
			),
			BETA2 is BETA,
			(ALPHA2<BETA2 ->
				NEWC is CURSOR+1,
				ia_cmp_alphabeta(B,MOVES,P,DEPTH,Dinit,E,NEWMOVECUR,MOVEWIN,Pinit,NEWC,NEWWIN,GOAL,EQ1,ALPHA2,BETA2);
				MOVEWIN=NEWMOVECUR,
				E is NEWWIN
			)
			;
			(BETA<NEWWIN ->
				BETA2 is BETA;
				BETA2 is NEWWIN
			),
			ALPHA2 is ALPHA,
			(ALPHA2>BETA2 ->
				NEWC is CURSOR+1,
				ia_cmp_alphabeta(B,MOVES,P,DEPTH,Dinit,E,NEWMOVECUR,MOVEWIN,Pinit,NEWC,NEWWIN,GOAL,EQ1,ALPHA2,BETA2);
				MOVEWIN=NEWMOVECUR,
				E is NEWWIN
			)
		)
	).


minimax_alphabeta(B,MOV,DEPTH,Dinit,E,P,Pinit,ALPHA,BETA):-
	(DEPTH==0 ->
		evaluate_special2(B,Pinit,E)
		;
		findall([PX,PY,L1,L2],possible(B,P,PX,PY,L1,L2,0),LMOVES),
		select_kills(LMOVES,NEWMOVES),
		P2 is 1-P,
		D2 is DEPTH-1,
		(P==Pinit ->
			ia_cmp_alphabeta(B,NEWMOVES,P2,D2,Dinit,E,_,R,Pinit,0,-10000,max,0,ALPHA,BETA)
			;
			ia_cmp_alphabeta(B,NEWMOVES,P2,D2,Dinit,E,_,R,Pinit,0,10000,min,0,ALPHA,BETA)
		),
		(DEPTH==Dinit ->
			MOV=R
			;
			true
		)
).

play_minimax_alphabeta(D,P,MOVE) :-
	board(B),
	minimax_alphabeta(B,MOVE,D,D,_,P,P,-9999,9999),
	make_move(B,MOVE,NEWB,0),
	retract(board(_)),
	assert(board(NEWB)),!.