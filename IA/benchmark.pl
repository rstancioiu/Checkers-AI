/** ------------------------------------------------
				Benchmark module
------------------------------------------------  */

:-  module(benchmark,[random_vs_random/1,
					  minmax_vs_random/1,
					  minmax_vs_minmax/1,
					  minmaxspecial_vs_minmax/1
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
	(check_draw ->
		WIN is -1;
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

random_vs_random(NB) :-
	nl,write(" --- TEST Random VS Random --- "),nl,
	write("Number of games : "),write(NB),nl,nl,
	write("Progress : "),
	test_versus(0,0,NB,play_random,play_random,W ,0, D),
	nl,nl,write("Balance : "),write(W),write("/"),write(NB),nl,
	nl,nl,write("Games drawn : "),write(D),nl,
	write(" --- TEST finished --- "),nl,nl,!.

minmax_vs_random(NB) :-
	nl,write(" --- TEST MinMax2 VS Random --- "),nl,
	write("Number of games : "),write(NB),nl,nl,
	write("Progress : "),
	test_versus(0,0,NB,play_random,play_minimax(2),W,0, D),
	nl,nl,write("Games won by MinMax2 : "),write(W),write("/"),write(NB),nl,
	nl,nl,write("Games drawn : "),write(D),nl,
	write(" --- TEST finished --- "),nl,nl,!.

minmax_vs_minmax(NB) :-
	nl,write(" --- TEST MinMax2 VS MinMax2 --- "),nl,
	write("Number of games : "),write(NB),nl,nl,
	write("Progress : "),
	test_versus(0,0,NB,play_minimax(2),play_minimax(2),W, 0, D),
	nl,nl,write("Games won by Minimax2 : "),write(W),write("/"),write(NB),nl,
	nl,nl,write("Games drawn : "),write(D),nl,	
	write(" --- TEST finished --- "),nl,nl,!.

minmaxspecial_vs_minmax(NB) :-
	nl,write(" --- TEST MinMaxSpecial2 VS MinMax2 --- "),nl,
	write("Number of games : "),write(NB),nl,nl,
	write("Progress : "),
	test_versus(0,0,NB,play_minimax_special(2),play_minimax(2),W,0, D),
	nl,nl,write("Games won by MinimaxSpecial2 : "),write(W),write("/"),write(NB),nl,
	nl,nl,write("Games drawn : "),write(D),nl,
	write(" --- TEST finished --- "),nl,nl,!.


minmaxalphabeta_vs_minmax(NB) :-
	nl,write(" --- TEST MinMaxAlphaBeta5 VS MinMax2 --- "),nl,
	write("Number of games : "),write(NB),nl,nl,
	write("Progress : "),
	test_versus(0,0,NB,play_minimax_alphabeta(5),play_minimax(2),W,0, D),
	nl,nl,write("Games won by MinMaxAlphaBeta5 : "),write(W),write("/"),write(NB),nl,
	nl,nl,write("Games drawn : "),write(D),nl,
	write(" --- TEST finished --- "),nl,nl,!.