/** ------------------------------------------------
				Benchmark module
------------------------------------------------  */

:-  module(benchmark,[test_wrapper/5,
					  mega_test/0
					 ]).

:-  use_module(utility).
:-  use_module(iarandom).
:-  use_module(iaminmax).

versus(PRANDOM,TOUR,WIN,IA0,IA1) :-
	(PRANDOM==0 ->
		call(IA0,0,_)
		;
		call(IA1,1,_)
	),
	((check_draw ; TOUR>150) ->
		WIN is -1
		;
		(check_win_player(PRANDOM) ->
			WIN=PRANDOM
			;
			PNEXT is 1-PRANDOM,
			TOURNEXT is TOUR+1,
			versus(PNEXT,TOURNEXT,WIN,IA0,IA1)
		)
	).

%End condition
test_versus(COUNTER,WIN_MINMAX,NB,_,_,WFINAL,D_MINMAX,D) :-
	COUNTER==NB,
	D=D_MINMAX,
	write(NB),
	WFINAL=WIN_MINMAX,!.

%Loop
test_versus(COUNTER,WIN_MINMAX,NB,IA0,IA1,WFINAL,D_MINMAX,D) :-
	COUNTER>=0,
	COUNTER<NB,
	init,
	versus(0,0,W,IA0,IA1),
	write(COUNTER),write('-'),flush_output,
	( (W>=0) ->
		WIN_MINMAX2 is WIN_MINMAX+W,
		COUNTER2 is COUNTER+1,
		D_MINMAX2 is D_MINMAX
		;
		WIN_MINMAX2 is WIN_MINMAX,
		D_MINMAX2 is D_MINMAX+1,
		COUNTER2 is COUNTER+1
	),
	test_versus(COUNTER2,WIN_MINMAX2,NB,IA0,IA1,WFINAL,D_MINMAX2,D).

test_wrapper(SP1,SP2,IA1,IA2,NB) :-
	nl,write(" --- TEST "),write(SP1),write(" VS "),write(SP2),write(" --- "),nl,
	write("Number of games : "),write(NB),nl,nl,
	write("Progress : "),
	test_versus(0,0,NB,IA2,IA1,W,0,D),
	nl,nl,write("Games won by P1 : "),write(W),write("/"),write(NB),nl,
	W2 is (NB-W-D),
	nl,nl,write("Games won by P2 : "),write(W2),write("/"),write(NB),nl,
	nl,nl,write("Games drawn : "),write(D),nl,
	write(" --- TEST finished --- "),nl,nl,!.

mega_test() :-
	%test_wrapper("Random","Random",play_random,play_random,200),
	%test_wrapper("Heuristique","Random",play_heuristique,play_random,20),
	%test_wrapper("MinMax","Random",play_minimax(3),play_random,20),
	%test_wrapper("MinMaxSpecial","Random",play_minimax_special(3),play_random,20),